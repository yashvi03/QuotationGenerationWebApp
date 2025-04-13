from flask import Blueprint, request, jsonify
from models import db, Customer


customer_bp = Blueprint('customer_bp', __name__)

@customer_bp.route('/autosave', methods=['POST'])
def auto_save_customer():
    """Endpoint to auto-save customer progress."""
    data = request.get_json()
    try:
        # Check if a draft exists for the same phone number (or other unique identifier)
        customer = Customer.query.filter_by(phone_number=data.get("phone_number")).first()
        
        if customer:
            # Update existing draft
            customer.title = data.get("title", customer.title)
            customer.name = data.get("name", customer.name)
            customer.address = data.get("address", customer.address)
            customer.whatsapp_number = data.get("whatsapp_number", customer.whatsapp_number)
            customer.is_draft = True
        else:
            # Create a new draft
            customer = Customer(
                title=data.get("title"),
                name=data.get("name"),
                address=data.get("address"),
                phone_number=data.get("phone_number"),
                whatsapp_number=data.get("whatsapp_number"),
                is_draft=True
            )
            db.session.add(customer)

        db.session.commit()
        return jsonify({"message": "Progress saved successfully", "customer_id": customer.customer_id}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@customer_bp.route('/submit', methods=['POST'])
def submit_customer():
    """Endpoint to finalize and submit customer details."""
    data = request.get_json()
    try:
        # Fetch the customer draft
        customer = Customer.query.filter_by(phone_number=data.get("phone_number")).first()
        if not customer:
            return jsonify({"error": "Customer draft not found"}), 404

        # Update the draft to completed
        customer.title = data.get("title", customer.title)
        customer.name = data.get("name", customer.name)
        customer.address = data.get("address", customer.address)
        customer.whatsapp_number = data.get("whatsapp_number", customer.whatsapp_number)
        customer.is_draft = False

        db.session.commit()
        return jsonify({"message": "Customer submitted successfully", "customer_id": customer.customer_id}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
