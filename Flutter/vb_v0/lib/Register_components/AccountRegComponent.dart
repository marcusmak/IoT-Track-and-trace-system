// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:vb_v0/HelperComponents/InputWidget.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart';

class AccountRegComponent extends StatefulWidget{
  final UserProfile userProfile;
  final PageController controller;
  AccountRegComponent({Key key, this.userProfile, this.controller}):super(key: key);
  @override
  _AccountRegComponentState createState(){
    return _AccountRegComponentState(userProfile: this.userProfile, controller: this.controller);
  }
}

class _AccountRegComponentState extends State<AccountRegComponent> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final UserProfile userProfile;
  final PageController controller;
  _AccountRegComponentState({this.userProfile, this.controller});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  Widget QuestionWidget(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
          inputWidget(context,"Email",controller:_emailController,validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains("@") || !value.endsWith(".com")) {
              return 'Please enter your valid email';
            }
            return null;
          },),
          inputWidget(context,"Username",controller:_usernameController,validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },),

          inputWidget(context,"Password",controller:_pwdController, obscure: true,validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'The length of password must be greater than 6';
            }
            return null;
          },),

          inputWidget(context,"Confirm password",controller:_confirmPwdController, obscure: true,validator: (value) {
            if (value.isEmpty) {
              return 'Please confirm your password';
            }
            String temp = _pwdController.text;
            if (value != temp) {
              return 'Password mismatch';
            }
            return null;
          },),
      ]
    );
  }

  @override
  Widget build(BuildContext context){
    return 
    Container(
      //constraints: BoxConstraints.expand(),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
              Expanded(child: QuestionWidget(),),
              Container(child:
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
                      child: GestureDetector(
                        onTap: () {
                            // if (_formKey.currentState.validate()){
                              userProfile.userName = _usernameController.text;
                              userProfile.email = _emailController.text;
                              userProfile.password = _pwdController.text;
                              controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                            // }
                        },                
                        child: Text("Next",style: TextStyle(color: Colors.white),),
                      )
                        
                    ),
                  )
              )
          ]
        )
      )
    );
    
    
    

         
  }

}