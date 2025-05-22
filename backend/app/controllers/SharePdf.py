from flask import Flask, request, jsonify, Blueprint
import boto3
import os
import urllib.parse
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()

share_quotation_bp = Blueprint("share_quotation", __name__)  # Fixed typo in Blueprint name

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
        file = request.files.get("file")
        if not file:
            print("❌ No file found in request")
            return jsonify({"error": "No file uploaded"}), 400

        file_name = f"quotations/{datetime.now().strftime('%Y%m%d%H%M%S')}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        print(f"📂 Uploading file {file_name} to bucket {bucket_name}")

        s3_client.upload_fileobj(
            file,
            bucket_name,
            file_name,
            ExtraArgs={'ContentType': 'application/pdf'}
        )

        print("✅ File uploaded successfully!")
        return jsonify({"message": "File uploaded successfully!", "file_name": file_name})

    except Exception as e:
        print(f"❌ Error uploading file: {e}")
        return jsonify({"error": str(e)}), 500