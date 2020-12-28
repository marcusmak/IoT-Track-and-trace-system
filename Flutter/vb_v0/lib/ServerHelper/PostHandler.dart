import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vb_v0/Global_var.dart';

Future<dynamic> PostHandler(String actionURL,Object bodyArgument){
 return http.post(SERVER_URL+ actionURL,
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
    body: jsonEncode(bodyArgument),
  ).then((value){
    if(value.statusCode == 200){
      print(value.body);
      return value.body;
    }else{
      print(value.statusCode);
      return value.statusCode;
    }
  });

}