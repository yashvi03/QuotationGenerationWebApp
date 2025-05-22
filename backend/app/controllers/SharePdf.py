from flask import Flask, request, jsonify, Blueprint, redirect
import boto3
import os
import urllib.parse
import uuid
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

share_quotation_bp = Blueprint("share_quotation", __name__)

# Simple in-memory storage for tokens (use Redis/DB in production)
temp_links = {}

# Initialize S3 client
try:
    s3_client = boto3.client(
        "s3",
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY'),
        aws_secret_access_key=os.getenv('SHARE_SECRET_KEY'),
        region_name=os.getenv('AWS_REGION')
    )
    print("✅ S3 client initialized successfully")
except Exception as e:
    print(f"❌ Error initializing S3 client: {e}")

def cleanup_expired_links():
    """Remove expired links"""
    current_time = datetime.now()
    expired_keys = [
        key for key, data in temp_links.items() 
        if data['expires_at'] < current_time
    ]
    for key in expired_keys:
        del temp_links[key]
    print(f"🧹 Cleaned up {len(expired_keys)} expired links")

# Route to upload a PDF to S3
@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        file = request.files.get("file")
        if not file:
            print("❌ No file found in request")
            return jsonify({"error": "No file uploaded"}), 400

        file_name = f"quotations/{datetime.now().strftime('%Y%m%d%H%M%S')}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        print(f"📂 Uploading file {file_name} to bucket {bucket_name}")

        # Upload to S3
        s3_client.upload_fileobj(
            file,
            bucket_name,
            file_name,
            ExtraArgs={
                'ContentType': 'application/pdf',
                'ContentDisposition': 'attachment'
            }
        )

        print("✅ File uploaded successfully!")
        return jsonify({
            "message": "File uploaded successfully!", 
            "file_name": file_name
        })

    except Exception as e:
        print(f"❌ Error uploading file: {e}")
        return jsonify({"error": str(e)}), 500

# Route to generate user-friendly URL & WhatsApp link
@share_quotation_bp.route("/get-signed-url", methods=["GET"])
def get_presigned_url():
    try:
        # Get parameters
        file_name = request.args.get("file_name")
        phone_number = request.args.get("phone_number", "9374808167")  # Default or from request
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")

        if not file_name:
            print("❌ No file name provided in request")
            return jsonify({"error": "File name is required"}), 400

        print(f"🔗 Processing request for file: {file_name}")
        print(f"📱 Phone: {phone_number}")
        print(f"👤 Customer: {customer_name}")
        print(f"🆔 Quotation ID: {quotation_id}")

        # Clean up expired links first
        cleanup_expired_links()

        # Generate a short, friendly token
        token = str(uuid.uuid4())[:8]  # Short 8-character token
        
        # Store the mapping with expiration
        temp_links[token] = {
            'file_name': file_name,
            'expires_at': datetime.now() + timedelta(hours=24),  # 24 hours expiry
            'created_at': datetime.now(),
            'accessed': False
        }

        # Create user-friendly URL
        base_url = request.url_root.rstrip('/')
        friendly_url = f"{base_url}/pdf/{token}"

        print(f"🔗 Generated friendly URL: {friendly_url}")

        # Create WhatsApp message
        greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
        quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
        message = f"{greeting}Here is {quotation_text} from our company. Click here to view: {friendly_url}"
        
        # Format phone number (ensure it has country code)
        if len(phone_number) == 10:
            phone_number = "91" + phone_number  # Add India country code
        
        encoded_message = urllib.parse.quote(message)
        whatsapp_link = f"https://api.whatsapp.com/send?phone={phone_number}&text={encoded_message}"

        print(f"📲 WhatsApp link generated successfully")
        print(f"💾 Token {token} stored, active links: {len(temp_links)}")

        return jsonify({
            "url": friendly_url,
            "whatsapp_link": whatsapp_link,
            "token": token,
            "expires_in": "24 hours"
        })

    except Exception as e:
        print(f"❌ Error generating URLs: {e}")
        import traceback
        print(f"❌ Full error: {traceback.format_exc()}")
        return jsonify({"error": str(e)}), 500

# User-friendly PDF serving route
@share_quotation_bp.route("/pdf/<token>", methods=["GET"])
def serve_pdf(token):
    try:
        print(f"🔗 Serving PDF for token: {token}")
        
        # Clean up expired links
        cleanup_expired_links()
        
        # Check if token exists
        if token not in temp_links:
            print(f"❌ Invalid token: {token}")
            return jsonify({"error": "Invalid or expired link"}), 404

        # Get file info
        file_info = temp_links[token]
        file_name = file_info['file_name']
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"📄 Generating presigned URL for: {file_name}")

        # Generate presigned URL (same as your working code)
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600,  # 1 hour expiry
        )

        # Mark as accessed
        temp_links[token]['accessed'] = True
        temp_links[token]['accessed_at'] = datetime.now()

        print(f"✅ Redirecting to S3 URL")
        
        # Redirect to the actual S3 URL
        return redirect(presigned_url)

    except Exception as e:
        print(f"❌ Error serving PDF: {e}")
        import traceback
        print(f"❌ Full error: {traceback.format_exc()}")
        return jsonify({"error": f"Unable to serve file: {str(e)}"}), 500

# Alternative route that matches your original pattern
@share_quotation_bp.route("/api/pdf/<token>", methods=["GET"])
def serve_pdf_api(token):
    """Alternative endpoint that matches your frontend expectation"""
    return serve_pdf(token)

# Debug route to check stored links
@share_quotation_bp.route("/debug/links", methods=["GET"])
def debug_links():
    try:
        cleanup_expired_links()
        return jsonify({
            "active_links": len(temp_links),
            "links": {
                token: {
                    "file_name": info["file_name"],
                    "expires_at": info["expires_at"].isoformat(),
                    "accessed": info.get("accessed", False),
                    "created_at": info["created_at"].isoformat()
                }
                for token, info in temp_links.items()
            }
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Health check
@share_quotation_bp.route("/health", methods=["GET"])
def health_check():
    try:
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        # Test S3 connection
        s3_client.head_bucket(Bucket=bucket_name)
        
        return jsonify({
            "status": "healthy",
            "s3_connection": "ok",
            "active_links": len(temp_links),
            "timestamp": datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 500