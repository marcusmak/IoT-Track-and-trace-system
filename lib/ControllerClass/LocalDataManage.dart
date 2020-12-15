import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vb_v0/ModelClass/ItemContext.dart';
import 'package:vb_v0/ModelClass/Item.dart';
import 'package:flutter/widgets.dart'; //required.

Database database;

void InitialiseDatabase() async{
  
  // Open the database and store the reference.
  var dbPath = join(await getDatabasesPath(), 'localDB.db');
  if (!File(dbPath).existsSync()){
    ByteData data = await rootBundle.load("assets/localDB.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    print("Copy database structure");
  }
  database = await openDatabase(dbPath);
  List<Map<String, dynamic>> results = await database.rawQuery('PRAGMA table_info(custom_rule);');
  print(results);



  // final Future<Database> database = openDatabase(
  //   join(await getDatabasesPath(), 'local_database.db'),
  //   version: 1,
  //   onCreate: (db, version) {
  //     print("Create database");
  //     // return db.execute(
  //     //   "CREATE TABLE custom_rule("
  //     // );
  //   },
  //   onOpen: (db){
  //     print("Open database");
  //   }
  // );
}

void DeleteDatabase() async{
  WidgetsFlutterBinding.ensureInitialized();
  print("Delete databse");
  await deleteDatabase(join(await getDatabasesPath(), 'localDB.db'));
}

void AddCustomRule(ItemContext context, Item item) async{
  var dbPath = join(await getDatabasesPath(), 'localDB.db');
  print(dbPath);
  print("add custom rule ");
  var values = context.toMap();
  values.putIfAbsent("item_id", () => item.iid);
  print(values);
  await database.insert('custom_rule', values);
}

void BrosweData(String table) async{
  print(await database.query(table));
}