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

Future<List<Map<String,dynamic>>> epc2class(List<dynamic> epc) async{
  // print("EPC to string" + epc.toString());
  String res = await PostHandler("/epc2class",<String,List<dynamic>>{"EPC":epc});
  // print("EPC2item request to server: "+ res);
  print("response : " + res.toString());
  if(res != null){
  List temp = jsonDecode(res);
  List<Map<String,dynamic>> maps = temp.map((e) => e as Map<String,dynamic>).toList();

  print("converted to " + maps.first['className']);
  return maps;
  }else{
  List<Map<String,dynamic>> maps;
  epc.forEach((element) {
  maps.add({'EPC':element as String,'classType':"Other"});
  });
  return maps;
  }
}