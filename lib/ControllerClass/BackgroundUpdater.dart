import 'dart:isolate';
class BackgroundUpdater{
  //void checkExist(){
  //   final DateTime now = DateTime.now();
  //   final int isolateId = Isolate.current.hashCode;
  //   // print("");
  //   print("[$now] Check Existence! isolate=${isolateId} function='$checkExist'");
  // }
  void loop() async {
      final DateTime now = DateTime.now();
      final int isolateId = Isolate.current.hashCode;
      print("");
      print("[$now] Looping right now! isolate=${isolateId} function='loop'");
  }

}
