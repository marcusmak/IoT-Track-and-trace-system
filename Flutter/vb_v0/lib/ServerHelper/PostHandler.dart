import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vb_v0/Global_var.dart';
import 'dart:io';

Future<bool> internetConn() async{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}


Future<String> PostHandler(String actionURL,Object bodyArgument) async {
  if(!await internetConn()){
    return null;
  }
  http.Response value = await http.post(SERVER_URL+ actionURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(bodyArgument),
  );
    
  if(value.statusCode == 200){
    print("posthandler body value : " + value.body);
    return value.body;
  }else{
    print(value.statusCode);
    return (value.statusCode).toString();
  }

}