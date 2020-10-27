// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class AccountRegComponent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
        return Container(
          // constraints: BoxConstraints.expand(),
          height:MediaQuery.of(context).size.height * 0.75,
          child:Form(
              child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  QuestionWidget(),
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

class _QuestionWidgetState extends State<QuestionWidget>{
  @override
  Widget build(BuildContext context){
    return Column(
      children:[
          inputWidget(context,"Email"),
          inputWidget(context,"Username"),
          inputWidget(context,"Password"),
          inputWidget(context,"Confirm password"),
          submitWidget(context),
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


  Widget inputWidget(BuildContext _context, String labelText){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child:TextFormField(
        
        decoration: InputDecoration(
          counterStyle: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.w500,
            color:Color.fromRGBO(225, 222, 210, 1)
          ),
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
          
        )
      )
    );
  }
}