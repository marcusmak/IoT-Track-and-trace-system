import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/HelperComponents/ExpandableCapsuleWidget.dart';


class ListTab extends StatelessWidget{
    static const TextStyle titleStyle = 
      TextStyle(
                color:Color.fromRGBO(207, 190, 190, 1), 
                fontSize: 25,
                fontWeight: FontWeight.w800
      );
    // const ListTab({Key key, this.style}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      // print(style);
      return Expanded(
        child: SingleChildScrollView(
        physics:  BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child:
          Column(
            children: <Widget>[
              ExpandableCapsuleWidget(
                title: Text("Digital",style: titleStyle,),
                child: ItemListContainer(),
              ),
              ExpandableCapsuleWidget(
                title: Text("Sport",style: titleStyle,),
                child: ItemListContainer(),
              ),
              ExpandableCapsuleWidget(
                title: Text("Work",style: titleStyle,),
                child: ItemListContainer(),
              ),
              ExpandableCapsuleWidget(
                title: Text("Clothes",style: titleStyle,),
                child: ItemListContainer(),
              ),
              
            ]
          )
        )
      );
    }
}

class ItemListContainer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ItemListContainerState();
}

class _ItemListContainerState extends State<ItemListContainer>{
  ItemFetcher itemFetcher = ItemFetcher();
  @override
  void initState() { 
    super.initState();
    itemFetcher.initItems();
  }
  
  @override
  Widget build(BuildContext context) {
    return tableBuilder();
  }

  Widget tableBuilder(){
    List<TableRow> rows = [];
    int i = 0;
    this.itemFetcher.items.forEach((element) {
      if(i%2 == 0){
        // print(i);
        rows.add(
          TableRow(
            children:[
              ItemContainer(item: element),
            ]
          )
        );
      }else{
        // print(i);
        rows.last.children.add(ItemContainer(item: element),);
      }
      ++i;
    });
    return SingleChildScrollView(
        child:
          Table(children: rows)
        );
  }
}

class ItemContainer extends StatelessWidget {
  final Item item;
  const ItemContainer({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
         horizontal:MediaQuery.of(context).size.width * 0.025 
        ,vertical:MediaQuery.of(context).size.height * 0.05
      ),
      child: 
        Container(
          
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
                color: Colors.white70
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromRGBO(89,56,33,1),
                //     Color.fromRGBO(89,56,33,1),
                //   ],
                // )
              ),
            child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                        SizedBox(
                          height:MediaQuery.of(context).size.height * 0.15 ,
                          width:MediaQuery.of(context).size.width * 0.5,
                          
                          child: Image.asset(item.image, fit: BoxFit.fill),
                        ),
                        Text(item.name,
                              
                            style: TextStyle(
                                      color:Color.fromRGBO( 75, 75, 75, 1), 
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800
                            )
                        )
                        
                      ]
                  ),
          ),
          height:MediaQuery.of(context).size.height * 0.3 ,
          // width:MediaQuery.of(context).size.width * 0.01
        ),
      );

  }
}