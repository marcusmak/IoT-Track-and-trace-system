import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ControllerClass/PackingListHandler.dart';
// import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/HelperComponents/ExpandableCapsuleWidget.dart';

const TextStyle titleStyle = 
      TextStyle(
                color:Color.fromRGBO(207, 190, 190, 1), 
                fontSize: 25,
                fontWeight: FontWeight.w800
      );
class PackingTab extends StatefulWidget {
  PackingListHandler packingListHandler = new PackingListHandler();

  PackingTab({Key key}) : super(key: key);

  @override
  _PackingTabState createState() => _PackingTabState();
}

class _PackingTabState extends State<PackingTab> {
  String trip_type = "short";
  bool live_updating = false;
  @override
  Widget build(BuildContext context) {
      // print(style);
      // List<Widget> _child = ;
      return 
      Expanded(child: 
        Stack(
          children:[
            SingleChildScrollView(
              physics:  BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child:
                Column(
                  children: <Widget>[
                    headerExpandable(context),
                    PackingListWidget(trip_type,widget.packingListHandler),
                  ],
                )
            ),

            Positioned(
              bottom: 15,
              right: 15,
              child: 
                FloatingActionButton(
                  onPressed: (){
                    setState(() {
                      live_updating = !live_updating;
                      if(live_updating){
                        widget.packingListHandler.startUpdate(setState);
                      }else{
                        widget.packingListHandler.stopUpdate();
                      }
                    });
                    print("live_updating");
                  },
                  backgroundColor: live_updating?Colors.blueGrey.shade400:Colors.white60,
                  child: 
                  Icon(Icons.refresh),
              ),
            ),
        ])
      );
    }

    Widget headerExpandable(BuildContext _context){
        return Container(
        child: 
          Padding(
            padding: EdgeInsets.symmetric(
              vertical:   MediaQuery.of(_context).size.height * 0.025,
              horizontal: MediaQuery.of(_context).size.width * 0.05
            ),
            child: Material(
              color: Colors.transparent,
              shadowColor: Colors.white24,
              elevation: 20,
              child:Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0)
                ),
                color: Color.fromARGB(255, 30, 30, 30),
                border: Border.all(color:Colors.white),

              ),
              child:
              Theme(
                data : ThemeData(
                  accentColor: Colors.white, 
                  unselectedWidgetColor: Colors.white, 
                  selectedRowColor: Colors.transparent,
                  indicatorColor: Colors.transparent
                ), 
                child: ExpansionTile(
                  // leading: Icon(Icons.arrow_downward),
                  // backgroundColor: Colors.black,
                  
                  title: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(_context).size.width * 0.01,
                      vertical:   MediaQuery.of(_context).size.width * 0.025,
                    ),
                    child: Text("Trip Detail", style: 
                      TextStyle(
                        color:Color.fromRGBO(207, 190, 190, 1), 
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  initiallyExpanded: true,
                  onExpansionChanged: (bool _isExpanded){
                    print(_isExpanded);
                  },
                  children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20
                        ),
                        child: 
                          // StatefulBuilder(
                          //   builder: (BuildContext context, setState) {
                             
                          //     return
                              
                            Row(
                                mainAxisAlignment:  MainAxisAlignment.center,
                                children: [
                                  Text("Short"),
                                  Switch(value: trip_type == "long", onChanged: (value){
                                    // if(value)
                                      setState(() => changeTripType(value?"long":"short"));
                                    
                                  }),               
                                  Text("Long "),    
                                ],
                              )
                          //   },
                          // ),
                      )// Text("trip detail")
                    ],
                ),
              ),
            )
          )
          )
          
        
        // Text(this.title),
      );
    }

    void changeTripType(String tripType){
      this.trip_type = tripType;
      widget.packingListHandler.changeTripType(tripType);
    }
}



class PackingListWidget extends StatefulWidget {
  String trip_type;
  PackingListHandler packingListHandler;
  PackingListWidget(this.trip_type,this.packingListHandler,{Key key}) : super(key: key);

  @override
  _PackingListWidgetState createState() => _PackingListWidgetState();
}

class _PackingListWidgetState extends State<PackingListWidget> {
  
  HashMap<ItemCategory,List<PackingItem>> packingLists = HashMap();
  HashMap<PackingItem,bool> toggleStatus = HashMap<PackingItem,bool>();
  int test = 0;
  
  // _PackingListWidgetState(){
  //   packingLists = HashMap();
  //   // print("here");
  //   packingListHandler = new PackingListHandler();
  //   packingListHandler.packingItemList.forEach((element) {
  //     if(packingLists.containsKey(element.itemCategory)){
  //       packingLists[element.itemCategory].add(element);
  //     }else{
  //       List temp = new List<PackingItem>();
  //       temp.add(element);
  //       packingLists[element.itemCategory] = temp;
  //     }
  //   });
  // }

  void categoriseItems(){
    packingLists.clear();
    toggleStatus.clear();
    widget.packingListHandler.packingItemMap.entries.forEach((element) {
      if(packingLists.containsKey(element.value.itemCategory)){
        packingLists[element.value.itemCategory].add(element.value);
      }else{
        List temp = new List<PackingItem>();
        temp.add(element.value);
        packingLists[element.value.itemCategory] = temp;
      }
      toggleStatus[element.value] = false;
    });
  }

  List<Widget> generateCapsules(BuildContext context){
    List<Widget> _children = new List();
    const TextStyle contextTs = TextStyle(color: Color.fromARGB(255, 200 , 200, 200), fontSize: 16);
    packingLists.forEach((key, value) {
      _children.add(
        ExpandableCapsuleWidget(
          title: Text(key.toString().split(".")[1],style: titleStyle,),
          child:
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03
                    
              ),
              child: Column(
                children: value.map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.width * 0.01  ,
                    ),
                    child:Container(
                      padding: EdgeInsets.symmetric(
                        // horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.width * 0.01  ,
                      ),
                      decoration:
                        BoxDecoration(
                          // color: Colors.amber,
                          border: BorderDirectional(bottom:BorderSide(
                            color: Colors.white,
                            // width: 1
                          ))
                        )
                      ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children:[
                              // GestureDetector(
                              //   onTap: (){
                              //     setState(() {
                              //       print(toggleStatus.containsKey(e));
                              //       toggleStatus.update(e, (value){return !value;} , ifAbsent: (){ print('abs'); return false;});
                              //     });
                              //     // print(toggleStatus[e]);
                              //   },
                              //   child: toggleStatus[e]?Icon(Icons.check_circle,size: 30.0,):Icon(Icons.check_circle_outline,size: 30.0,)
                              // ),
                              e.currentNum==e.requiredNum?Icon(Icons.check_circle,size: 30.0,):Icon(Icons.check_circle_outline,size:30.0,),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * 0.05
                                ),
                                child: Text(e.name, style: contextTs,)
                              )
                            ]
                          ) , Text("${e.currentNum}/${e.requiredNum}", style:contextTs)
                            
                        ],
                      ),
                    )
                  )
                ).toList()
              )
            )
        ),
      );
    });
    return _children;
  }

  @override
  Widget build(BuildContext context) {
    print("Building packinglist for " + widget.trip_type + " trip.");
    categoriseItems();
    List<Widget> _result = generateCapsules(context);
    return 
    // Text("123");
    Column(
       children:_result,
    );
  }
}