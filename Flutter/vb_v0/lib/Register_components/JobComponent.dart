import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobComponent extends StatefulWidget{
  @override
  _JobComponentState createState() => _JobComponentState();
}

class _JobComponentState extends State<JobComponent>{
  @override
  Widget build(BuildContext context){
  
    return Container(
      child:Column(
        children: <Widget>[
        Expanded(
                flex:1, 
                
                child:
                  Container(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("What's your job?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                      ],
                    )
                      
                    
                  )
                    
                ), 
        Expanded(flex:3, 
          child:
           Text("")

          
      
        )
      ],)
    );
  }
}