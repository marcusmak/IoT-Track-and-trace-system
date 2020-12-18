import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:vb_v0/ModelClass/Item.dart';
class PackingListHandler{
  List<PackingItem> packingItemList;

  PackingListHandler(){
    //todo: remove the following placeholding packing list
    packingItemList = new List<PackingItem>();
    packingItemList.addAll(
      <PackingItem>[
        PackingItem(name:"Shirts",requiredNum: 6, itemCategory: ItemCategory.Clothes ),
        PackingItem(name:"Shoes",requiredNum: 3, itemCategory: ItemCategory.Clothes ),
        PackingItem(name:"Underwear",requiredNum: 6, itemCategory: ItemCategory.Clothes ),
        PackingItem(name:"Throusers",requiredNum: 4, itemCategory: ItemCategory.Clothes ),  
        PackingItem(name:"Socks",requiredNum: 6, itemCategory: ItemCategory.Clothes ),

        PackingItem(name:"Contacts",requiredNum: 3, itemCategory: ItemCategory.Toiletries ),
        PackingItem(name:"Electric Shaver",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
        PackingItem(name:"Hair brush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),  
        PackingItem(name:"Toothbrush",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),  
        PackingItem(name:"Shamboo",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
        PackingItem(name:"Hair Conditioner",requiredNum: 1, itemCategory: ItemCategory.Toiletries ),
        

      ]
    );

  }

  void addItemEntry(PackingItem newPackingEntry){
    if(newPackingEntry != null){
      packingItemList.add(newPackingEntry);
      return;
    }
  }

  void removeItemEntry(PackingItem packingEntry){
    if(packingEntry != null){
      packingItemList.remove(packingEntry);
      return;
    }
  }

  void addItemEntries(List<PackingItem> newPackingEntries){
    if(newPackingEntries != null){
      packingItemList.addAll(newPackingEntries);
      return;
    }
  }

  void removeItemEntries(List<PackingItem> packingEntries){
    if(packingEntries != null){
      packingEntries.forEach((element) {
          packingItemList.remove(element);
        }
      );
    }
  }

}

enum ItemCategory {
  Clothes,
  Toiletries,
  //todo: add more cat
}
class PackingItem {
  int requiredNum;
  int currentNum;
  String name;
  List<Item> itemList;
  ItemCategory itemCategory;

  PackingItem({@required this.name, this.currentNum = 0,@required this.requiredNum, @required this.itemCategory});
  
  void putItem(int _num,{List<Item> items}){
    if(_num < 0)
      return;
    currentNum += _num;
    if(items != null)
      itemList.addAll(items);
  }


  void takeAwayItem(int _num,{List<Item> items}){
    if(_num < 0)
      return;

    if(items != null){
      if(items.length != _num)
        return;
      
      items.forEach((element){ itemList.remove(element);});
    }

    if(_num > currentNum)
      currentNum = 0;
    else
      currentNum -= _num;
    
  }


}