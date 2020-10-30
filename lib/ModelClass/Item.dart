import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

class Item {
  //item identification serial
  String iid;
  //name of the item
  String name;
  //related items
  List<Item> rItems;
  //related context
  List<Context> rContexts;
  
  String image;

  Item({@required this.iid, @required this.name, this.rItems, this.rContexts, this.image});
}

//temp class will be removed later
class Context {

}