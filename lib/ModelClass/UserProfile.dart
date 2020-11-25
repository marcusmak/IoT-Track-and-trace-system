import 'dart:convert';

import 'package:flutter/widgets.dart';
class UserProfile {
  String userName;
  String email;
  String password;
  int sex;
  int age;
  List<String> interests;
  Map<String,String> locations;
  Image profilePic;

  UserProfile(){
    this.interests = new List();
    this.locations = new Map();
  }
  
  String toJSON(){
    return jsonEncode(<String, String>{
        'username': this.userName,
        'password': this.password,
        'email': this.email,
        'sex': this.sex.toString(),
        'age': this.age.toString(),
        'occupation': 'null',
        'area': 'null',
        'inter': 'null',

      });
  }

  @override
  String toString() {
    // TODO: implement toString
    // print();
    return toJSON();
    // return super.toString();
  }
}