from flask import Flask

app = Flask(__name__)

from app import login
from app import itemScanner
# from app import admin_views
