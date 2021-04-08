import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vb_v0/ControllerClass/LocalDataManager.dart';
import 'package:vb_v0/Global_var.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:flutter/widgets.dart';
import 'package:vb_v0/main.dart';
import 'package:vb_v0/ServerHelper/PostHandler.dart';

class ItemFetcher {
    static List<Item> items;
    static List<Item> currentHolding;
    static const FitMode = BoxFit.fill;
    // ItemFetcher(){
      
    // }
    static bool isEmpty(){
      return items == null || items.length == 0;
    }


    static Future<void> initItems(void Function() callback) async {
      LocalDataManager.BrosweData("Item");
      items = await LocalDataManager.fetchAllItems();
      print("items fetched:" );
      List<String> sysItemEPC = [];
      items.forEach((element) {
      if(element.classType == null) {
        print("system clsas: " + element.toString());
      } else
          print(element.toString());
      });


      //


      callback();
      // items = <Item> [
      //   Item(
      //     EPC: "00000",
      //     name: "Iphone 13 pro",
      //     classType: "Digital",
      //     image: "assets/images/iphone13.jpg"
      //   ),
      //   Item(
      //     EPC: "00001",
      //     name: "Airpod 3.0",
      //     classType: "Digital",
      //     image: "assets/images/airpod.jpg"
      //   ),
      //
      //
      // ];
      // callback();
      // return;
    }


}