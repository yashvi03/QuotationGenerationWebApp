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

# SOLUTION 1: Proxy Route (Recommended)
# @share_quotation_bp.route("/get-signed-url", methods=["GET"])
# def get_presigned_url():
#     try:
#         file_name = request.args.get("file_name")
#         phone_number = request.args.get("phone_number")
#         customer_name = request.args.get("customer_name", "")
#         quotation_id = request.args.get("quotation_id", "")

#         if not file_name:
#             return jsonify({"error": "File name is required"}), 400

#         formatted_phone = format_phone_number(phone_number)
#         if not formatted_phone:
#             return jsonify({"error": "Valid phone number is required"}), 400

#         # Generate temporary token for secure access
#         temp_token = generate_temp_token()
#         expires_at = datetime.now() + timedelta(hours=24)
        
#         # Store file info with temporary token
#         temp_links[temp_token] = {
#             'file_name': file_name,
#             'expires_at': expires_at,
#             'accessed': False
#         }

#         # Clean up expired links
#         cleanup_expired_links()

#         # Create clean proxy URL instead of direct S3 URL
#         base_url = request.url_root.rstrip('/')
#         clean_download_url = f"{base_url}/download/{temp_token}"

#         # Create personalized WhatsApp message with clean URL
#         greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
#         quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
        
#         message = f"{greeting}Here is {quotation_text} from our company. Click here to download: {clean_download_url}"
        
#         encoded_message = urllib.parse.quote(message)
#         whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"

#         print(f"✅ Clean download link generated: {clean_download_url}")
#         print(f"📲 WhatsApp link generated for {formatted_phone}")

#         return jsonify({
#             "download_url": clean_download_url,
#             "whatsapp_link": whatsapp_link,
#             "formatted_phone": formatted_phone,
#             "expires_in": "24 hours",
#             "token": temp_token
#         })

#     except Exception as e:
#         print(f"❌ Error generating signed URL: {e}")
#         return jsonify({"error": str(e)}), 500

# # Proxy route to serve files securely
# @share_quotation_bp.route("/download/<token>", methods=["GET"])
# def download_file(token):
#     try:
#         # Clean up expired links first
#         cleanup_expired_links()
        
#         # Check if token exists and is valid
#         if token not in temp_links:
#             return jsonify({"error": "Invalid or expired download link"}), 404

#         file_info = temp_links[token]
#         file_name = file_info['file_name']
#         bucket_name = os.getenv('AWS_BUCKET_NAME')

#         print(f"🔗 Serving file {file_name} via proxy")

#         # Generate short-lived presigned URL (1 hour)
#         presigned_url = s3_client.generate_presigned_url(
#             "get_object",
#             Params={"Bucket": bucket_name, "Key": file_name},
#             ExpiresIn=3600  # 1 hour
#         )

#         # Mark as accessed (optional - for analytics)
#         temp_links[token]['accessed'] = True
#         temp_links[token]['accessed_at'] = datetime.now()

#         # Redirect to the presigned URL
#         return redirect(presigned_url)

#     except Exception as e:
#         print(f"❌ Error serving file: {e}")
#         return jsonify({"error": "Unable to serve file"}), 500

# SOLUTION 2: Alternative with friendly URLs
@share_quotation_bp.route("/get-friendly-url", methods=["GET"])
def get_friendly_url():
    try:
        file_name = request.args.get("file_name")
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")

        if not file_name or not phone_number:
            return jsonify({"error": "File name and phone number are required"}), 400

        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            return jsonify({"error": "Valid phone number is required"}), 400

        # Generate friendly token
        timestamp = datetime.now().strftime('%Y%m%d')
        friendly_id = quotation_id if quotation_id else f"Q{timestamp}"
        temp_token = generate_temp_token()[:8]  # Shorter token
        
        expires_at = datetime.now() + timedelta(hours=24)
        temp_links[temp_token] = {
            'file_name': file_name,
            'expires_at': expires_at,
            'quotation_id': friendly_id
        }

        base_url = request.url_root.rstrip('/')
        friendly_url = f"{base_url}/quotation/{friendly_id}/{temp_token}"

        # Create message with friendly URL
        greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
        message = f"{greeting}Your quotation is ready! Click here to view: {friendly_url}"
        
        encoded_message = urllib.parse.quote(message)
        whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"

        return jsonify({
            "friendly_url": friendly_url,
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "expires_in": "24 hours"
        })

    except Exception as e:
        print(f"❌ Error generating friendly URL: {e}")
        return jsonify({"error": str(e)}), 500

# Friendly URL route
@share_quotation_bp.route("/quotation/<quotation_id>/<token>", methods=["GET"])
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

