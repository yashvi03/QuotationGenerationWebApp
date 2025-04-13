# from flask import request, jsonify, Blueprint
# from app import db
# from app.models import Quotation
# import uuid;
# import logging;
# import datetime;

# create_quotation_bp = Blueprint('create_quotation', __name__)

# @create_quotation_bp.route('/', methods=['POST'])
# def create_quotation():
#     try:
#         # Generate a unique ID for the quotation
#         quotation_id = str(uuid.uuid4())  # Example: "b12e6d08-345d-4abc-8bd5-f712a705f3b4"

#         # Optionally, initialize the quotation in the database
#         new_quotation = Quotation(id=quotation_id, created_at=datetime.utcnow())
#         db.session.add(new_quotation)
#         db.session.commit()

#         return jsonify({"quotation_id": quotation_id}), 201
#     except Exception as e:
#         logging.error(f"Error creating quotation: {e}")
#         return jsonify({"error": "An unexpected error occurred"}), 500

