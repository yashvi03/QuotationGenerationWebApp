from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv
import os

from flask_cors import CORS



# Initialize the SQLAlchemy instance globally
db = SQLAlchemy()

# Load environment variables from the .env file
load_dotenv()

def create_app():
    app = Flask(__name__)

    # Fetch the secret key from environment variables
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'default_secret_key')

    # Configure database URI
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
        'DATABASE_URL', 'postgresql://postgres:Yashvi%402003@localhost:5432/puranmalsons'
    )
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # Initialize database
    db.init_app(app)

    CORS(app)


    # Register blueprints
    from app.controllers.item_controller import item_bp
    from app.controllers.customer_controller import customer_bp
    # from app.controllers.quotation_controller import quotation_bp
    # from app.controllers.addItem_controller import additem_bp
    from app.controllers.pickMargin_controller import pickMargin_bp
    from app.controllers.card_controller import card_bp
    from app.controllers.WIP_quotation_controller import wip_quotation_bp
    from app.controllers.FinalQuotation_controller import final_quotation_bp
    from app.controllers.DownloadPDF import download_quotation_bp
    from app.controllers.SharePdf import share_quotation_bp
    # from app.controllers.quotation import create_quotation_bp

    app.register_blueprint(item_bp, url_prefix="/items")
    app.register_blueprint(customer_bp, url_prefix="/")
    # app.register_blueprint(quotation_bp, url_prefix="/quotations")  
    # app.register_blueprint(additem_bp, url_prefix="/additem")
    app.register_blueprint(pickMargin_bp, url_prefix="/")
    app.register_blueprint(card_bp, url_prefix="/")
    app.register_blueprint(wip_quotation_bp, url_prefix="/")
    app.register_blueprint(final_quotation_bp, url_prefix="/")
    app.register_blueprint(download_quotation_bp, url_prefix="/")
    app.register_blueprint(share_quotation_bp, url_prefix="/")
    # app.register_blueprint(create_quotation_bp, url_prefix="/create_quotation")

    return app
