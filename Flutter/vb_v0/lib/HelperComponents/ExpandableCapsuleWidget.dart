// import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandableCapsuleWidget extends StatelessWidget {
  final Widget child;
  final Widget title;
  static const Color barBgColor = Color.fromARGB(200, 60  , 60  , 60);
  const ExpandableCapsuleWidget({Key key,this.title,@required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
        Padding(
          padding: EdgeInsets.symmetric(
            vertical:   MediaQuery.of(context).size.height * 0.025,
            horizontal: MediaQuery.of(context).size.width * 0.05
          ),
          child: Material(
            color: Colors.transparent,
            shadowColor: Colors.white24,
            elevation: 20,
            child:Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.white,
              //     blurRadius: 25.0, // soften the shadow
              //     spreadRadius: 0.1, //extend the shadow
              //     offset: Offset(
              //       5.0, // Move to right 10  horizontally
              //       5.0, // Move to bottom 10 Vertically
              //     ),
              //   )
              // ],
              // border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
              color: barBgColor,
              // gradient: LinearGradient(
              //   colors: [
              //     Color.fromRGBO(89,56,33,1),
              //     Color.fromRGBO(89,56,33,1),
              //   ],
              // )
            ),
            child:
            Theme(
              data : ThemeData(
                accentColor: Colors.white, 
                unselectedWidgetColor: Colors.white, 
                selectedRowColor: Colors.transparent,
                indicatorColor: Colors.transparent
              ), 
              child: ExpansionTile(
                // leading: Icon(Icons.arrow_back),
                // backgroundColor: Colors.black,
                
                title: this.title,
                initiallyExpanded: true,
                onExpansionChanged: (bool _isExpanded){
                  print(_isExpanded);
                },
                children: <Widget>[
                    this.child
                  ],
              ),
            ),
          )
         )
        )
        
      
      // Text(this.title),
    );
  }
}