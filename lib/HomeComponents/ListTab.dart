import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
// import 'package:flutter_picker/flutter_picker.dart';

import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/HelperComponents/ExpandableCapsuleWidget.dart';
import 'package:vb_v0/ModelClass/Context.dart';

class ListTab extends StatelessWidget{
    void Function(Widget) setBPContent;
    ListTab(this.setBPContent);

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
                child: ItemListContainer(setBPContent),
              ),
              ExpandableCapsuleWidget(
                title: Text("Sport",style: titleStyle,),
                child: ItemListContainer(setBPContent),
              ),
              ExpandableCapsuleWidget(
                title: Text("Work",style: titleStyle,),
                child: ItemListContainer(setBPContent),
              ),
              ExpandableCapsuleWidget(
                title: Text("Clothes",style: titleStyle,),
                child: ItemListContainer(setBPContent),
              ),
              
            ]
          )
        )
      );
    }
}

class ItemListContainer extends StatefulWidget{
  void Function(Widget) setBPContent;
  ItemListContainer(this.setBPContent,{Key key}):super(key:key);

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
              ItemContainer(widget.setBPContent, item: element),
            ]
          )
        );
      }else{
        // print(i);
        rows.last.children.add(ItemContainer(widget.setBPContent, item: element),);
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
  void Function(Widget) setBPContent;
  
  ItemContainer(this.setBPContent,{Key key, this.item}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
         horizontal:MediaQuery.of(context).size.width * 0.025 
        ,vertical:MediaQuery.of(context).size.height * 0.05
      ),
      child: 
        GestureDetector(
          child:
            Container(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
                    color: Colors.white70

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
            onTap: (){
              this.setBPContent(ReminderView(item));   
              print(item.name);
            },
          )
        );

  }
}

class ReminderView extends StatefulWidget {
  Item item;
  ReminderView(this.item,{Key key}) : super(key: key);

  @override
  _ReminderViewState createState() => _ReminderViewState();
}


class _ReminderViewState extends State<ReminderView> {
  DateTime targetTime;
  List<Location> leavingLocations = List();
  List<Location> enteringLocations = List();
  final TextStyle whiteFont = TextStyle(color: Colors.white);
  Widget reminderView(BuildContext context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Center(
            child:Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[Text("Reminds me to bring ",style:TextStyle(color:Colors.white38)),Text(widget.item.name, style:TextStyle(color: Colors.white, fontWeight: FontWeight.w900))]
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.022
                ),
            child: conditionView(context),
          
          )
          
        ]
      );
    }

  Widget conditionView(BuildContext context){

    Widget dateTimePicker = //Text("datetimepicker");
      Theme(
        data: new ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
          ),
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey,
          accentColor: Colors.grey,
          hintColor: Colors.grey
        ),
        child:DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              // decoration: ,
              dateMask: 'd MMM',
              cursorWidth: 10,
              strutStyle: StrutStyle(fontSize: 10.0,fontFamily: 'OpenSans',forceStrutHeight: true,),
              style:TextStyle(color:Colors.white, fontSize: 10),
              timeFieldWidth: MediaQuery.of(context).size.width*0.2,
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event,color: Colors.grey,),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              // selectableDayPredicate: (date) {
              //   // // Disable weekend days to select from the calendar
              //   // if (date.weekday == 6 || date.weekday == 7) {
              //   //   return false;
              //   // }

              //   // return true;
              // },
              onChanged: (val) => print("chagned:" + val),
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print("saved:" + val),
            )
        );
  
    Widget Function(bool) locationSelector = (bool enter){ 
        String places = ""; 
        if(enter){
          if(enteringLocations.length == 0)
            places = "None";
          else
            enteringLocations.forEach((element) {places +=  element.toString() + ", ";});
        }else{
          if(leavingLocations.length == 0)
            places = "None";
          else
            leavingLocations.forEach((element) {places +=  element.toString() + ", ";});
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.pin_drop), 
              color: Colors.grey[500],
              padding: EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              alignment: Alignment.centerLeft, 
              onPressed: ()=>print("icon tapped")
            ),
            GestureDetector(onTap: (){
              print("locationSelector ontapped");
              List<String> locations = <String>[
                'Home',
                'Workplace',
                'Gym room',
                'Coffee Shop',
              ];

              showMaterialCheckboxPicker(
                context: context,
                title: "Locations",
                items: locations,
                selectedItems: enter?enteringLocations.map((elem)=>elem.name).toList():leavingLocations.map((elem)=>elem.name).toList(),
                onChanged: (value) {
                  if(enter)
                    setState(() => enteringLocations = value.map((e) => new Location(name: e)).toList());
                  else
                    setState(() => leavingLocations =  value.map((e) => new Location(name: e)).toList());
                  // print(value.map((e) => new Location(name: e)).toList());
                },
              );
            }
            , child: Expanded(
              child:Text(places,overflow: TextOverflow.ellipsis,)
            )
            ,)

          ]
        );
    };

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <TableRow>[
              TableRow(children: [Text("Time",style:whiteFont),
                                  SizedBox(child: dateTimePicker,width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              TableRow(children: [Text("When I leave",style:whiteFont),
                                  SizedBox(child: locationSelector(false),width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              TableRow(children: [Text("When I'm heading",style:whiteFont),
                                  SizedBox(child: locationSelector(true),width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              // TableRow(children: [Text("Bring along with",style:whiteFont),Text(DateTime.now().toString())]),
          ],
        ),
        MaterialButton(
          onPressed: ()=>print("confirm"),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005,
              horizontal: MediaQuery.of(context).size.width * 0.02
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color:Color.fromRGBO(225, 222, 210, 1)),
              // color: Colors.white70
            ),
            child:Text("confirm")
          ),
        )
      ],

    );
    // );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
       child: reminderView(context),
    );
  }
}