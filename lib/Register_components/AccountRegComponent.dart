// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:vb_v0/HelperComponents/InputWidget.dart';

class AccountRegComponent extends StatelessWidget{
  // final PageController controller;
  // const AccountRegComponent({ Key key, this.controller }) : super(key: key);
  // AccountRegComponent();

  @override
  Widget build(BuildContext context){
        return Container(
          // constraints: BoxConstraints.expand(),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Form(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  QuestionWidget(),
                  // GestureDetector(
                  //   onTap: (){
                  //     print("submit");
                  //     controller.nextPage(
                  //       duration:  new Duration(seconds: 1), 
                  //       curve:     Curves.easeIn,
                  //     );
                  //   },
                  //   child: Text("submit"),
                  // )
              ]
            )
          )
        );
  }
}



class QuestionWidget extends StatefulWidget{
  @override
  _QuestionWidgetState createState(){
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    return Column(
      children:[
          inputWidget(context,"Email"),
          inputWidget(context,"Username"),
          inputWidget(context,"Password"),
          inputWidget(context,"Confirm password"),
          // submitWidget(context),
      ]
    );
         
  }

  Widget submitWidget(BuildContext _context){
    return Container(
      padding: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * 0.01),
      height: MediaQuery.of(_context).size.height * 0.07,
      child: MaterialButton(
        onPressed: (){
          print("submit");
          // Navigator.pushReplacementNamed(context, '/register');

        },
        child: Center(
          child: 
          Text(
            "Submit",
            style:TextStyle(fontSize:25, color:Color.fromRGBO(225, 222, 210, 1), fontWeight: FontWeight.w600)
          ) 
        ),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(50),
      //   border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
      //   color: Color.fromRGBO(89,56,33,1),
      //   // gradient: LinearGradient(
      //   //   colors: [
      //   //     Color.fromRGBO(89,56,33,1),
      //   //     Color.fromRGBO(89,56,33,1),
      //   //   ],
      //   // )
      // )
    );


    
    
    
    
    
  }


}