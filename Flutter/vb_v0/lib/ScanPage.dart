import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ModelClass/Item.dart';

// import 'ControllerClass/BLEConnector.dart';



class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  static const TextStyle ts = TextStyle(fontSize: 32.0, color: Color.fromARGB(200, 255, 255, 255), fontWeight: FontWeight.bold);
  bool scanned = false;
  ItemFetcher itemFetcher = ItemFetcher();
  // int testState = 0;
  Duration scanTimeout = Duration(seconds: 10);
  bool isTimeout = false;

  @override
  void initState() { 
    super.initState();
    scanItem();
    Future.delayed((Duration(milliseconds: 5000)),(){
      itemFetcher.initItems();
    });
    Timer(scanTimeout,handleTimeout);
  }

  void scanItem(){
    print("Scanning Item");
    if(!itemFetcher.isEmpty())
      setState(() {
          scanned = true;
      });
    if(isTimeout)
      return;
    Future.delayed((Duration(milliseconds: 1000)), ()=>scanItem());
    // else

  }

  void handleTimeout(){
    print("Timeout");
    setState(()=>{isTimeout= true});
  }

  Widget scanningTextWidget(){
    return Center(
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Scanning",style:ts),
                  TyperAnimatedTextKit(
                    speed: Duration(milliseconds: 200),
                    // totalRepeatCount: 4,
                    // repeatForever: true, //this will ignore [totalRepeatCount]
                    pause: Duration(milliseconds:  1000),
                    text: ["..."],
                    textStyle: ts,
                    // displayFullTextOnTap: true,
                    // stopPauseOnTap: true
                  ),
                  //TODO: test bluetooth function
                  // BLEConnector() 

                ],)
              );
  }

  Widget itemGridView(){

    return GridView.builder(
      itemCount: itemFetcher.items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

      ), 
      itemBuilder: (context, i){
        Item temp = itemFetcher.items[i];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical:   MediaQuery.of(context).size.height*0.01,
            horizontal: MediaQuery.of(context).size.width*0.025,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical:   MediaQuery.of(context).size.height*0.01,
              horizontal: MediaQuery.of(context).size.width*0.025,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color:Colors.blueGrey,
            ),
            child: Text(temp.name,style: ts,)
          ),  
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: scanned?itemGridView():scanningTextWidget(),
      floatingActionButton: isTimeout?FloatingActionButton(
        onPressed: (){
          // print("transit to main page");
          Navigator.pushReplacementNamed(context, "/home");
        },
        child: Icon(Icons.navigate_next, color: Colors.white,size: 50,),
        
      ):null
            
      
    );
  }
}

// class ItemGridView extends StatefulWidget {
//   ItemGridView({Key key}) : super(key: key);

//   @override
//   _ItemGridViewState createState() => _ItemGridViewState();
// }

// class _ItemGridViewState extends State<ItemGridView> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: GridView.builder(
//          gridDelegate: null, 
//          itemBuilder: null
//         ),
//     );
//   }
// }