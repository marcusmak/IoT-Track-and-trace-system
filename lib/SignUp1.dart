import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUp1 extends StatelessWidget {
  SignUp1({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff323232),
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/test.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstIn),
              ),
              border: Border.all(width: 1.0, color: const Color(0x00000000)),
            ),
          ),
          // Adobe XD layer: 'Account Setting' (group)
          Align(
             alignment: Alignment(0.0,-0.25), 
             child: 
                Account_setting()
          )
        ]
      )
    );
  }
}

class Account_setting extends StatelessWidget{
  Account_setting({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children:<Widget>[
          InputBox(hintText:"Enter your Email",obscure:false),
          InputBox(hintText:"Password",obscure:true),
          Padding(
            padding: EdgeInsets.symmetric(vertical:10.0),
            child:Container(
              child: FlatButton(
                color: const Color.fromARGB(255, 59, 38, 21), //(0x59382100)
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                // splashColor: Colors.blueAccent,
                onPressed: () {
                  /*...*/
                },
                // minWidth:300,
                // minHeight:40,
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 20.0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(color: Colors.white)
                ),
              ),

              width: 300,
              height: 40,
              
            )
         ),
         Padding(padding: EdgeInsets.symmetric(vertical:10.0),
          child: Container(
              width: 300,
              height: 40,
              child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Not a member? "),
                        Text("Sign Up Now",style:TextStyle(
                          color:const Color.fromARGB(255, 225, 222, 210),//Color(0xE1DED2ff)
                        )),

                        ],
                      ),
              alignment:AlignmentDirectional.topEnd,
              
          )
         )
         
     
      ]
    );
  }




}


class InputBox extends StatelessWidget{
  InputBox({Key key,this.hintText, this.obscure}): super(key: key);

  final String hintText;
  final bool obscure;

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Container
          (
           height:40,
           width:300,
           decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      color: const Color(0xffffffff),
                      border: Border.all(
                          width: 1.0, color: const Color(0xffede1b1)),
                    ),
            child: Padding(
              padding: EdgeInsets.only(left:15.0),
              child:TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: this.hintText,
                ),
                style: TextStyle(
                  fontFamily: 'Century Gothic',
                  fontSize: 20,
                  // color: const Color(0x),
                ),
                obscureText: this.obscure
              )
            
            )

         )
    );
  }
}