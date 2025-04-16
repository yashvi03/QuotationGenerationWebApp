from flask import Blueprint, request, jsonify
from ..models import db, Item

item_bp = Blueprint('item_bp', __name__)

# Get unique types
@item_bp.route('/types', methods=['GET'])
def get_unique_types():
    # Query to get unique types
    unique_types = db.session.query(Item.type).distinct().all()
    # Flatten the result to a list
    types_list = [item.type for item in unique_types]
    return jsonify(types_list), 200

@item_bp.route('/test', methods=['GET'])
def test_route():
    return jsonify({'message': 'Item blueprint is working'}), 200



# Get sizes for a specific type
@item_bp.route('/sizes', methods=['GET'])
def get_sizes_by_type():
    # Get type from query parameters
    selected_type = request.args.get('type')
    if not selected_type:
        return jsonify({'error': 'Type parameter is required'}), 400

    # Query to get sizes for the selected type
    sizes = db.session.query(Item.size).filter(Item.type == selected_type).distinct().all()
    # Flatten the result to a list
    sizes_list = [item.size for item in sizes]
    return jsonify(sizes_list), 200

# Get items based on type and size
@item_bp.route('/item', methods=['GET'])
def get_items_by_type_and_size():
    # Get type and size from query parameters
    selected_type = request.args.get('type')
    selected_size = request.args.get('size')

    # Validate inputs
    if not selected_type:
        return jsonify({'error': 'Type parameter is required'}), 400
    if not selected_size:
        return jsonify({'error': 'Size parameter is required'}), 400

    # Query to get items for the selected type and size
    items = Item.query.filter(Item.type == selected_type, Item.size == selected_size).all()
    return jsonify([item.to_dict() for item in items]), 200
