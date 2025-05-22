from flask import Flask, request, jsonify, Blueprint
import boto3
import os
import urllib.parse  # Import for encoding URL
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

share_quotation_bp = Blueprint("share_quotation", __name__)

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
    """
    Format phone number for WhatsApp API
    Removes any non-digit characters and ensures proper format
    """
    if not phone_number:
        return None
    
    # Remove all non-digit characters
    cleaned_number = ''.join(filter(str.isdigit, str(phone_number)))
    
    # Handle Indian numbers - add country code if not present
    if len(cleaned_number) == 10:
        cleaned_number = "91" + cleaned_number  # Add India country code
    elif len(cleaned_number) == 11 and cleaned_number.startswith("0"):
        cleaned_number = "91" + cleaned_number[1:]  # Replace leading 0 with 91
    elif len(cleaned_number) == 12 and cleaned_number.startswith("91"):
        pass  # Already has country code
    else:
        # For other international numbers, return as is
        pass
    
    return cleaned_number

# Route to upload a PDF to S3
@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        file = request.files.get("file")  # Get file from request

        if not file:
            print("❌ No file found in request")
            return jsonify({"error": "No file uploaded"}), 400

        # Generate unique filename with timestamp
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        file_name = f"quotations/quotation_{timestamp}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"📂 Uploading file {file_name} to bucket {bucket_name}")

        # Upload to S3 with public-read permissions for easier access
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


# Route to generate pre-signed URL & WhatsApp link
@share_quotation_bp.route("/get-signed-url", methods=["GET"])
def get_presigned_url():
    try:
        file_name = request.args.get("file_name")
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")

        if not file_name:
            print("❌ No file name provided in request")
            return jsonify({"error": "File name is required"}), 400

        # Format phone number for WhatsApp
        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            print("❌ Invalid phone number provided")
            return jsonify({"error": "Valid phone number is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        print(f"🔗 Generating pre-signed URL for file: {file_name} in bucket: {bucket_name}")

        # Generate pre-signed URL with longer expiry for WhatsApp sharing
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=86400,  # 24 hours expiry for WhatsApp sharing
        )

        print(f"✅ Pre-signed URL generated: {presigned_url}")

        # Create personalized WhatsApp message
        greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
        quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
        
        message = f"{greeting}Here is {quotation_text} from our company. Please find the PDF document attached: {presigned_url}"
        
        # Encode message for URL safety
        encoded_message = urllib.parse.quote(message)

        # Create WhatsApp share link
        whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"
        print(f"📲 WhatsApp link generated for {formatted_phone}: {whatsapp_link}")

        return jsonify({
            "url": presigned_url, 
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "expires_in": "24 hours"
        })

    except Exception as e:
        print(f"❌ Error generating pre-signed URL: {e}")
        return jsonify({"error": str(e)}), 500


# Route to get WhatsApp link without uploading (for existing files)
@share_quotation_bp.route("/get-whatsapp-link", methods=["GET"])
def get_whatsapp_link():
    try:
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")
        message_text = request.args.get("message", "")

        if not phone_number:
            return jsonify({"error": "Phone number is required"}), 400

        # Format phone number for WhatsApp
        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            return jsonify({"error": "Valid phone number is required"}), 400

        # Create message
        if message_text:
            message = message_text
        else:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            message = f"{greeting}Thank you for your interest in our services. Here is {quotation_text} for your review."

        # Encode message for URL safety
        encoded_message = urllib.parse.quote(message)

        # Create WhatsApp share link
        whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"

        return jsonify({
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "message": message
        })

    except Exception as e:
        print(f"❌ Error generating WhatsApp link: {e}")
        return jsonify({"error": str(e)}), 500


# Route to delete uploaded file from S3 (cleanup)
@share_quotation_bp.route("/delete-quotation", methods=["DELETE"])
def delete_file():
    try:
        file_name = request.args.get("file_name")
        
        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        # Delete file from S3
        s3_client.delete_object(Bucket=bucket_name, Key=file_name)
        
        print(f"✅ File {file_name} deleted successfully from S3")
        return jsonify({"message": "File deleted successfully"})

    except Exception as e:
        print(f"❌ Error deleting file: {e}")
        return jsonify({"error": str(e)}), 500