from flask import Flask, request, jsonify, Blueprint, redirect, send_file
import boto3
import os
import urllib.parse
import secrets
import string
from datetime import datetime, timedelta
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import Error
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

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            database=os.getenv('DB_NAME'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD')
        )
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None

def generate_short_code(length=8):
    """Generate a random short code for URLs"""
    characters = string.ascii_letters + string.digits
    return ''.join(secrets.choice(characters) for _ in range(length))

def format_phone_number(phone_number):
    """Format phone number for WhatsApp API"""
    if not phone_number:
        return None
    
    cleaned_number = ''.join(filter(str.isdigit, str(phone_number)))
    
    if len(cleaned_number) == 10:
        cleaned_number = "91" + cleaned_number
    elif len(cleaned_number) == 11 and cleaned_number.startswith("0"):
        cleaned_number = "91" + cleaned_number[1:]
    
    return cleaned_number

# Create table for secure links
def create_secure_links_table():
    try:
        connection = get_db_connection()
        if not connection:
            return False
        
        cursor = connection.cursor()
        
        create_table_query = """
        CREATE TABLE IF NOT EXISTS secure_links (
            id INT PRIMARY KEY AUTO_INCREMENT,
            short_code VARCHAR(20) UNIQUE NOT NULL,
            quotation_id VARCHAR(50) NOT NULL,
            customer_id INT NOT NULL,
            s3_file_name VARCHAR(255) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            expires_at TIMESTAMP NOT NULL,
            access_count INT DEFAULT 0,
            max_access INT DEFAULT 10,
            is_active BOOLEAN DEFAULT TRUE,
            
            INDEX idx_short_code (short_code),
            INDEX idx_quotation_id (quotation_id),
            INDEX idx_expires_at (expires_at)
        )
        """
        
        cursor.execute(create_table_query)
        connection.commit()
        cursor.close()
        connection.close()
        return True
        
    except Exception as e:
        print(f"Error creating secure_links table: {e}")
        return False

# Initialize table on startup
create_secure_links_table()

@share_quotation_bp.route("/upload-quotation", methods=["POST"])
def upload_file():
    try:
        file = request.files.get("file")
        quotation_id = request.form.get("quotation_id")
        customer_id = request.form.get("customer_id")

        if not file or not quotation_id or not customer_id:
            return jsonify({"error": "File, quotation_id, and customer_id are required"}), 400

        # Generate unique filename
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        file_name = f"quotations/{quotation_id}_{timestamp}.pdf"
        bucket_name = os.getenv('AWS_BUCKET_NAME')

        # Upload to S3 (private bucket)
        s3_client.upload_fileobj(
            file,
            bucket_name,
            file_name,
            ExtraArgs={
                'ContentType': 'application/pdf',
                'ServerSideEncryption': 'AES256'  # Encrypt at rest
            }
        )

        # Generate secure short code
        short_code = generate_short_code()
        
        # Ensure uniqueness
        connection = get_db_connection()
        cursor = connection.cursor()
        
        while True:
            cursor.execute("SELECT id FROM secure_links WHERE short_code = %s", (short_code,))
            if not cursor.fetchone():
                break
            short_code = generate_short_code()
        
        # Store secure link in database
        expires_at = datetime.now() + timedelta(hours=24)
        insert_query = """
            INSERT INTO secure_links 
            (short_code, quotation_id, customer_id, s3_file_name, expires_at)
            VALUES (%s, %s, %s, %s, %s)
        """
        
        cursor.execute(insert_query, (short_code, quotation_id, customer_id, file_name, expires_at))
        connection.commit()
        cursor.close()
        connection.close()

        print(f"✅ File uploaded and secure link created: {short_code}")
        
        return jsonify({
            "message": "File uploaded successfully!",
            "short_code": short_code,
            "secure_url": f"{request.host_url}secure/{short_code}"
        })

    except Exception as e:
        print(f"❌ Error uploading file: {e}")
        return jsonify({"error": str(e)}), 500

@share_quotation_bp.route("/get-whatsapp-link", methods=["GET"])
def get_whatsapp_link():
    try:
        short_code = request.args.get("short_code")
        phone_number = request.args.get("phone_number")
        customer_name = request.args.get("customer_name", "")
        quotation_id = request.args.get("quotation_id", "")

        if not short_code or not phone_number:
            return jsonify({"error": "short_code and phone_number are required"}), 400

        # Format phone number
        formatted_phone = format_phone_number(phone_number)
        if not formatted_phone:
            return jsonify({"error": "Valid phone number is required"}), 400

        # Create clean, professional message
        base_url = request.host_url.rstrip('/')
        secure_url = f"{base_url}/secure/{short_code}"
        
        greeting = f"Hi {customer_name}! " if customer_name else "Hi! "
        quotation_text = f"Quotation #{quotation_id}" if quotation_id else "your quotation"
        
        message = f"{greeting}Please find {quotation_text} document here: {secure_url}"
        
        # Encode message for URL
        encoded_message = urllib.parse.quote(message)
        whatsapp_link = f"https://api.whatsapp.com/send?phone={formatted_phone}&text={encoded_message}"

        return jsonify({
            "whatsapp_link": whatsapp_link,
            "secure_url": secure_url,
            "formatted_phone": formatted_phone,
            "expires_in": "24 hours"
        })

    except Exception as e:
        print(f"❌ Error generating WhatsApp link: {e}")
        return jsonify({"error": str(e)}), 500

@share_quotation_bp.route("/secure/<short_code>", methods=["GET"])
def serve_secure_file(short_code):
    try:
        connection = get_db_connection()
        if not connection:
            return "Service temporarily unavailable", 503
        
        cursor = connection.cursor(dictionary=True)
        
        # Get link details
        query = """
            SELECT sl.*, c.name as customer_name
            FROM secure_links sl
            LEFT JOIN customers c ON sl.customer_id = c.customer_id
            WHERE sl.short_code = %s AND sl.is_active = TRUE
        """
        
        cursor.execute(query, (short_code,))
        link_data = cursor.fetchone()
        
        if not link_data:
            cursor.close()
            connection.close()
            return "Link not found or expired", 404
        
        # Check if expired
        if datetime.now() > link_data['expires_at']:
            cursor.execute("UPDATE secure_links SET is_active = FALSE WHERE short_code = %s", (short_code,))
            connection.commit()
            cursor.close()
            connection.close()
            return "Link has expired", 410
        
        # Check access limit
        if link_data['access_count'] >= link_data['max_access']:
            cursor.close()
            connection.close()
            return "Access limit exceeded", 429
        
        # Update access count
        cursor.execute(
            "UPDATE secure_links SET access_count = access_count + 1 WHERE short_code = %s", 
            (short_code,)
        )
        connection.commit()
        cursor.close()
        connection.close()
        
        # Get file from S3
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        
        try:
            response = s3_client.get_object(Bucket=bucket_name, Key=link_data['s3_file_name'])
            file_content = response['Body'].read()
            
            # Create a file-like object
            pdf_file = io.BytesIO(file_content)
            
            # Set filename for download
            filename = f"quotation_{link_data['quotation_id']}.pdf"
            
            return send_file(
                pdf_file,
                mimetype='application/pdf',
                as_attachment=True,
                download_name=filename
            )
            
        except Exception as s3_error:
            print(f"Error retrieving file from S3: {s3_error}")
            return "File not available", 404
            
    except Exception as e:
        print(f"❌ Error serving secure file: {e}")
        return "Internal server error", 500

@share_quotation_bp.route("/link-info/<short_code>", methods=["GET"])
def get_link_info(short_code):
    """Get information about a secure link (for preview/status)"""
    try:
        connection = get_db_connection()
        if not connection:
            return jsonify({"error": "Service unavailable"}), 503
        
        cursor = connection.cursor(dictionary=True)
        
        query = """
            SELECT sl.quotation_id, sl.created_at, sl.expires_at, sl.access_count, 
                   sl.max_access, sl.is_active, c.name as customer_name
            FROM secure_links sl
            LEFT JOIN customers c ON sl.customer_id = c.customer_id
            WHERE sl.short_code = %s
        """
        
        cursor.execute(query, (short_code,))
        link_info = cursor.fetchone()
        
        cursor.close()
        connection.close()
        
        if not link_info:
            return jsonify({"error": "Link not found"}), 404
        
        # Convert datetime to strings
        if link_info['created_at']:
            link_info['created_at'] = link_info['created_at'].isoformat()
        if link_info['expires_at']:
            link_info['expires_at'] = link_info['expires_at'].isoformat()
        
        # Add status
        now = datetime.now()
        expires_at = datetime.fromisoformat(link_info['expires_at'].replace('Z', '+00:00').replace('+00:00', ''))
        
        if not link_info['is_active']:
            link_info['status'] = 'inactive'
        elif now > expires_at:
            link_info['status'] = 'expired'
        elif link_info['access_count'] >= link_info['max_access']:
            link_info['status'] = 'access_limit_reached'
        else:
            link_info['status'] = 'active'
        
        return jsonify(link_info)
        
    except Exception as e:
        print(f"❌ Error getting link info: {e}")
        return jsonify({"error": str(e)}), 500

@share_quotation_bp.route("/cleanup-expired", methods=["DELETE"])
def cleanup_expired_links():
    """Cleanup expired links and their S3 files"""
    try:
        connection = get_db_connection()
        if not connection:
            return jsonify({"error": "Service unavailable"}), 503
        
        cursor = connection.cursor()
        
        # Get expired files
        cursor.execute("""
            SELECT s3_file_name FROM secure_links 
            WHERE expires_at < NOW() OR is_active = FALSE
        """)
        
        expired_files = cursor.fetchall()
        bucket_name = os.getenv('AWS_BUCKET_NAME')
        deleted_count = 0
        
        # Delete from S3
        for (file_name,) in expired_files:
            try:
                s3_client.delete_object(Bucket=bucket_name, Key=file_name)
                deleted_count += 1
            except Exception as e:
                print(f"Error deleting {file_name}: {e}")
        
        # Delete from database
        cursor.execute("DELETE FROM secure_links WHERE expires_at < NOW() OR is_active = FALSE")
        db_deleted = cursor.rowcount
        
        connection.commit()
        cursor.close()
        connection.close()
        
        return jsonify({
            "message": "Cleanup completed",
            "s3_files_deleted": deleted_count,
            "database_records_deleted": db_deleted
        })
        
    except Exception as e:
        print(f"❌ Error during cleanup: {e}")
        return jsonify({"error": str(e)}), 500