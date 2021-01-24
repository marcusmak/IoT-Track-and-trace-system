import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
// import 'package:flutter_picker/flutter_picker.dart';

import 'package:vb_v0/ControllerClass/ItemFetcher.dart';
import 'package:vb_v0/ControllerClass/LocalDataManager.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:vb_v0/HelperComponents/ExpandableCapsuleWidget.dart';
import 'package:vb_v0/ModelClass/ItemContext.dart';

class ListTab extends StatefulWidget{
  void Function(Widget) setBPContent;
  void Function(bool) setBottomPrompt;
  ListTab(this.setBPContent, this.setBottomPrompt);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListTabState(this.setBPContent, this.setBottomPrompt);
    throw UnimplementedError();
  }
  
}

class _ListTabState extends State{
    void Function(Widget) setBPContent;
    void Function(bool) setBottomPrompt;
    bool ready = false;
    _ListTabState(this.setBPContent, this.setBottomPrompt);

    static const TextStyle titleStyle = 
      TextStyle(
                color:Color.fromRGBO(207, 190, 190, 1), 
                fontSize: 25,
                fontWeight: FontWeight.w800
      );
    // const ListTab({Key key, this.style}) : super(key: key);

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ItemFetcher.initItems(()=>setState(()=>ready = true));
  }
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
                child: ItemListContainer(setBPContent,setBottomPrompt,"Digital"),
              ),
              ExpandableCapsuleWidget(
                title: Text("Sport",style: titleStyle,),
                child: ItemListContainer(setBPContent,setBottomPrompt,"Sport"),
              ),
              ExpandableCapsuleWidget(
                title: Text("Work",style: titleStyle,),
                child: ItemListContainer(setBPContent,setBottomPrompt,"Work"),
              ),
              ExpandableCapsuleWidget(
                title: Text("Clothes",style: titleStyle,),
                child: ItemListContainer(setBPContent,setBottomPrompt,"Clothes"),
              ),
              
            ]
          )
        )
      );
    }
}

class ItemListContainer extends StatefulWidget{
  void Function(Widget) setBPContent;
  void Function(bool) setBottomPrompt;
  String classType;

  ItemListContainer(this.setBPContent,this.setBottomPrompt,this.classType,{Key key}):super(key:key);
  
  @override
  State<StatefulWidget> createState() => _ItemListContainerState();
}

class _ItemListContainerState extends State<ItemListContainer>{
  @override
  void initState(){ 
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return tableBuilder();
  }

  Widget tableBuilder(){
    List<TableRow> rows = [];
    int i = 0;
    if(ItemFetcher.items != null){
      ItemFetcher.items.forEach((element) {
        if(element.classType == widget.classType){
          if(i%2 == 0){
            // print(i);
            rows.add(
              TableRow(
                children:[
                  ItemContainer(widget.setBPContent, widget.setBottomPrompt, item: element),
                ]
              )
            );
          }else{
            // print(i);
            rows.last.children.add(ItemContainer(widget.setBPContent, widget.setBottomPrompt, item: element),);
          }
        }

        ++i;
      });


      // to ensure that every row have same number of elements
      if(rows.isNotEmpty && rows.last.children.length %2 != 0){
        rows.last.children.add(Container());
      }

    }
    if(rows.isNotEmpty) {
      return SingleChildScrollView(child: Table(children: rows));
    } else{
      return Text("No items");
    }
  }
}

class ItemContainer extends StatelessWidget {
  final Item item;
  void Function(Widget) setBPContent;
  void Function(bool) setBottomPrompt;
  ItemContainer(this.setBPContent, this.setBottomPrompt,{Key key, this.item}) : super(key: key);
  

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
                              
                              child: item.image!='null' && item.image != null?Image.file(File(item.image) , fit: BoxFit.fill):Center(child:Text("No image")),
                            ),
                            Text(item.name!=null?item.name:item.className,
                                  
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
              this.setBPContent(ReminderView(item,this.setBottomPrompt));   
              print(item.name);
            },
          )
        );

  }
}

class ReminderView extends StatefulWidget {
  Item item;
  void Function(bool) setBottomPrompt;
  ReminderView(this.item,this.setBottomPrompt,{Key key}) : super(key: key);

  @override
  _ReminderViewState createState() => _ReminderViewState();
}


class _ReminderViewState extends State<ReminderView> {
  DateTime targetDate;
  TimeOfDay selectedTime;
  String repeat = "Never";
  List<String> customRepeat = [];
  TextEditingController _dateController = TextEditingController(text: "None");
  TextEditingController _timeController = TextEditingController(text: "None");
  List<Location> leavingLocations = List();
  List<Location> headingLocations = List();
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

    Widget dateTimePicker =   Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                  // padding: EdgeInsets.only(right:MediaQuery.of(context).size.width * 0.05),
                IconButton(
                    icon: Icon(Icons.event), 
                    color: selectedTime != null?Theme.of(context).colorScheme.primary:null,
                    // padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.01),
                    // visualDensity: VisualDensity.comfortable,
                    // alignment: Alignment.centerLeft, 
                    onPressed: (){
                      print("date clicker");
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        confirmText: "Next",
                      ).then(
                        (value) {
                          _dateController.text = value.day.toString() + "/"  + value.month.toString();// + "/" + value.year.toString();
                          setState(()=>targetDate = value);
                        }
                      );
                      // showMaterialResponsiveDialog(
                      //     context: context,
                      //     title: "Start Date",
                      //     child: Center(
                      //         child: Container(
                      //             padding: EdgeInsets.all(0.0),
                      //             child: CalendarDatePicker(
                      //               onDateChanged: (dateTime){print("Date changed");},
                      //               firstDate: DateTime(2000),
                      //               initialDate: DateTime.now(),
                      //               lastDate: DateTime(2100),
                      //             )
                      //         ),
                      //     ),
                      // );
                      // showDialog(
                      //   context: context,
                      //   builder: (context){
                      //     return Scaffold(
                      //       body:CalendarDatePicker(
                      //         firstDate: DateTime(2000),
                      //         initialDate: DateTime.now(),
                      //         lastDate: DateTime(2100),
                      //         onDateChanged: (dateTime){print("Date changed");},
                      //       )
                      //     );
                      //   },

                      // );
                      
                      // showDatePicker(
                      //   context:context,
                      //   builder: (context,child){
                          
                      //     return Container(
                      //         child:  Column(
                      //           children:[
                      //             SizedBox(
                      //               height: MediaQuery.of(context).size.height * 0.5,
                      //               child:FittedBox(
                      //                 child: child,
                      //               ),
                      //             ),
                            
                      //             Text("!23"),
                      //           ],
                      //         )
                      //     );
                      //   },
                      // );
                    
                    }
                  ),
                Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: "Start date",
                        labelStyle: TextStyle(fontSize: 10.75,color: Colors.grey[600]),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      // enableInteractiveSelection: false,
                      style: TextStyle(fontSize: 13,color:Colors.grey[400]),
                      keyboardType: TextInputType.datetime,
                      showCursor: false,
                      // maxLength: 5,
                      enabled: false,
                    )
                ),
                IconButton(
                    icon: Icon(Icons.watch_later_outlined), 
                    color: selectedTime != null?Theme.of(context).colorScheme.primary:null,
                    padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.01),
                    visualDensity: VisualDensity.comfortable,
                    alignment: Alignment.centerLeft, 
                    onPressed: (){
                      print("icon tapped");
                      showTimePicker(
                        cancelText: "Clear",
                        context: context, 
                        initialTime: selectedTime??TimeOfDay.now(),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      ).then((value){
                          if(value != null){
                            setState(() {
                              selectedTime = value;
                            });
                            _timeController.text = value.hour.toString() + ":" + value.minute.toString();
                          }else{
                            _timeController.text = "None";
                            setState((){
                              selectedTime = null;
                            });

                          };

                        }                         
                      );
                    }
                  ),
                Expanded(
                  child:
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: "Time",
                        labelStyle: TextStyle(fontSize: 10.75,color: Colors.grey[600]),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                      // enableInteractiveSelection: false,
                      style: TextStyle(fontSize: 13,color:Colors.grey[400]),
                      keyboardType: TextInputType.datetime,
                      showCursor: false,
                      maxLength: 5,
                      enabled: false,
                    )
                )
          ]
        );
    Widget repeatPicker = Row(
      children:[
        IconButton(
          icon: Icon(Icons.repeat),
          color: repeat != "Never"?Theme.of(context).colorScheme.primary:null,
          onPressed: (){
          showMaterialSelectionPicker(
                            // headerTextColor: Theme.of(context).colorScheme.primary,
                            buttonTextColor: Theme.of(context).colorScheme.primary,
                            context: context,
                            title: "Repeat",
                            items: ["Never","Every day","Every week","Every weekdays","Every month", "Every year","Custom"],
                            onChanged: (value){
                              if(value == "Custom"){
                                showMaterialCheckboxPicker(
                                  buttonTextColor: Theme.of(context).colorScheme.primary,
                                  context: context,
                                  title: "Repeat",
                                  items: ["Every Monday","Every Tuesday","Every Wednesday","Every Thursday", "Every Friday","Every Saturday","Every Sunday"],
                                  selectedItems: customRepeat,
                                  onChanged: (values){
                                    setState(() {
                                      customRepeat = values;
                                    });
                                  }
                                );
                              }
                              setState(()=>repeat = value);
                            },
                            onConfirmed: (){

                              print("confirm");
                            },
                            selectedItem: repeat,

                          );                     
        }
        ),
        Text(repeat,overflow: TextOverflow.ellipsis, style:TextStyle(color: Colors.grey[400]))
      ]
    );
    Widget Function(bool) locationSelector = (bool enter){ 
        String places = ""; 
        if(enter){
          if(headingLocations.length == 0)
            places = "None";
          else
            headingLocations.forEach((element) {places +=  element.toString() + ", ";});
        }else{
          if(leavingLocations.length == 0)
            places = "None";
          else
            leavingLocations.forEach((element) {places +=  element.toString() + ", ";});
        }
        return 
         Row(
           children:[
              IconButton(icon: Icon(
                enter?Icons.time_to_leave:Icons.directions_walk_outlined,
                color: places != "None"?Theme.of(context).colorScheme.primary:null,
                // padding: EdgeInsets.all(0),
                // visualDensity: VisualDensity.compact,
                // alignment: Alignment.centerLeft, 
                // onPressed: ()=>print("icon tapped")
              )
             , onPressed: (){
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
                selectedItems: enter?headingLocations.map((elem)=>elem.name).toList():leavingLocations.map((elem)=>elem.name).toList(),
                onChanged: (value) {
                  if(enter)
                    setState(() => headingLocations = value.map((e) => new Location(name: e)).toList());
                  else
                    setState(() => leavingLocations =  value.map((e) => new Location(name: e)).toList());
                  // print(value.map((e) => new Location(name: e)).toList());
                },
              );
            }),
            Expanded(
              child:Text(places,overflow: TextOverflow.ellipsis,style:TextStyle(color: Colors.grey[400]))
            )
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
                                  SizedBox(child: dateTimePicker,width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.08,)]),
              TableRow(children: [Text("Repeat",style:whiteFont),
                                  SizedBox(child: repeatPicker,width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              TableRow(children: [Text("When I leave",style:whiteFont),
                                  SizedBox(child: locationSelector(false),width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              TableRow(children: [Text("When I'm heading",style:whiteFont),
                                  SizedBox(child: locationSelector(true),width: MediaQuery.of(context).size.width * 0.02,height: MediaQuery.of(context).size.height * 0.075,)]),
              // TableRow(children: [Text("Bring along with",style:whiteFont),Text(DateTime.now().toString())]),
          ],
        ),
        MaterialButton(
          onPressed: () async{
            // DateTime targetDate;
            // TimeOfDay selectedTime;
            // String repeat = "Never";
            // List<String> customRepeat = [];
            // TextEditingController _dateController = TextEditingController(text: "None");
            // TextEditingController _timeController = TextEditingController(text: "None");
            // List<Location> leavingLocations = List();
            // List<Location> headingLocations = List();
            int start_time = targetDate!=null?targetDate.millisecondsSinceEpoch:null;
            if(selectedTime != null){
              start_time += selectedTime.hour * 3600 * 1000;
              start_time += selectedTime.minute * 60 * 1000;
            };
            await LocalDataManager.AddCustomRule(
              ItemContext(
                start_time: start_time,
                frequency: repeat,
                from_loc: leavingLocations.isNotEmpty?leavingLocations.toString():null,
                to_loc: headingLocations.isNotEmpty?headingLocations.toString():null
              ),widget.item
            );
            LocalDataManager.BrosweData("custom_rule");
            widget.setBottomPrompt(false);
            print("confirm");
            
          },
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


const PickerData2 = '''
[
    [
        1,
        2,
        3,
        4
    ],
    [
        11,
        22,
        33,
        44
    ],
    [
        "aaa",
        "bbb",
        "ccc"
    ]
]
    ''';