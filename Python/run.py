from app import app

if __name__ == "__main__":
   #app.run(debug=True)
   app.run(host= '0.0.0.0',debug=True)


# curl -H "Content-Type: application/json" -d "{\"username\":\"user_mm\",\"password\":\"password\"}" http://localhost:5000/login