from flask import Flask, request, jsonify, Blueprint, redirect
import boto3
import os
import urllib.parse
import uuid
from datetime import datetime, timedelta
from dotenv import load_dotenv
import traceback
import logging

# Set up logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

load_dotenv()

share_quotation_bp = Blueprint("share_quotation", __name__)

# In-memory storage for temporary links (use Redis/DB in production)
temp_links = {}

# Initialize S3 client with better error handling
s3_client = None
try:
    aws_access_key = os.getenv('AWS_ACCESS_KEY')
    aws_secret_key = os.getenv('SHARE_SECRET_KEY')
    aws_region = os.getenv('AWS_REGION')
    
    logger.info(f"AWS Config - Access Key: {'***' + aws_access_key[-4:] if aws_access_key else 'None'}")
    logger.info(f"AWS Config - Region: {aws_region}")
    
    if not aws_access_key or not aws_secret_key or not aws_region:
        raise ValueError("Missing AWS credentials or region in environment variables")
    
    s3_client = boto3.client(
        "s3",
        aws_access_key_id=aws_access_key,
        aws_secret_access_key=aws_secret_key,
        region_name=aws_region
    )
    logger.info("✅ S3 client initialized successfully")
except Exception as e:
    logger.error(f"❌ Error initializing S3 client: {e}")
    logger.error(f"❌ Full traceback: {traceback.format_exc()}")

def format_phone_number(phone_number):
    """Format phone number for WhatsApp API"""
    try:
        if not phone_number:
            logger.warning("Empty phone number provided")
            return None
        
        logger.info(f"Formatting phone number: {phone_number}")
        cleaned_number = ''.join(filter(str.isdigit, str(phone_number)))
        logger.info(f"Cleaned phone number: {cleaned_number}")
        
        if len(cleaned_number) == 10:
            cleaned_number = "91" + cleaned_number
        elif len(cleaned_number) == 11 and cleaned_number.startswith("0"):
            cleaned_number = "91" + cleaned_number[1:]
        elif len(cleaned_number) == 12 and cleaned_number.startswith("91"):
            pass
        else:
            logger.warning(f"Unusual phone number length: {len(cleaned_number)}")
        
        logger.info(f"Final formatted phone: {cleaned_number}")
        return cleaned_number
    except Exception as e:
        logger.error(f"Error formatting phone number: {e}")
        return None

def generate_temp_token():
    """Generate a temporary secure token"""
    try:
        token = str(uuid.uuid4())
        logger.info(f"Generated token: {token[:8]}...")
        return token
    except Exception as e:
        logger.error(f"Error generating token: {e}")
        raise

def cleanup_expired_links():
    """Remove expired temporary links"""
    try:
        current_time = datetime.now()
        expired_keys = [
            key for key, data in temp_links.items() 
            if data.get('expires_at', current_time) < current_time
        ]
        for key in expired_keys:
            del temp_links[key]
        logger.info(f"Cleaned up {len(expired_keys)} expired links")
    except Exception as e:
        logger.error(f"Error during cleanup: {e}")

# Route to upload a PDF to S3
@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        logger.info("📤 Starting file upload")
        
        if not s3_client:
            logger.error("S3 client not initialized")
            return jsonify({"error": "S3 service unavailable"}), 503
            
        file = request.files.get("file")
        if not file:
            logger.error("No file found in request")
            return jsonify({"error": "No file uploaded"}), 400

        logger.info(f"File received: {file.filename}, size: {file.content_length}")
        
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        file_name = f"quotations/quotation_{timestamp}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        if not bucket_name:
            logger.error("AWS_BUCKET_NAME not set")
            return jsonify({"error": "Storage configuration error"}), 500

        logger.info(f"Uploading to bucket: {bucket_name}, key: {file_name}")

        s3_client.upload_fileobj(
            file,
            bucket_name,
            file_name,
            ExtraArgs={
                'ContentType': 'application/pdf',
                'ContentDisposition': 'attachment'
            }
        )

        logger.info("✅ File uploaded successfully!")
        return jsonify({
            "message": "File uploaded successfully!", 
            "file_name": file_name,
            "timestamp": timestamp
        })

    except Exception as e:
        logger.error(f"❌ Error uploading file: {e}")
        logger.error(f"❌ Full traceback: {traceback.format_exc()}")
        return jsonify({"error": f"Upload failed: {str(e)}"}), 500

# Enhanced get-signed-url route with comprehensive error handling
@share_quotation_bp.route("/get-signed-url", methods=["GET"])
def get_presigned_url():
    try:
        logger.info("🔄 Starting get-signed-url request")
        
        # Get parameters with defaults
        file_name = request.args.get("file_name", "").strip()
        phone_number = request.args.get("phone_number", "").strip()
        customer_name = request.args.get("customer_name", "").strip()
        quotation_id = request.args.get("quotation_id", "").strip()
        
        logger.info(f"📋 Request parameters:")
        logger.info(f"   - file_name: {file_name}")
        logger.info(f"   - phone_number: {'***' + phone_number[-4:] if len(phone_number) > 4 else phone_number}")
        logger.info(f"   - customer_name: {customer_name}")
        logger.info(f"   - quotation_id: {quotation_id}")

        # Validation
        if not file_name:
            logger.error("❌ No file name provided")
            return jsonify({"error": "File name is required"}), 400

        if not phone_number:
            logger.error("❌ No phone number provided")
            return jsonify({"error": "Phone number is required"}), 400

        # Format phone number
        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            logger.error("❌ Phone formatting failed")
            return jsonify({"error": "Valid phone number is required"}), 400

        logger.info(f"✅ Phone formatted successfully: {formatted_phone}")

        # Generate token and friendly ID
        try:
            timestamp = datetime.now().strftime('%Y%m%d')
            friendly_id = quotation_id if quotation_id else f"Q{timestamp}"
            temp_token = generate_temp_token()[:8]  # Shorter token
            logger.info(f"🔑 Generated - friendly_id: {friendly_id}, token: {temp_token}")
        except Exception as token_error:
            logger.error(f"❌ Token generation failed: {token_error}")
            return jsonify({"error": "Token generation failed"}), 500
        
        # Store token info
        try:
            expires_at = datetime.now() + timedelta(hours=24)
            temp_links[temp_token] = {
                'file_name': file_name,
                'expires_at': expires_at,
                'quotation_id': friendly_id,
                'accessed': False,
                'created_at': datetime.now()
            }
            logger.info(f"💾 Token stored successfully. Active links: {len(temp_links)}")
        except Exception as storage_error:
            logger.error(f"❌ Token storage failed: {storage_error}")
            return jsonify({"error": "Token storage failed"}), 500

        # Clean up expired links
        try:
            cleanup_expired_links()
        except Exception as cleanup_error:
            logger.warning(f"⚠️ Cleanup warning: {cleanup_error}")

        # Create friendly URL
        try:
            # Get base URL safely
            if hasattr(request, 'url_root') and request.url_root:
                base_url = request.url_root.rstrip('/')
            else:
                # Fallback construction
                scheme = request.scheme if hasattr(request, 'scheme') else 'http'
                host = request.host if hasattr(request, 'host') else 'localhost:5000'
                base_url = f"{scheme}://{host}"
            
            friendly_url = f"{base_url}/api/pdf/{temp_token}"
            logger.info(f"🔗 Generated URL: {friendly_url}")
        except Exception as url_error:
            logger.error(f"❌ URL creation failed: {url_error}")
            return jsonify({"error": "URL generation failed"}), 500

        # Create WhatsApp message
        try:
            greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
            quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
            message = f"{greeting}Here is {quotation_text} from our company. Click here to view: {friendly_url}"
            
            encoded_message = urllib.parse.quote(message)
            whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"
            logger.info(f"📲 WhatsApp link created successfully")
        except Exception as message_error:
            logger.error(f"❌ WhatsApp message creation failed: {message_error}")
            return jsonify({"error": "Message creation failed"}), 500

        logger.info("✅ Request completed successfully")
        return jsonify({
            "url": friendly_url,
            "friendly_url": friendly_url,
            "whatsapp_link": whatsapp_link,
            "formatted_phone": formatted_phone,
            "expires_in": "24 hours",
            "token": temp_token,
            "message": message  # Include message for debugging
        })

    except Exception as e:
        logger.error(f"❌ Unexpected error in get_presigned_url: {str(e)}")
        logger.error(f"❌ Error type: {type(e).__name__}")
        logger.error(f"❌ Full traceback: {traceback.format_exc()}")
        return jsonify({
            "error": f"Internal server error: {str(e)}",
            "error_type": type(e).__name__
        }), 500

# PDF serving route with enhanced error handling
@share_quotation_bp.route("/api/pdf/<token>", methods=["GET"])
def serve_pdf_by_token(token):
    try:
        logger.info(f"🔗 Serving PDF for token: {token}")
        
        if not s3_client:
            logger.error("S3 client not available")
            return jsonify({"error": "Service unavailable"}), 503
        
        # Clean up expired links first
        cleanup_expired_links()
        
        # Check if token exists and is valid
        if token not in temp_links:
            logger.warning(f"Invalid token requested: {token}")
            return jsonify({"error": "Invalid or expired download link"}), 404

        file_info = temp_links[token]
        file_name = file_info['file_name']
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        if not bucket_name:
            logger.error("AWS_BUCKET_NAME not configured")
            return jsonify({"error": "Storage configuration error"}), 500

        logger.info(f"🔗 Generating presigned URL for file: {file_name}")

        # Generate short-lived presigned URL (1 hour)
        presigned_url = s3_client.generate_presigned_url(
            "get_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600  # 1 hour
        )

        # Mark as accessed
        temp_links[token]['accessed'] = True
        temp_links[token]['accessed_at'] = datetime.now()

        logger.info(f"✅ Redirecting to presigned URL")
        return redirect(presigned_url)

    except Exception as e:
        logger.error(f"❌ Error serving PDF: {e}")
        logger.error(f"❌ Full traceback: {traceback.format_exc()}")
        return jsonify({"error": f"Unable to serve file: {str(e)}"}), 500

# Health check route
@share_quotation_bp.route("/health", methods=["GET"])
def health_check():
    try:
        status = {
            "status": "healthy",
            "s3_client": s3_client is not None,
            "active_links": len(temp_links),
            "timestamp": datetime.now().isoformat()
        }
        
        # Test S3 connection
        if s3_client:
            try:
                bucket_name = os.getenv('AWS_BUCKET_NAME')
                if bucket_name:
                    s3_client.head_bucket(Bucket=bucket_name)
                    status["s3_connection"] = "ok"
                else:
                    status["s3_connection"] = "no_bucket_configured"
            except Exception as s3_error:
                status["s3_connection"] = f"error: {str(s3_error)}"
        
        return jsonify(status)
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "error": str(e)
        }), 500

# Debug route to check stored links
@share_quotation_bp.route("/debug/links", methods=["GET"])
def debug_links():
    try:
        cleanup_expired_links()
        debug_info = {}
        for token, info in temp_links.items():
            debug_info[token] = {
                "quotation_id": info.get('quotation_id'),
                "expires_at": info.get('expires_at').isoformat() if info.get('expires_at') else None,
                "accessed": info.get('accessed', False),
                "created_at": info.get('created_at').isoformat() if info.get('created_at') else None
            }
        
        return jsonify({
            "active_links": len(temp_links),
            "links": debug_info
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Legacy routes for backward compatibility
@share_quotation_bp.route("/download/<token>", methods=["GET"])
def download_file(token):
    return serve_pdf_by_token(token)

@share_quotation_bp.route("/download/quotation/<quotation_id>/<token>", methods=["GET"])
def view_quotation(quotation_id, token):
    return serve_pdf_by_token(token)

# Route to delete uploaded file from S3
@share_quotation_bp.route("/delete-quotation", methods=["DELETE"])
def delete_file():
    try:
        file_name = request.args.get("file_name")
        
        if not file_name:
            return jsonify({"error": "File name is required"}), 400

        if not s3_client:
            return jsonify({"error": "S3 service unavailable"}), 503

        bucket_name = os.getenv('AWS_BUCKET_NAME')
        if not bucket_name:
            return jsonify({"error": "Storage configuration error"}), 500
            
        s3_client.delete_object(Bucket=bucket_name, Key=file_name)
        
        logger.info(f"✅ File {file_name} deleted successfully from S3")
        return jsonify({"message": "File deleted successfully"})

    except Exception as e:
        logger.error(f"❌ Error deleting file: {e}")
        return jsonify({"error": str(e)}), 500

# Clean up expired links periodically
@share_quotation_bp.route("/cleanup-expired", methods=["POST"])
def manual_cleanup():
    try:
        cleanup_expired_links()
        return jsonify({"message": f"Cleaned up expired links. Active links: {len(temp_links)}"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500