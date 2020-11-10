// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_map/simple_map.dart';
import 'package:vb_v0/HelperComponents/InputWidget.dart';


class MapComponent extends StatefulWidget{
  @override
  _MapComponentState createState() => _MapComponentState(); 
}

class _MapComponentState extends State with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  
  final mapOptions = SimpleMapOptions(
    // You can use your own map image
    // mapAsset: 'assets/map.png',
    mapColor: Color.fromARGB(255, 225, 225, 225),
    bgColor: Colors.transparent,//Color.fromARGB(255, 255, 255, 255),
  );

  final SimpleMapController mapController = SimpleMapController();


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
        )
      ],)
    );
  }

}