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

    static Future<bool> fetchItems() async{
      if(MyApp.bluetoothDevice !=  null && MyApp.bluetoothDevice.isConnected){
        if(!gattPlatform.checkMethodCallHandler(methodCallHandler)){
          print("Setting gatt method handler");
          gattPlatform.setMethodCallHandler(methodCallHandler);
        }
        await gattPlatform.invokeMethod("fetchItems");
        return true; 
      }else{
        return false;
      }
    }

    static Future<void> methodCallHandler(MethodCall call){
        switch(call.method){
          case 'fetchItemsRes':{
            print("fetchItemsRes1 scanned: " + call.arguments.toString());
            fetchItemsRes(call.arguments);
            break;
          }
          default:
            print('TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
        }

        // return Future<void>;
    }

    static void fetchItemsRes(List<dynamic> arguments){
      // List<String> res = arguments;
      print("Inside the 2 res");
      print("fetchItemsRes2 scanned: " + arguments.first.toString());
      epc2item(arguments);
      
    }

    static Item epc2item(List<dynamic> epc){
      print("EPC2item request to server: "+PostHandler("/epc2item",<String,List<dynamic>>{"EPC":epc}).toString());
      return null;
    }
        
    static Future<void> initItems(void Function() callback) async {
      items = await LocalDataManager.fetchAllItems();
      print("items fetched:" );
      print(items);
      callback();
      // items = <Item> [
      //   Item(
      //     iid: "00000",
      //     name: "Iphone 13 pro",
      //     image: "assets/images/iphone13.jpg"
      //   ),
      //   Item(
      //     iid: "00001",
      //     name: "Airpod 3.0",
      //     image: "assets/images/airpod.jpg"        
      //   ),
      //   Item(
      //     iid: "00000",
      //     name: "Iphone 13 pro",
      //     image: "assets/images/iphone13.jpg"
      //   ),
      //   Item(
      //     iid: "00001",
      //     name: "Airpod 3.0",
      //     image: "assets/images/airpod.jpg"        
      //   ),
      //           Item(
      //     iid: "00000",
      //     name: "Iphone 13 pro",
      //     image: "assets/images/iphone13.jpg"
      //   ),
      //   Item(
      //     iid: "00001",
      //     name: "Airpod 3.0",
      //     image: "assets/images/airpod.jpg"        
      //   ),
      //           Item(
      //     iid: "00000",
      //     name: "Iphone 13 pro",
      //     image: "assets/images/iphone13.jpg"
      //   ),
      //   Item(
      //     iid: "00001",
      //     name: "Airpod 3.0",
      //     image: "assets/images/airpod.jpg"        
      //   )
        
      // ];
      // return;
    }
    
}