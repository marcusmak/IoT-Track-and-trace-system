import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vb_v0/ControllerClass/ItemScanner.dart';

import 'ControllerClass/ItemFetcher.dart';
import 'ModelClass/Item.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class AddItemPage extends StatefulWidget {
  final Map<String,dynamic> args;
  Item item;
  Function(Item) setItemCallBack;

  AddItemPage(this.args,{Key key}) : super(key: key){
    this.item = this.args['item'];
    this.setItemCallBack = this.args['setItemCallback'];
    print("in add page with Item1: " +  item.toString());
  }

  @override
  
  
  _AddItemPageState createState() => _AddItemPageState();
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);


class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();

  String _itemName;
  String _imagePath;
  bool editMode = false;
  String _image;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    setState(() {
      _image = widget.item.image != null? widget.item.image:null;
      if(widget.item.name != null){
        _itemName = widget.item.name;
        _nameTextController.text = widget.item.name;
      }else{
        _itemName =  "Unnamed";
      };
    });

  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
        _image = base64Encode(File(pickedFile.path).readAsBytesSync());
        print("set image file");
      } else {
        print('No image selected.');
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // ItemScanner.scanTags();
          print("Edit Details");

          setState(() {
            if(editMode){
             if(_nameTextController.text != null && _nameTextController.text.isNotEmpty){
               _itemName = _nameTextController.text;
               widget.item.name = _itemName;
             };
             if(_imagePath != null){
               widget.item.image = base64Encode(File(_imagePath).readAsBytesSync());
             }


            }
            editMode = !editMode;
          });
        },
        backgroundColor: Colors.white60,
        child: editMode?Icon(Icons.done_outline_rounded):Icon(Icons.edit_outlined),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("Item Details"),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.pop(context);
            widget.setItemCallBack(widget.item);
          },),

          ),
          // bottomNavigationBar: BottomAppBar(
          //   shape: const CircularNotchedRectangle(),
          //   child: Container(
          //     height: 50.0,
          //   ),
          // ),
          body: Form(
          key: _formKey,
          child:Container(
          padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width*0.1,
          vertical: MediaQuery.of(context).size.height*0.01
          ),
          child:Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
          TableRow(
          children: [
          Text("Unique Serial:"),
          Text(widget.item.EPC),
          ]
          ),
          TableRow(
          children: [
                  Text("Field:"),
                  Text(widget.item.classType),
                ]
            ),
            TableRow(
              children:[
                Text("Type:"),
                Text(widget.item.className)
              ]
            ),
            TableRow(
              children:[
                Text("Name:"),
                editMode?TextFormField(
                  controller: _nameTextController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText:"Item Name",
                  ),
                ):Text(_itemName)
              ]
            ),
            TableRow(
                children:[
                  Text("Image:"),
                  editMode?IconButton(
                    onPressed: ()async{
                      print("take picture");
                      await getImage();
                      // _onImageButtonPressed(ImageSource.gallery, context: context);
                    },
                    icon: Icon(Icons.camera_alt_outlined),
                  ):(_image == null && widget.item.image == null
                      ? Text('No image')
                      : Image.memory(base64Decode(_image)))

                  // Text(widget.item.name!= null?widget.item.name:"No image")
                ]
            )




          ],
        )

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text("Unique Serial:\t" + widget.item.EPC),
        //     Text("Field:\t" + widget.item.classType),
        //     Text("Type:\t" + widget.item.className),
        //     Text("Name:\t" + (widget.item.name != null?widget.item.name:"Unnamed")),
        //     // Text("image:" + (widget.item.image != null?widget.item.image.toString():"null")),
        //   ],
        // )
      ),
      )
    );
  }
}