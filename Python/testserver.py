# # vb_v0CECI2@HKUST
# from flask import Flask, request, jsonify
# from markupsafe import escape
# import mysql.connector

# # from flask_restful import Resource, Api
# # from sqlalchemy import create_engine
# # from json import dumps
# ## from flask.ext.jsonpify import



# app = Flask(__name__)

# if __name__ == '__main__':
#     app.run(host= '0.0.0.0',debug=True)


# def db_query():
#     PWD = "vb_v0CECI2@HKUST"
#     try:
#         cnx = mysql.connector.connect(user='root', password=PWD,
#                                     host='127.0.0.1',
#                                     database='vb_v0')
#         cursor = cnx.cursor()
#         query = ("SELECT * FROM user")
#         cursor.execute(query)
#         for element in cursor:
#             print(element)
#         cursor.close()

#         cnx.close()
#     except:
#         print("Error")

# @app.route('/')
# def index():
#     return 'Index Page'

# @app.route('/hello')
# def hello():
#     return 'Hello, World'

# @app.route('/login',methods=['POST'])
# def login():
#     if request.method == 'POST':
#         content = request.json
#         if valid_login(content['username'],
#                        content['password']):
#             return jsonify({
#                 "username": content['username']
#             })
#             # return log_the_user_in(request.form['username'])
#         # else:
#         #     error = 'Invalid username/password'
    
# def valid_login(username,password):
#     print(username,password)
#     if escape(username) == "user_mm" and escape(password) == "password":
#         return True
#     return False




# @app.route('/user/<username>')
# def show_user_profile(username):
#     # show the user profile for that user
#     return 'User %s' % escape(username)

# @app.route('/post/<int:post_id>')
# def show_post(post_id):
#     # show the post with the given id, the id is an integer
#     return 'Post %d' % post_id

# @app.route('/path/<path:subpath>')
# def show_subpath(subpath):
#     # show the subpath after /path/
#     return 'Subpath %s' % escape(subpath)

# @app.route('/projects/')
# def projects():
#     return 'The project page'
