import 'package:meta/meta.dart';
import 'package:vb_v0/ModelClass/ItemContext.dart';
import 'package:flutter/widgets.dart';

class Item {
  //item identification serial
  String iid;
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

  bool in_bag;

  Item({@required this.iid, @required this.name, this.rItems, this.classID, this.className, this.image /*this.rContexts,*/});

  Item.fromMap(Map<String,dynamic> itemMap){
    this.iid = itemMap['iid'];
    this.classID = itemMap['classID'];
     this.className = itemMap['className'];
    //todo: incomplete and would cause error
    this.image = itemMap['image'];
    this.rItems = itemMap['rItems'];
    this.name = itemMap['name'];
    this.in_bag = itemMap['in_bag'] != "0";
    this.classType = itemMap['classType'];

  }

  @override
  String toString() {
    // TODO: implement toString
    return "[Instance of Item:{" +
       " iid: "+ this.iid + 
       " hasImage: "+ (this.image !=null) .toString() + 
       " hasrItems: " + (this.rItems != null).toString() +
       " classType: "+ this.iid + 
       
      
       "}]";
  }
}
