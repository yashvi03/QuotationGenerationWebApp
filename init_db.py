from app import create_app, db
from app.models import ItemPricing, Item, Customer, PickMargin, CardTable, MarginTable, WIPQuotation, FinalQuotation

app = create_app()
with app.app_context():
    db.create_all()
    wip = WIPQuotation(quotation_id="123")
    customer = Customer(customer_id="test123", title="Mr", name="Test User", billing_address="123 St", shipping_address="456 St", phone_number="1234567890", whatsapp_number="1234567890")
    db.session.add(wip)
    db.session.add(customer)
    db.session.commit()