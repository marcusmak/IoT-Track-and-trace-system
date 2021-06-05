import 'package:latlong/latlong.dart';


class Pin{
  double intensity;
  LatLng point;
  int timestamp;
  String ItemName;
  String ClassName;



  Pin(this.point,this.ItemName,this.ClassName,this.timestamp,this.intensity);

  Pin.fromMap(Map<String,dynamic> map){

    String temp = map.containsKey("loc")?map["loc"]:null;
    if(temp == null || temp == "null" ){
      this.point = null;
    }else{
      List<String> latlng = temp.split(",");
      this.point = LatLng(double.parse(latlng[0]),double.parse(latlng[1]));
      print(point.toString());
    }

    this.intensity = map.containsKey("color_intensity")?map["color_intensity"]:null;
    // if(temp == null || temp == "null" ){
    //   this.intensity = null;
    // }else{
    //   this.intensity = double.parse(temp);
    // }

    this.timestamp = map.containsKey("timestamp")?map["timestamp"]:null;
    // if(temp == null || temp == "null"){
    //   this.timestamp = null;
    // }
    // this.timestamp = int.parse(temp);

    temp = map.containsKey("name")?map["name"]:null;
    if(temp == null || temp == "null"){
      this.ItemName = null;
    }
    this.ItemName = temp;

    this.ClassName = map.containsKey("className")?map["className"]:null;


  }
}
