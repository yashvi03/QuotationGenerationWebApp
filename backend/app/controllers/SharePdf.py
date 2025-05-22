from flask import Flask, request, jsonify, Blueprint, redirect
import boto3
import os
import urllib.parse
import uuid
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

share_quotation_bp = Blueprint("share_quotation", __name__)

# In-memory storage for temporary links (use Redis/DB in production)
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

def format_phone_number(phone_number):
    """Format phone number for WhatsApp API"""
    if not phone_number:
        return None
    
    cleaned_number = ''.join(filter(str.isdigit, str(phone_number)))
    
    if len(cleaned_number) == 10:
        cleaned_number = "91" + cleaned_number
    elif len(cleaned_number) == 11 and cleaned_number.startswith("0"):
        cleaned_number = "91" + cleaned_number[1:]
    elif len(cleaned_number) == 12 and cleaned_number.startswith("91"):
        pass
    
    return cleaned_number

def generate_temp_token():
    """Generate a temporary secure token"""
    return str(uuid.uuid4())

def cleanup_expired_links():
    """Remove expired temporary links"""
    current_time = datetime.now()
    expired_keys = [
        key for key, data in temp_links.items() 
        if data['expires_at'] < current_time
    ]
    for key in expired_keys:
        del temp_links[key]

# Route to upload a PDF to S3
@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        file = request.files.get("file")

        if not file:
            print("❌ No file found in request")
            return jsonify({"error": "No file uploaded"}), 400

        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        file_name = f"quotations/quotation_{timestamp}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"📂 Uploading file {file_name} to bucket {bucket_name}")

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
            "file_name": file_name,
            "timestamp": timestamp
        })

    except Exception as e:
        print(f"❌ Error uploading file: {e}")
        return jsonify({"error": str(e)}), 500

# FIXED: Updated get-signed-url route with different URL pattern
@share_quotation_bp.route("/get-signed-url", methods=["GET"])
def get_presigned_url():
    try:
        print("🔄 Starting get-signed-url request")
        
        # Get parameters
        file_name = request.args.get("file_name")
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")
        
        print(f"📋 Parameters: file_name={file_name}, phone={phone_number}, customer={customer_name}, quotation_id={quotation_id}")

        # Validation
        if not file_name:
            print("❌ No file name provided")
            return jsonify({"error": "File name is required"}), 400

        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            print("❌ Invalid phone number")
            return jsonify({"error": "Valid phone number is required"}), 400

        print(f"✅ Phone formatted: {formatted_phone}")

        # Generate friendly token and ID
        try:
            timestamp = datetime.now().strftime('%Y%m%d')
            friendly_id = quotation_id if quotation_id else f"Q{timestamp}"
            temp_token = generate_temp_token()[:8]  # Shorter token
            print(f"🔑 Generated token: {temp_token}, friendly_id: {friendly_id}")
        except Exception as token_error:
            print(f"❌ Error generating token: {token_error}")
            raise token_error
        
        # Store token info
        try:
            expires_at = datetime.now() + timedelta(hours=24)
            temp_links[temp_token] = {
                'file_name': file_name,
                'expires_at': expires_at,
                'quotation_id': friendly_id,
                'accessed': False
            }
            print(f"💾 Stored token info: {temp_links[temp_token]}")
        except Exception as storage_error:
            print(f"❌ Error storing token: {storage_error}")
            raise storage_error

        # Clean up expired links
        try:
            cleanup_expired_links()
            print(f"🧹 Cleanup completed. Active links: {len(temp_links)}")
        except Exception as cleanup_error:
            print(f"⚠️ Cleanup error (non-critical): {cleanup_error}")

        # FIXED: Create URL that won't conflict with React Router
        try:
            # Use a fallback if request.url_root is not available
            base_url = getattr(request, 'url_root', 'http://localhost:5000/').rstrip('/')
            # Changed URL pattern to avoid React Router conflicts
            friendly_url = f"{base_url}/api/pdf/{temp_token}"
            print(f"🔗 Generated friendly URL: {friendly_url}")
        except Exception as url_error:
            print(f"❌ Error creating URL: {url_error}")
            raise url_error

        # Create WhatsApp message
        try:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            
            message = f"{greeting}Here is {quotation_text} from our company. Click here to view: {friendly_url}"
            
            encoded_message = urllib.parse.quote(message)
            whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"
            print(f"📲 WhatsApp link created successfully")
        except Exception as message_error:
            print(f"❌ Error creating message: {message_error}")
            raise message_error

        print("✅ Request completed successfully")
        return jsonify({
            "url": friendly_url,  # Keep this for backward compatibility
            "friendly_url": friendly_url,
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "expires_in": "24 hours",
            "token": temp_token
        })

    except Exception as e:
        print(f"❌ Error in get_presigned_url: {str(e)}")
        print(f"❌ Error type: {type(e).__name__}")
        import traceback
        print(f"❌ Full traceback: {traceback.format_exc()}")
        return jsonify({"error": f"Internal server error: {str(e)}"}), 500

# FIXED: New route that won't conflict with React Router
@share_quotation_bp.route("/api/pdf/<token>", methods=["GET"])
def serve_pdf_by_token(token):
    try:
        # Clean up expired links first
        cleanup_expired_links()
        
        # Check if token exists and is valid
        if token not in temp_links:
            return jsonify({"error": "Invalid or expired download link"}), 404

        file_info = temp_links[token]
        file_name = file_info['file_name']
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"🔗 Serving file {file_name} via proxy")

        # Generate short-lived presigned URL (1 hour)
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600  # 1 hour
        )

        # Mark as accessed (optional - for analytics)
        temp_links[token]['accessed'] = True
        temp_links[token]['accessed_at'] = datetime.now()

        # Redirect to the presigned URL
        return redirect(presigned_url)

    except Exception as e:
        print(f"❌ Error serving file: {e}")
        return jsonify({"error": "Unable to serve file"}), 500

# Legacy routes (keeping for backward compatibility)
@share_quotation_bp.route("/download/<token>", methods=["GET"])
def download_file(token):
    try:
        cleanup_expired_links()
        
        if token not in temp_links:
            return jsonify({"error": "Invalid or expired download link"}), 404

        file_info = temp_links[token]
        file_name = file_info['file_name']
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"🔗 Serving file {file_name} via proxy")

        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600
        )

        temp_links[token]['accessed'] = True
        temp_links[token]['accessed_at'] = datetime.now()

        return redirect(presigned_url)

    except Exception as e:
        print(f"❌ Error serving file: {e}")
        return jsonify({"error": "Unable to serve file"}), 500

@share_quotation_bp.route("/download/quotation/<quotation_id>/<token>", methods=["GET"])
def view_quotation(quotation_id, token):
    try:
        cleanup_expired_links()
        
        if token not in temp_links:
            return jsonify({"error": "Invalid or expired quotation link"}), 404

        file_info = temp_links[token]
        file_name = file_info['file_name']
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600
        )

        return redirect(presigned_url)

    except Exception as e:
        print(f"❌ Error viewing quotation: {e}")
        return jsonify({"error": "Unable to view quotation"}), 500

# Route for custom WhatsApp messages
@share_quotation_bp.route("/get-whatsapp-link", methods=["GET"])
def get_whatsapp_link():
    try:
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")
        message_text = request.args.get("message", "")

        if not phone_number:
            return jsonify({"error": "Phone number is required"}), 400

        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            return jsonify({"error": "Valid phone number is required"}), 400

        # Create message without exposing URLs
        if message_text:
            message = message_text
        else:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            message = f"{greeting}Thank you for your interest! {quotation_text} has been prepared. Please check your email or contact us for the document."

        encoded_message = urllib.parse.quote(message)
        whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"

        return jsonify({
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "message": message
        })

    except Exception as e:
        print(f"❌ Error generating WhatsApp link: {e}")
        return jsonify({"error": str(e)}), 500

# Route to delete uploaded file from S3
@share_quotation_bp.route("/delete-quotation", methods=["DELETE"])
def delete_file():
    try:
        file_name = request.args.get("file_name")
        
        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        s3_client.delete_object(Bucket=bucket_name, Key=file_name)
        
        print(f"✅ File {file_name} deleted successfully from S3")
        return jsonify({"message": "File deleted successfully"})

    except Exception as e:
        print(f"❌ Error deleting file: {e}")
        return jsonify({"error": str(e)}), 500

# Clean up expired links periodically
@share_quotation_bp.route("/cleanup-expired", methods=["POST"])
def manual_cleanup():
    cleanup_expired_links()
    return jsonify({"message": f"Cleaned up expired links. Active links: {len(temp_links)}"})