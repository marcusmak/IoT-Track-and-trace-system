import 'dart:isolate';
import 'package:android_alarm_manager/android_alarm_manager.dart';

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

class BackgroundUpdate{
  static int FixTimeId = 0;
  static void checkExist(){
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    // print("");
    print("[$now] Check Existence! isolate=${isolateId} function='$checkExist'");
  }

  static void main() async {
    // await AndroidAlarmManager.oneShotAt(DateTime(2020,12,1,13,10), FixTimeId, checkExist);
    //periodic(const Duration(minutes: 1), helloAlarmID, printHello);
  }

}
