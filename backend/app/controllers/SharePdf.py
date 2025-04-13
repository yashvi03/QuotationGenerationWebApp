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

# Route to upload a PDF to S3
@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        file = request.files.get("file")  # Get file from request

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
        )

        print("✅ File uploaded successfully!")
        return jsonify({"message": "File uploaded successfully!", "file_name": file_name})

    except Exception as e:
        print(f"❌ Error uploading file: {e}")
        return jsonify({"error": str(e)}), 500


# Route to generate pre-signed URL & WhatsApp link
@share_quotation_bp.route("/get-signed-url", methods=["GET"])
def get_presigned_url():
    try:
        file_name = request.args.get("file_name")

        if not file_name:
            print("❌ No file name provided in request")
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        print(f"🔗 Generating pre-signed URL for file: {file_name} in bucket: {bucket_name}")

        # Generate pre-signed URL
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600,  # 1 hour expiry
        )

        print(f"✅ Pre-signed URL generated: {presigned_url}")

        # Create WhatsApp share link
        phone_number = "9374808167"  # Replace with recipient's number
        message = f"Here is your quotation: {presigned_url}"
        encoded_message = urllib.parse.quote(message)  # Encode message for URL safety

        whatsapp_link = f"https://api.whatsapp.com/send?phone={phone_number}&text={encoded_message}"
        print(f"📲 WhatsApp link generated: {whatsapp_link}")

        return jsonify({"url": presigned_url, "whatsapp_link": whatsapp_link})

    except Exception as e:
        print(f"❌ Error generating pre-signed URL: {e}")
        return jsonify({"error": str(e)}), 500
