from flask import Flask, request, jsonify, Blueprint, send_file, Response
import boto3
import os
import urllib.parse
import uuid
from datetime import datetime, timedelta
from dotenv import load_dotenv
import io

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

# Route to directly serve PDF with custom message
@share_quotation_bp.route("/share-pdf", methods=["GET"])
def share_pdf_directly():
    try:
        # Get parameters
        file_name = request.args.get("file_name")
        phone_number = request.args.get("phone_number", "9374808167")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")
        custom_message = request.args.get("message", "")

        if not file_name:
            print("❌ No file name provided in request")
            return jsonify({"error": "File name is required"}), 400

        print(f"📄 Processing direct PDF share for file: {file_name}")
        print(f"📱 Phone: {phone_number}")
        print(f"👤 Customer: {customer_name}")
        print(f"🆔 Quotation ID: {quotation_id}")

        bucket_name = os.getenv('AWS_BUCKET_NAME')

        # Download PDF from S3
        try:
            print(f"📥 Downloading PDF from S3: {file_name}")
            response = s3_client.get_object(Bucket=bucket_name, Key=file_name)
            pdf_content = response['Body'].read()
            print(f"✅ PDF downloaded successfully, size: {len(pdf_content)} bytes")
        except Exception as e:
            print(f"❌ Error downloading PDF from S3: {e}")
            return jsonify({"error": f"File not found: {str(e)}"}), 404

        # Create custom message
        if custom_message:
            message = custom_message
        else:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            message = f"{greeting}Please find {quotation_text} attached from our company."

        # Format phone number (ensure it has country code)
        if len(phone_number) == 10:
            phone_number = "91" + phone_number  # Add India country code

        # Create WhatsApp share URL with message (without PDF link)
        encoded_message = urllib.parse.quote(message)
        whatsapp_link = f"https://api.whatsapp.com/send?phone={phone_number}&text={encoded_message}"

        print(f"📲 WhatsApp message link generated")

        return jsonify({
            "message": "PDF ready for direct sharing",
            "whatsapp_message": message,
            "whatsapp_link": whatsapp_link,
            "pdf_download_url": f"{request.url_root.rstrip('/')}/download-pdf?file_name={urllib.parse.quote(file_name)}",
            "file_size": len(pdf_content),
            "timestamp": datetime.now().isoformat()
        })

    except Exception as e:
        print(f"❌ Error in direct PDF sharing: {e}")
        import traceback
        print(f"❌ Full error: {traceback.format_exc()}")
        return jsonify({"error": str(e)}), 500

# Route to download PDF directly
@share_quotation_bp.route("/download-pdf", methods=["GET"])
def download_pdf():
    try:
        file_name = request.args.get("file_name")
        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        print(f"📥 Downloading PDF: {file_name}")

        # Get PDF from S3
        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=file_name)
            pdf_content = response['Body'].read()
        except Exception as e:
            print(f"❌ Error downloading from S3: {e}")
            return jsonify({"error": "File not found"}), 404

        # Create a file-like object from the PDF content
        pdf_buffer = io.BytesIO(pdf_content)
        pdf_buffer.seek(0)

        # Extract just the filename for download
        display_name = file_name.split('/')[-1] if '/' in file_name else file_name
        
        print(f"✅ Serving PDF download: {display_name}")

        return send_file(
            pdf_buffer,
            mimetype='application/pdf',
            as_attachment=True,
            download_name=display_name
        )

    except Exception as e:
        print(f"❌ Error serving PDF download: {e}")
        return jsonify({"error": str(e)}), 500

# Route to get PDF content as base64 (for direct integration with messaging APIs)
@share_quotation_bp.route("/get-pdf-base64", methods=["GET"])
def get_pdf_base64():
    try:
        file_name = request.args.get("file_name")
        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        print(f"📄 Getting PDF as base64: {file_name}")

        # Get PDF from S3
        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=file_name)
            pdf_content = response['Body'].read()
        except Exception as e:
            print(f"❌ Error downloading from S3: {e}")
            return jsonify({"error": "File not found"}), 404

        # Convert to base64
        import base64
        pdf_base64 = base64.b64encode(pdf_content).decode('utf-8')
        
        print(f"✅ PDF converted to base64, size: {len(pdf_base64)} characters")

        return jsonify({
            "file_name": file_name,
            "pdf_base64": pdf_base64,
            "content_type": "application/pdf",
            "file_size": len(pdf_content),
            "base64_size": len(pdf_base64)
        })

    except Exception as e:
        print(f"❌ Error converting PDF to base64: {e}")
        return jsonify({"error": str(e)}), 500

# Route to create a complete message package (message + PDF)
@share_quotation_bp.route("/create-message-package", methods=["POST"])
def create_message_package():
    try:
        data = request.get_json()
        
        file_name = data.get("file_name")
        phone_number = data.get("phone_number", "9374808167")
        customer_name = data.get("customer_name", "")
        quotation_id = data.get("quotation_id", "")
        custom_message = data.get("message", "")

        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        bucket_name = os.getenv('AWS_BUCKET_NAME')

        # Download PDF from S3
        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=file_name)
            pdf_content = response['Body'].read()
        except Exception as e:
            return jsonify({"error": f"File not found: {str(e)}"}), 404

        # Create message
        if custom_message:
            message = custom_message
        else:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            message = f"{greeting}Please find {quotation_text} attached."

        # Convert PDF to base64 for easy transmission
        import base64
        pdf_base64 = base64.b64encode(pdf_content).decode('utf-8')

        return jsonify({
            "message": message,
            "phone_number": phone_number,
            "pdf_data": {
                "filename": file_name.split('/')[-1],
                "content": pdf_base64,
                "content_type": "application/pdf",
                "size": len(pdf_content)
            },
            "package_created_at": datetime.now().isoformat()
        })

    except Exception as e:
        print(f"❌ Error creating message package: {e}")
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
            "timestamp": datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 500

# Debug route to list available files
@share_quotation_bp.route("/debug/files", methods=["GET"])
def debug_files():
    try:
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        # List files in the quotations folder
        response = s3_client.list_objects_v2(
            Bucket=bucket_name,
            Prefix='quotations/',
            MaxKeys=50
        )
        
        files = []
        if 'Contents' in response:
            for obj in response['Contents']:
                files.append({
                    "key": obj['Key'],
                    "size": obj['Size'],
                    "last_modified": obj['LastModified'].isoformat()
                })
        
        return jsonify({
            "bucket": bucket_name,
            "total_files": len(files),
            "files": files
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500