import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vb_v0/ControllerClass/BluetoothDevice.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/ServerHelper/PostHandler.dart';
import 'package:vb_v0/main.dart';

import '../Global_var.dart';


class ItemScanner{
  void Function(List<Map<String,dynamic>>) setMaps;
  ItemScanner(this.setMaps);
  List<String> EPC_list = new List();

  Future<bool> scanTags() async{
    // print("item scnner");
    if((MyApp.bluetoothDevice ==  null || !MyApp.bluetoothDevice.isConnected)
      && ( await BluetoothDevice.bleGetConnected() == null)
        && (await BluetoothDevice.connectLastSession() == null)) {
      print("not connected in scanTags");
      return false;
    }
    if(!gattPlatform.checkMethodCallHandler(methodCallHandler)){
      print("Setting gatt method handler");
      gattPlatform.setMethodCallHandler(methodCallHandler);
    }
    await gattPlatform.invokeMethod("scanTags");
    return true;
      // List<Map<String,dynamic>> tempList = [];
      // Map<String,dynamic> tempMap = {
      //   "EPC":"fakeEPC6",
      //   "classID":"00007",
      //   "className":"Shirts",
      //   "classType":"Clothes",
      //   "name":"White Shirt (M&S)",
      // };
      // tempList.add(tempMap);
      //
      // setMaps(tempList);
      //
      
      
      return false;
    }

  Future<void> methodCallHandler(MethodCall call){
    switch(call.method){
      case 'scanTagsRes':{
        scanTagsRes(call.arguments);
        break;
      }
      default:
        print('TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
    }

    // return Future<void>;
  }

  void scanTagsRes(List<dynamic> arguments){
    String epc = arguments.first.toString();
    print("fetchItemsRes scanned: " + epc);
    if(!EPC_list.contains(epc)) {
      EPC_list.add(epc);
      print("added to EPC List");
      epc2class(arguments).then((value) {
        setMaps(value);
      });
    }
  }



}