import 'package:flutter/material.dart';

import 'ControllerClass/ItemFetcher.dart';
import 'main.dart';

class AddItemPage extends StatefulWidget {
  
  
  AddItemPage({Key key}) : super(key: key);

  @override
  
  
  _AddItemPageState createState() => _AddItemPageState();
}



class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){ItemFetcher.fetchItems();},
        backgroundColor: Colors.white60,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("Add items"),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context),),
        
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(
      //     height: 50.0,
      //   ),
      // ),      
      body: Container(),
    );
  }
}