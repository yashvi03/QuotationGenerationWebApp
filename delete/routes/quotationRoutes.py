# from flask import Blueprint, request, jsonify
# from models import db, Quotation, QuotationItem, Item


# quotation_bp = Blueprint('quotation_bp', __name__)

# # Create a new quotation
# @quotation_bp.route('/quotations', methods=['POST'])
# def create_quotation():
#     data = request.get_json()
#     customer_id = data['customer_id']
#     items = data['items']  # List of item IDs and quantities
    
#     # Create a new quotation
#     new_quotation = Quotation(customer_id=customer_id)
#     db.session.add(new_quotation)
#     db.session.commit()

#     # Add quotation items
#     for item_data in items:
#         item = Item.query.get(item_data['item_id'])
#         quotation_item = QuotationItem(
#             quotation_id=new_quotation.quotation_id,
#             item_id=item.item_id,
#             quantity=item_data['quantity']
#         )
#         db.session.add(quotation_item)

#     db.session.commit()
#     return jsonify(new_quotation.__repr__()), 201
