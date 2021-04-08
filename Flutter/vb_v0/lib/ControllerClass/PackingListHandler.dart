import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:vb_v0/ControllerClass/BluetoothDevice.dart';
import 'package:vb_v0/ControllerClass/ItemScanner.dart';
import 'package:vb_v0/ControllerClass/LocalDataManager.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/main.dart';

import 'ItemFetcher.dart';
class PackingListHandler{
  Map<String,PackingItem> packingItemMap;
  // Set<Item> itemSet = new Set();

  void initialisePIM(){
    packingItemMap = {
      "Shirts":PackingItem(name:"Shirts",requiredNum: 2, itemCategory: ItemCategory.Clothes ),
      "Shoes" :PackingItem(name:"Shoes",requiredNum: 1, itemCategory: ItemCategory.Clothes ),
      "Electric Shaver": PackingItem(name:"Electric Shaver",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      "Hair brush": PackingItem(name:"Hair brush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      "Toothbrush": PackingItem(name:"Toothbrush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      "Shampoo": PackingItem(name:"Shampoo",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      "Hair Conditioner": PackingItem(name:"Hair Conditioner",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      "Trousers": PackingItem(name:"Trousers",requiredNum: 2, itemCategory: ItemCategory.Clothes ),
      "Tablet": PackingItem(name:"Tablet",requiredNum: 1, itemCategory: ItemCategory.Digital ),
    };
  }
  void resetPIM(){
    packingItemMap.forEach((key, value)=>value.clear());
  }

  PackingListHandler(){
    //todo: remove the following placeholding packing list
    // _itemScanner = new ItemScanner((list){
    //   print("itemscanner in packing list handler");
    //   Set<Item> newSet = new Set();
    //   list.forEach((element) {
    //     newSet.add(Item.fromMap(element));
    //   });
    //   Set<Item> newItems = newSet;
    //   newItems.removeAll(itemSet);
    //   itemSet.removeAll(newSet);
    //
    //   // packingItemMap.updateAll((key, value) => value.cl)
    //   updateFunction(() {
    //     addItems(newItems.toList());
    //     removeItems(itemSet.toList());
    //   });
    //
    //   itemSet = newItems;
    //
    //   print(list.map((e) => Item.fromMap(e)).toString());
    //
    // });
    initialisePIM();
    // packingItemMap.;
      // <PackingItem>[
      //   PackingItem(name:"Shirts",requiredNum: 2, itemCategory: ItemCategory.Clothes ),
      //   PackingItem(name:"Shoes",requiredNum: 3, itemCategory: ItemCategory.Clothes ),
      //   // PackingItem(name:"Underwear",requiredNum: 6, itemCategory: ItemCategory.Clothes ),
      //   // PackingItem(name:"Trousers",requiredNum: 4, itemCategory: ItemCategory.Clothes ),
      //   // PackingItem(name:"Socks",requiredNum: 6, itemCategory: ItemCategory.Clothes ),
      //
      //   // PackingItem(name:"Contacts",requiredNum: 3, itemCategory: ItemCategory.Toiletries ),
      //   PackingItem(name:"Electric Shaver",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      //   // PackingItem(name:"Hair brush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      //   // PackingItem(name:"Toothbrush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      //   // PackingItem(name:"Shamboo",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      //   // PackingItem(name:"Hair Conditioner",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
      //
      //
      // ]


  }

  changeTripType(String tripType){
    if(tripType == "long"){
      packingItemMap["Shirts"].requiredNum = 5;
      packingItemMap["Shoes"].requiredNum = 2;
      packingItemMap["Trousers"].requiredNum = 5;
    }else{
      packingItemMap["Shirts"].requiredNum = 2;
      packingItemMap["Shoes"].requiredNum = 1;
      packingItemMap["Trousers"].requiredNum = 2;
    }
  }

  void addItemEntry(PackingItem newPackingEntry){
    if(newPackingEntry != null){
      packingItemMap[newPackingEntry.name] = newPackingEntry;
      return;
    }
  }

  void removeItemEntry(PackingItem packingEntry){
    if(packingEntry != null){
      packingItemMap.removeWhere((key, value) => value == packingEntry);
      // remove(packingEntry);
      return;
    }
  }

  void addItemEntries(List<PackingItem> newPackingEntries){
    if(newPackingEntries != null){
      newPackingEntries.forEach((element) {
        addItemEntry(element);
      });
      return;
    }
  }

  void removeItemEntries(List<PackingItem> packingEntries){
    if(packingEntries != null){
      packingEntries.forEach((element) {
          removeItemEntry(element);
        }
      );
    }
  }

  void addItems(List<Item> itemList){

    itemList.forEach((element) {
      print(element.className);
      if(packingItemMap.containsKey(element.className)){
        addItem(element);
      }
    });

    // for (var packingItem in packingItemList) {
    //   if(packingItem.name == name){
    //     packingItem.putItem(itemList.length,items: itemList);
    //   }
    // }
  }

  void removeItems(List<Item> itemList){
    itemList.forEach((element) {
      print(element.className);
      if(packingItemMap.containsKey(element.className)){
        removeItem(element);
      }
    });

  }

  void addItem(Item item){
    packingItemMap[item.className].putItem(item);
  }

  void removeItem(Item item){
    packingItemMap[item.className].takeAwayItem(item);
  }

  ItemScanner _itemScanner;
  bool live_updating = false;
  void scanItem(){
    if(live_updating) {
      // _itemScanner.scanTags();
      LocalDataManager.fetchAllInBagItems().then((list){
        visualiseItems(list);
      });
      Future.delayed((Duration(milliseconds: 1000)), () => scanItem());
    }
  }

  void visualiseItems(List<Item> itemList){
    resetPIM();
    updateFunction(
        ()=>addItems(itemList)
    );
  }

  void Function(void Function()) updateFunction;
  void startUpdate(void Function(void Function()) updateFunction) async{
    // if(MyApp.bluetoothDevice == null || MyApp.bluetoothDevice.isConnected){
    //   MyApp.bluetoothDevice = await BluetoothDevice.connectLastSession();
    // }
    // if(MyApp.bluetoothDevice == null)
    //   return;
    this.updateFunction = updateFunction;
    live_updating = true;
    scanItem();
  }

  void stopUpdate(){
    live_updating = false;
  }


}

enum ItemCategory {
  Clothes,
  Toiletries,
  Digital,
  //todo: add more cat
}
class PackingItem {
  int requiredNum;
  int currentNum;
  String name;
  Map<String,Item> itemList = new Map();
  ItemCategory itemCategory;

  PackingItem({@required this.name, this.currentNum = 0,@required this.requiredNum, @required this.itemCategory});
  
  // void putItems(int _num,{List<Item> items}){
  //   if(_num < 0)
  //     return;
  //   currentNum += _num;
  //   if(items != null)
  //     itemList.addAll(items);
  // }
  void putItem(Item item){
    if(item == null)
      return;
    if(!itemList.containsKey(item.EPC)) {
      print("add Items");
      currentNum++;
      itemList[item.EPC] = item;
    }
  }

  void takeAwayItem(Item item){
    if(item == null)
      return;
    if(itemList.containsKey(item.EPC)) {
      print("remove Item");
      currentNum--;
      itemList.remove(item.EPC);
    }
  }

  void clear(){
    itemList.clear();
    currentNum = 0;
  }

  //
  //
  // void takeAwayItem(int _num,{List<Item> items}){
  //   if(_num < 0)
  //     return;
  //
  //   if(items != null){
  //     if(items.length != _num)
  //       return;
  //
  //     items.forEach((element){ itemList.remove(element);});
  //   }
  //
  //   if(_num > currentNum)
  //     currentNum = 0;
  //   else
  //     currentNum -= _num;
  //
  // }


}