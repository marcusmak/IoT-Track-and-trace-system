// import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_map/simple_map.dart';
import 'package:vb_v0/HelperComponents/InputWidget.dart';
import 'package:vb_v0/ModelClass/UserProfile.dart';
import 'package:http/http.dart' as http;
import '../Global_var.dart';


class MapComponent extends StatefulWidget{
  final UserProfile userProfile;
  final PageController controller;
  
  MapComponent({ Key key, this.userProfile, this.controller}) : super(key: key);
  @override
  _MapComponentState createState() => _MapComponentState(userProfile: this.userProfile, controller: this.controller); 
}

class _MapComponentState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final UserProfile userProfile;
  final PageController controller;
  _MapComponentState({this.userProfile, this.controller});

  final mapOptions = SimpleMapOptions(
    // You can use your own map image
    // mapAsset: 'assets/map.png',
    mapColor: Color.fromARGB(255, 225, 225, 225),
    bgColor: Colors.transparent,//Color.fromARGB(255, 255, 255, 255),
  );

  final SimpleMapController mapController = SimpleMapController();

  void registerProfile(){
    print("object");
    http.post(SERVER_URL+'/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: userProfile.toJSON(),
    ).then((value){
      if(value.statusCode == 201){
        //TODO
        //store username and password and userid //jwt? //session?
        Navigator.of(context).pushReplacementNamed("/scan_setup");


      }
    });
  }

  @override
  Widget build(BuildContext context){
    mapController.addPoint(SimpleMapPoint());
    return Container(
      child:Column(
        children: <Widget>[
        Expanded(
                flex:1, 
                child:
                  Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.025),
                    child:Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Place of residence", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 35),)
                      ],
                    )
                  )
        ), 
        Expanded(flex:5, 
          child:
            SingleChildScrollView(
              child:
                Column(
                  children:<Widget>[
                    inputWidget(context,"Country"),
                    inputWidget(context,"Home"),
                    SimpleMap(
                      controller: mapController,
                      options: mapOptions,
                    ),
                  ]
                )
            )
        ),
      
       Container(child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
              padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
              child: GestureDetector(
                  onTap: () {
                    controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                  },                
                  child: Text("Prev",style: TextStyle(color: Colors.white),),
                )
                  
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.1),
                child: GestureDetector(
                  onTap: () {
                    // controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                    // if()
                    print(userProfile.toString());
                    registerProfile();
                      // Navigator.pushReplacementNamed(context, '/scan_setup');
                  },                
                  child: Text("Confirm",style: TextStyle(color: Colors.white),),
                )
                  
              ),
            ],
          )
        ,)

      ],)
    );
  }

}
