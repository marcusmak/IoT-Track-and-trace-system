import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/ServerHelper/PostHandler.dart';
import 'package:vb_v0/main.dart';

import '../Global_var.dart';


class ItemScanner{
  void Function(List<Map<String,dynamic>>) setMaps;
  ItemScanner(this.setMaps);
  List<String> EPC_list = new List();

  Future<bool> scanTags() async{
    print("item scnner");
    if(MyApp.bluetoothDevice !=  null && MyApp.bluetoothDevice.isConnected){
      if(!gattPlatform.checkMethodCallHandler(methodCallHandler)){
        print("Setting gatt method handler");
        gattPlatform.setMethodCallHandler(methodCallHandler);
      }
      await gattPlatform.invokeMethod("scanTags");
      return true;
    }else{
      print("not connected in scanTags");
      return false;
    }
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

  Future<List<Map<String,dynamic>>> epc2class(List<dynamic> epc) async{
    // print("EPC to string" + epc.toString());
    String res = await PostHandler("/epc2class",<String,List<dynamic>>{"EPC":epc});
    // print("EPC2item request to server: "+ res);
    print("response : " + res.toString());
    if(res != null){
      List temp = jsonDecode(res);
      List<Map<String,dynamic>> maps = temp.map((e) => e as Map<String,dynamic>).toList();

      print("converted to " + maps.first['className']);
      return maps;
    }else{
      List<Map<String,dynamic>> maps;
      epc.forEach((element) {
        maps.add({'EPC':element as String,'classType':"Other"});
      });
      return maps;
    }
  }

}