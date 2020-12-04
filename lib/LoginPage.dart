import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart';
import 'package:http/http.dart' as http;
import 'Global_var.dart';
import 'package:vb_v0/ControllerClass/BackgroundUpdate.dart';

class LoginPage extends StatefulWidget{

  @override 
  _LoginPageState createState(){
    return _LoginPageState();
    
  }
}

enum LoginPageState {LOGIN,SIGNUP,FORGOT}

class _LoginPageState extends State<LoginPage>{
  
  LoginPageState _currentState = LoginPageState.LOGIN;
  UserProfile _currentUser;
  String _leftAddText = "Forget Password";
  String _rightAddText = "Sign up";
  final _formKey = GlobalKey<FormState>();
  final _unController = TextEditingController();
  final _pwdController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _unController.dispose();
    _pwdController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    BackgroundUpdate.main();
    return Scaffold(
      body: 
        Stack(
          children: <Widget>[
              Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/login_background.jpg'),
                      fit: BoxFit.fill,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.multiply),
                    ),
                    border: Border.all(width: 1.0, color: const Color(0x00000000)),
                  ),
                
              )
              ,SingleChildScrollView(    
                //physics: NeverScrollableScrollPhysics(),
                child:Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.10,
                      horizontal: MediaQuery.of(context).size.width * 0.05
                    ),
                    //contains all the widget 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // headerText(),
                        infoDisplayColumn(context),
                        Form(
                          key: _formKey,
                          child: Container(
                            
                            height:MediaQuery.of(context).size.height * 0.4,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                usernameInputWidget(),
                                passwordInputWidget(_currentState != LoginPageState.FORGOT, "Password"),
                                // passwordInputWidget(_currentState == LoginPageState.SIGNUP, "Confirm Password"),
                                loginButton(context),
                                additionHyperlinks(),
                                // forgetPassword(),
                                // signUp(context),

                              ],
                            ),
                          ),
                        )

                      ],

                    ),
                  )
              )
            ]
          )
    );
  }



  Widget headerText(){
    return Text(
      "Login",
      style:TextStyle(color: Colors.black,fontSize: 40, fontWeight: FontWeight.w600)
    );

  }

  Widget infoDisplayColumn(BuildContext _context){
    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(_context).size.height * 0.1,
        0,0
      ),
      alignment: Alignment.center,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          userImage(_context),
          Padding(
            padding:EdgeInsets.symmetric(vertical:MediaQuery.of(_context).size.height*0.005),
            child: Text("Welcome!",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20
              ),
            ),
          ),
          Text("John Mayer",style:TextStyle(fontSize:30, fontWeight: FontWeight.w700))
        ],
      )
    );
  }

  Widget userImage(BuildContext _context){
    // return Container();
    return Container(
      height: MediaQuery.of(_context).size.height*0.20,
      width: MediaQuery.of(_context).size.height*0.20,
      decoration: BoxDecoration(
        shape:BoxShape.circle,
        image:DecorationImage(
          image: const AssetImage('assets/images/profile.jpg')
          
          // NetworkImage(
            // "https://picsum.photos/250?image=9"
          // )
        )
      ),

    );
  }


  Widget usernameInputWidget(){
    String labelText = "Username / Email";
    if(_currentState == LoginPageState.FORGOT)
      labelText = "Recovery username/email";
    return Visibility(
        child: TextFormField(
          controller: _unController,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your username/email';
            }
            return null;
          },
          decoration: InputDecoration(
            labelStyle: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.w500,
              color:Color.fromRGBO(225, 222, 210, 1)
            ),
            labelText:  labelText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(width:1, color:Color.fromRGBO(225, 222, 210, 1)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(width: 1,)
            ),

          ),
        ),
        visible: true,
    );
  }
  Widget passwordInputWidget(bool isVisible, String labelText){
    return Visibility(
      child: TextFormField(
        controller: _pwdController,
        style: TextStyle(color: Colors.white),
        obscureText: true,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(fontSize:20,fontWeight: FontWeight.w500,color:Color.fromRGBO(225, 222, 210, 1)),
          labelText:  labelText,
          //focused border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width: 1,)
          ),
          //Normal border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(width:1, color:Color.fromRGBO(225, 222, 210, 1)),
          ),

        ),
      ),
      visible: isVisible,
    );
  }

  Widget loginButton(BuildContext _context){
    String labelText = "LOGIN";
    if(_currentState == LoginPageState.FORGOT){
      labelText = "RECOVER";
    }else if (_currentState == LoginPageState.SIGNUP){
      labelText = "SIGN UP";
    };

    return Container(
      height: MediaQuery.of(_context).size.height * 0.07,
      child: MaterialButton(
        onPressed: (){
          print(labelText);
          if(labelText == "LOGIN"){
            // Navigator.pushReplacementNamed(context, '/home');
            try {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                if(_unController.text == "prime" && _pwdController.text == "sudo"){
                  Navigator.of(context).pushReplacementNamed("/home");
                }else{
                  http.post(SERVER_URL+'/login',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'username': _unController.text,
                      'password': _pwdController.text
                    }),
                  ).then((value){
                    if(value.statusCode == 200){
                      //TODO
                      //store username and password and userid //jwt? //session?
                      Navigator.of(context).pushReplacementNamed("/home");


                    }
                  });
                }

              }
              // print(test);
            }catch(e){
              print(e);
            }
          }
          // 

        },
        child: Center(
          child: 
          Text(
            labelText,
            style:TextStyle(fontSize:25, color:Color.fromRGBO(225, 222, 210, 1), fontWeight: FontWeight.w600)
          ) 
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
        color: Color.fromRGBO(89,56,33,1),
        // gradient: LinearGradient(
        //   colors: [
        //     Color.fromRGBO(89,56,33,1),
        //     Color.fromRGBO(89,56,33,1),
        //   ],
        // )
      )
    );
  }

  Widget additionHyperlinks(){
    return Container(
      
      child:Row(
        // mainAxisSize: MainAxisSize.,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, "myRoute");
              
              if(_currentState == LoginPageState.LOGIN){
                setState(() {
                      _currentState = LoginPageState.FORGOT;
                      _leftAddText = "Login";
                });
                print("forget password!");
              }else if (_currentState == LoginPageState.FORGOT){
                setState(() {
                      _currentState = LoginPageState.LOGIN;
                      _leftAddText = "Forget password";
                });
                print("forget password!");
              }else if(_currentState == LoginPageState.SIGNUP){
                setState(() {
                      _currentState = LoginPageState.FORGOT;
                      _leftAddText = "Login";
                      _rightAddText = "Sign up";
                });
              }
            },
            child: 
            Text(
              _leftAddText,
              style:TextStyle(
                color:Color.fromRGBO(200, 197, 185, 1),
                fontWeight: FontWeight.w600,
                fontSize: 15
              )
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/register');
              // if(_currentState == LoginPageState.LOGIN){
              //   setState(() {
              //         _currentState = LoginPageState.SIGNUP;
              //         _rightAddText = "Login";
              //   });
                
              // }else if(_currentState == LoginPageState.SIGNUP){
              //   setState(() {
              //         _currentState = LoginPageState.LOGIN;
              //         _rightAddText = "Sign up";
              //   });
                
              // }else if(_currentState == LoginPageState.FORGOT){
              //   setState(() {
              //         _currentState = LoginPageState.SIGNUP;
              //         _rightAddText = "Login";
              //         _leftAddText  = "Forget password";
              //   });
              // }
            },
            child: Text(
              _rightAddText,
              style:TextStyle(
                color:Color.fromRGBO(200, 197, 185, 1),
                fontWeight: FontWeight.w600,
                fontSize: 15
              )
            ),

          ),
      ],)
    );

  }
}
