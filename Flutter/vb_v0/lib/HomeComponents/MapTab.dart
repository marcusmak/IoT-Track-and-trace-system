// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:vb_v0/ControllerClass/LocalDataManager.dart';
import 'package:vb_v0/HelperComponents/Custom_popup_tile.dart';
import 'package:vb_v0/ModelClass/Pin.dart';

class MapTab extends StatefulWidget {
  static Map<Marker,Pin> marker2pins = new Map();

  @override
  State<MapTab> createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  // List<Marker> _markers = new List();

  // List<Pin> _points = [
  //   new Pin(LatLng(50.732342,-3.52343),"A",0,0.25),
  //   new Pin(LatLng(50.72342,-3.5123423),"A",0,0.5),
  //   new Pin(LatLng(50.7323492,-3.51923),"A",0,1),
  // ];



  static const _markerSize = 40.0;
  List<Marker> _markers = [];

  /// Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    LocalDataManager.fetchPinHistory().then((list)=>updatePins(list));

  }

  void updatePins(List<Pin> pins){
    if(pins == null) {
      print("no pin his ");
      return;
    }
    print("update pins");
    print(pins.toString());
    setState((){
      _markers = pins
          .map(
            (Pin pin) {

              Marker res = new Marker(
                point: pin.point,
                width: _markerSize,
                height: _markerSize,
                builder: (_) =>
                    Icon(Icons.location_on, size: _markerSize,
                      color: Color.fromRGBO(255, 0, 0, pin.intensity),),
                anchorPos: AnchorPos.align(AnchorAlign.top),
              );

              MapTab.marker2pins[res] = pin;
              return res;
            }
      )
      .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
        FlutterMap(
        options: MapOptions(
          center: LatLng(50.731292,-3.519817),
          plugins: [PopupMarkerPlugin()],
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          PopupMarkerLayerOptions(
            markers: _markers,
            // popupSnap: widget.popupSnap,
            popupController: _popupLayerController,
            popupBuilder: (BuildContext _, Marker marker) => ExamplePopup(marker),
          ),
          // MarkerLayerOptions(
          //   markers: ,
          // ),
        ],
      )
    );
  }


}




