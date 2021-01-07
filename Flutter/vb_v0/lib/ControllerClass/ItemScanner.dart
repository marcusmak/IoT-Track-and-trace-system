import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/ServerHelper/PostHandler.dart';
import 'package:vb_v0/main.dart';

import '../Global_var.dart';


class ItemScanner{
  void Function(List<Map<String,dynamic>>) setMaps;
  ItemScanner(this.setMaps);

  Future<bool> scanTags() async{
    if(MyApp.bluetoothDevice !=  null && MyApp.bluetoothDevice.isConnected){
      if(!gattPlatform.checkMethodCallHandler(methodCallHandler)){
        print("Setting gatt method handler");
        gattPlatform.setMethodCallHandler(methodCallHandler);
      }
      await gattPlatform.invokeMethod("scanTags");
      return true;
    }else{
      return false;
    }
  }

  Future<void> methodCallHandler(MethodCall call){
    switch(call.method){
      case 'scanTagsRes':{
        print("fetchItemsRes1 scanned: " + call.arguments.toString());
        scanTagsRes(call.arguments);
        break;
      }
      default:
        print('TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
    }

    // return Future<void>;
  }

  void scanTagsRes(List<dynamic> arguments){
    // List<String> res = arguments;
    print("Inside the 2 res");
    print("fetchItemsRes2 scanned: " + arguments.first.toString());
    epc2class(arguments).then((value) { setMaps(value);});

  }

  Future<List<Map<String,dynamic>>> epc2class(List<dynamic> epc) async{
    // print("EPC to string" + epc.toString());
    String res = await PostHandler("/epc2class",<String,List<dynamic>>{"EPC":epc});
    // print("EPC2item request to server: "+ res);
    List temp = jsonDecode(res);
    List<Map<String,dynamic>> maps = temp.map((e) => e as Map<String,dynamic>).toList();

    print("converted to " + maps.first['className']);
    return maps;
  }

}