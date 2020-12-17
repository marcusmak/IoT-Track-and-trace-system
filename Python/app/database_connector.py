import mysql.connector

def db_connect():
    PWD = "vb_v0CECI2@HKUST"
    db = None
    try:
        db = mysql.connector.connect(user='root', password=PWD,
                                    host='127.0.0.1',
                                    database='vb_v0')
    except:
        print("Error in db connection")
    return db


def db_disconnect(db):
    try:
        db.close()
    except:
        print("Error in db disconnection")