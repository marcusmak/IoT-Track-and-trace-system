import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override 
  _LoginPageState createState(){
    return _LoginPageState();
    
  }
}

class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(body: 
        Stack(
          children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/test.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.9), BlendMode.dst),
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
                          child: Container(
                            
                            height:MediaQuery.of(context).size.height * 0.4,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                usernameInputWidget(),
                                passwordInputWidget(),
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
        MediaQuery.of(_context).size.width  * 0.25,
        MediaQuery.of(_context).size.height * 0.1,
        0,0
      ),
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
    return TextFormField(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize:20,
          fontWeight: FontWeight.w500,
          // color:Color.fromRGBO(225, 222, 210, 1)
        ),
        labelText:  "Username",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:Color.fromRGBO(225, 222, 210, 1)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(width: 1,)
        ),

      ),
    );
  }
  Widget passwordInputWidget(){
    return TextFormField(
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize:20,fontWeight: FontWeight.w500),
        labelText:  "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(width: 1,)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:Color.fromRGBO(225, 222, 210, 1)),
        ),

      ),
    );
  }

  Widget loginButton(BuildContext _context){
    return Container(
      height: MediaQuery.of(_context).size.height * 0.07,
      child: MaterialButton(
        onPressed: (){},
        child: Center(
          child: 
          Text(
            "LOGIN",
            style:TextStyle(fontSize:25, color:Color.fromRGBO(225, 222, 210, 1), fontWeight: FontWeight.w600)
          ) 
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(89,56,33,1),
            Color.fromRGBO(89,56,33,1),
          ],
        )
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
              print("forget password!");
            },
            child: 
            Text(
              "Forget password",
              // style:TextStyle(
              //   color:const Color.fromARGB(255, 225, 222, 210),//Color(0xE1DED2ff)
              // )
            ),
          ),
          GestureDetector(
            onTap: () {
              print("sign up");
            },
            child: Text(
              "Sign up"
            ),

          ),
      ],)
    );

  }
}
