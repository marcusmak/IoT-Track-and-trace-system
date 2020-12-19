import 'package:flutter/services.dart';
import 'package:vb_v0/Global_var.dart';
import 'package:vb_v0/main.dart';

class BluetoothDevice{
  String mName;
  String mAddress;

  BluetoothDevice(this.mName,this.mAddress);
  
  Future<bool> connect() async {
    try {
      if(await blePlatform.invokeMethod("bleConnect",{"mName":this.mName,"mAddress":this.mAddress})){
          return true;
      };
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }

    return false;
  }

  Future<bool> disconnect() async {
    try {
      if(await blePlatform.invokeMethod('bleDisconnect',{"mAddress":this.mAddress})){
        return true;
      }
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
    return false;
  }

  Future<String> fetchCharValue() async{
    try {
      if(await gattPlatform.invokeMethod("fetchCharValue")){
        return "true";
      }
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
    return "false";
    
  }
}

