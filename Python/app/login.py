from app import app
from flask import request, jsonify, make_response
from markupsafe import escape
from . import database_connector
import bcrypt
import mysql.connector

@app.route("/")
def index():
    return "Hello world"

@app.route('/login',methods=['POST'])
def login():
    if request.method == 'POST':
        content = request.json
        # print(content)
        if validate_login(content['username'],
                       content['password']):
            return "Welcome, %s!" %content['username']
            # return jsonify({
            #     "username": content['username']
            # })
            # return log_the_user_in(request.form['username'])
        error = 'Invalid username/password'
        return error
    return make_response(jsonify({"message":'login error'}),400)
        
@app.route('/signup',methods=['POST'])
def signup():
    if request.method == "POST":
        content = request.json
        res = validate_userInfo(content)
        if(res.status == 201):

            return make_response(res)
        else:
            return make_response(res)
    
    return make_response(jsonify({"message":"sign up error"}),400)

def validate_userInfo(json):
    db = database_connector.db_connect()
    username, email, password, sex, age, occupation, area, inter = \
        json['username'], json['email'], json['password'], json['sex'], json['age'],json['occupation'], json['area'], json['inter']
    if(username and email and password and sex and age and occupation and area and inter):
        try:
            if(db):
                cursor = db.cursor(dictionary=True)
                query = "SELECT COUNT(*) as count FROM user WHERE `username` = '%s'" % escape(username)
                cursor.execute(query)
                search_result = cursor.fetchone()
                if(search_result and search_result['count'] != 0):
                    return make_response(jsonify({"message":"Username has been taken"}),409)
                query = "SELECT COUNT(*) as count FROM user WHERE `email` = '%s'" % escape(email)
                cursor.execute(query)
                search_result = cursor.fetchone()
                if(search_result and search_result['count'] != 0):
                    return make_response(jsonify({"message":"Email has been registered"}),409)
                query = "INSERT INTO user(username,email,password,sex,age,hGPS) VALUES (%s,%s,%s,%s,%s,%s)"
                data = (username, email, bcrypt.hashpw(password.encode("utf-8"),bcrypt.gensalt()) \
                    , sex , age, area)
                print(query)
                cursor.execute(query,data)
                cursor.close()
                db.commit() 
                database_connector.db_disconnect(db)
                return make_response(jsonify({"message":"Sign Up success"}),201)
        except mysql.connector.Error as err:
            cursor.close()
            database_connector.db_disconnect(db)
            print(err)
            return make_response(jsonify({"message":"sign up error"}),400)
    
    return make_response(jsonify({"message":"unknown sign up error 2"}),400)



def validate_login(username,password):
    db = database_connector.db_connect()
    result = False
    print("here")
    if(db):
        cursor = db.cursor(dictionary=True)
        query = "SELECT password FROM user WHERE `username` = '%s'" % escape(username)
        cursor.execute(query)
        search_result = cursor.fetchone()
        if search_result != None:
            if(bcrypt.checkpw((escape(password).encode("utf-8")),search_result['password'].encode("utf-8"))):
                result = True
        cursor.close()
        database_connector.db_disconnect(db)
    return result
