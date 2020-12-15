import 'package:meta/meta.dart';
import 'package:vb_v0/ModelClass/ItemContext.dart';
import 'package:flutter/widgets.dart';

class Item {
  //item identification serial
  String iid;
  //name of the item
  String name;
  //related items
  List<Item> rItems;
  //related context
  List<ItemContext> rContexts;
  
  String image;

  Item({@required this.iid, @required this.name, this.rItems, this.rContexts, this.image});
}
