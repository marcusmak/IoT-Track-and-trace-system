import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vb_v0/ControllerClass/BluetoothDevice.dart';
import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ControllerClass/ItemScanner.dart';
import 'package:vb_v0/ControllerClass/LocalDataManager.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/main.dart';

// import 'ControllerClass/BLEConnector.dart';



class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  static const TextStyle ts = TextStyle(fontSize: 32.0, color: Color.fromARGB(200, 255, 255, 255), fontWeight: FontWeight.bold);
  bool scanned = false;
  // ItemFetcher itemFetcher = ItemFetcher();
  // int testState = 0;
  Duration scanTimeout = Duration(seconds: 1000);
  bool isTimeout = false;
  List<Item> scannedItems;
  ItemScanner _itemScanner;

  @override
  void initState() { 
    super.initState();
    _itemScanner = ItemScanner((e)=>{
      if(this.mounted){
        setState((){
          e.forEach((newElement) {
            if(scannedItems.every((element) => element.EPC != newElement['EPC'])){
              scannedItems.add(Item.fromMap(newElement));
              // scannedItems.add(newElement);
            }
          });
        })
      }
    });
    scannedItems = List();
    scanItem();
    Future.delayed((Duration(milliseconds: 100)),(){
      // ItemFetcher.initItems();
      showDialog(context: context, builder:(context)=>
        new BleDevicesDialog(context)
      );
    });
    Timer(scanTimeout,handleTimeout);
    // setState((){
    //   scannedItems.add(Item(EPC:"1234",name:"fake item",classID:"d00001",className:"Fake Class", classType: "Digital"));
    //   scannedItems.add(Item(EPC:"1224",name:"fake item2",classID:"d00001",className:"Fake Class", classType: "Digital"));
    // });
  }

  void scanItem(){

    if(isTimeout)
      return;
    if(!ItemFetcher.isEmpty())
      setState(() {
          scanned = true;
      });
    // print("scanning from " + MyApp.bluetoothDevice.toString());
    _itemScanner.scanTags();
    Future.delayed((Duration(milliseconds: 1000)), ()=>scanItem());
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
                  // TODO: test bluetooth function
                  // BLEConnector()

                ],)
              );
  }

  Widget itemGridView(){
    // return Center(child:Text("ITEM DETECTED"));
    return GridView.builder(
      itemCount: scannedItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

      ),
      itemBuilder: (context, i){

      Item temp = scannedItems[i];
      List<Widget> _itemDetails = [
        Text(temp.classType,style:ts),
        Text(temp.name!=null?temp.name:temp.className,),

      ];
      if (temp.image!=null)
        _itemDetails.add(Container(child:Image.file(File(temp.image), fit: BoxFit.scaleDown,)));


        return Padding(
          padding: EdgeInsets.symmetric(
            vertical:   MediaQuery.of(context).size.height*0.01,
            horizontal: MediaQuery.of(context).size.width*0.025,
          ),
          child: GestureDetector(

            // padding: EdgeInsets.zero,
              onTap: (){
                Navigator.pushNamed(context, "/add_item",
                    arguments:
                    {
                      "item": scannedItems[i],
                      "setItemCallback": (Item item){

                        print("set item callback triggered: " + item.toString());
                        setState(() => scannedItems[i] = item);
                      }
                    }
                );
              },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical:   MediaQuery.of(context).size.height*0.01,
              horizontal: MediaQuery.of(context).size.width*0.025,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color:Colors.blueGrey,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _itemDetails,
              )
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(scannedItems != null && scannedItems.isNotEmpty){
      print("rebuilding scan page: " +  scannedItems.toString());
    }
    print("rebuild");
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: (scannedItems != null && scannedItems.isNotEmpty)?itemGridView():scanningTextWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white60,
        onPressed: ()async{
          // print("transit to main page");
          await LocalDataManager.putAllItems(scannedItems);
          Navigator.pushReplacementNamed(context, "/home");
          setState(() {
            isTimeout = true;
          });
        },
        child: Icon(Icons.navigate_next, color: Colors.white,size: 50,),
        
      )
      
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