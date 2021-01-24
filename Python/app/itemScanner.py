from app import app
from flask import request, jsonify, make_response
from markupsafe import escape
from . import database_connector
import json
import mysql.connector

@app.route("/epc2class",methods=['POST'])
def epc2item():
    if request.method == "POST":
        content = request.json
        print(content)
        db_search = fetchEpcClass(content['EPC'])
        if( db_search != None):
            print("return EPC class names")
            return make_response(jsonify(db_search),200)
        return make_response("null",404)

def fetchEpcClass(epc):
    query = "SELECT EPC,class.classID,className,classType FROM (SELECT * FROM epc2class WHERE epc2class.EPC IN('" \
        + "','".join(epc) + "')) AS EPCTable "
    query += "INNER JOIN class ON class.classID = EPCTable.classID "
    print("search database with query: " + query)
    db = database_connector.db_connect()
    
    try:
        if(db):
            cursor = db.cursor(dictionary=True)
            cursor.execute(query)
            result = cursor.fetchall()
            print(cursor.rowcount)
            if(cursor.rowcount <= 0):
                result = None
            print(result)
            cursor.close()
            db.commit() 
            database_connector.db_disconnect(db)
    except mysql.connector.Error as err:
        result = None
        cursor.close()
        database_connector.db_disconnect(db)
        print(err)
    return result
