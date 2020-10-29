import 'dart:ui';

import 'package:flutter/material.dart';
class ExpandableCapsulteWidget extends StatelessWidget {
  final Widget child;
  final Widget title;
  static const Color barBgColor = Color.fromARGB(255, 79, 79, 79);
  const ExpandableCapsulteWidget({Key key,this.title,@required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
        Padding(
          padding: EdgeInsets.symmetric(
                                          vertical:   MediaQuery.of(context).size.height * 0.025,
                                          horizontal: MediaQuery.of(context).size.width * 0.01
                                        ),
          child: Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
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
        
      
      // Text(this.title),
    );
  }
}