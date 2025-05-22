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