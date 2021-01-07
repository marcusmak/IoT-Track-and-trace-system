import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;
// import 'package:bitmap/bitmap.dart';

import 'package:meta/meta.dart';
import 'package:vb_v0/ModelClass/ItemContext.dart';
import 'package:flutter/widgets.dart';



class Item {
  //item identification serial
  String EPC;
  //class id
  String classID;
  //class of the item
  String className;
  //name of the item
  String classType;

  String name;
  //related items
  List<Item> rItems;
  //related context
  // List<ItemContext> rContexts;
  String image;

  // int imageWidth;
  // int imageHeight;
  bool in_bag = false;

  Item({@required this.EPC, @required this.name, this.rItems, this.classID, this.className, this.classType, this.image /*this.rContexts,*/});

  Item.fromMap(Map<String,dynamic> itemMap){
    Uint8List headedIntList;

    this.EPC =  itemMap.containsKey('EPC')?itemMap['EPC']:null;
    this.classID = itemMap.containsKey('classID')?itemMap['classID']:null;
    this.className = itemMap.containsKey('className')?itemMap['className']:null;
    //todo: incomplete and would cause error
    this.image = itemMap.containsKey('image')?itemMap['image']:null;
    // this.rItems = itemMap.containsKey('rItems')?itemMap['rItems']:null;
    this.name = itemMap.containsKey('name')?itemMap['name']:null;
    this.in_bag = itemMap.containsKey('in_bag')?itemMap['in_bag'] != "0":null;
    this.classType = itemMap.containsKey('classType')?itemMap['classType']:null;

  }

  Map<String,dynamic> toMap(){
    return {
      "EPC":this.EPC,
      "classID": this.classID,
      "name":this.name,
      // "classType": this.classType,
      // "className":this.className,
      "image": this.image,
      "rItems":this.rItems.toString(),
      "in_bag": this.in_bag?"1":"0",
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    if(this.name != null)
      return "[Instance of Item:{" +
         " EPC: "+ this.EPC +
         " hasImage: "+ (this.image !=null) .toString() +
         " hasrItems: " + (this.rItems != null).toString() +
         " classType: "+ this.classType +
         " name: " + this.name +
         "}]";
    else
      return "[Instance of Item:{" +
          " EPC: "+ this.EPC +
          " hasImage: "+ (this.image !=null) .toString() +
          " hasrItems: " + (this.rItems != null).toString() +
          " classType: "+ this.classType +
          "}]";
  }
}
