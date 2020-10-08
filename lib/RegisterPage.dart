import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( children: <Widget> [
        Container (
          constraints: BoxConstraints.expand(),
          // color: Colors.lightBlue,
          // alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/login_background(1).jpg'),
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.multiply),
                fit: BoxFit.fitHeight,
                alignment: Alignment.topLeft
              )
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.10,
              horizontal: MediaQuery.of(context).size.width * 0.05
            ),
            child:
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child:Row(
                children : <Widget> [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(217,215,157,1),
                    size: 30.0,
                  ),
                  Text("Back", style: TextStyle(color: Color.fromRGBO(217,215,157,1), fontWeight: FontWeight.w700, fontSize: 25),)
                ]
              )
            )
          )

  
      
      
        ]
      )
    );
    
    // TODO: implement build
    throw UnimplementedError();
  }

}