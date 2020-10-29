import 'package:flutter/material.dart';
import 'package:vb_v0/HelperComponents/ExpandableCapsulteWidget.dart';

class ListTab extends StatelessWidget{
    static const TextStyle titleStyle = 
    TextStyle(
              color:Color.fromRGBO(207, 190, 190, 1), 
              fontSize: 25,
              fontWeight: FontWeight.w800
    );
    // const ListTab({Key key, this.style}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      // print(style);
      return SingleChildScrollView(
        child:
          Column(
            children: <Widget>[
              ExpandableCapsulteWidget(
                title: Text("Digital",style: titleStyle,),
                child: Text("qew"),
              ),
              ExpandableCapsulteWidget(
                title: Text("Sport",style: titleStyle,),
                child: Text("qew"),
              ),
              ExpandableCapsulteWidget(
                title: Text("Work",style: titleStyle,),
                child: Text("qew"),
              ),
              ExpandableCapsulteWidget(
                title: Text("Clothes",style: titleStyle,),
                child: Text("qew"),
              ),
              
            ]
          )
      );
    }
}