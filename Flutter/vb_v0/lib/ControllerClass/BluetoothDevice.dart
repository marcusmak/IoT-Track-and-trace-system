import 'package:flutter/services.dart';
import 'package:vb_v0/Global_var.dart';
import 'package:vb_v0/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothDevice{
  String mName;
  String mAddress;
  bool isConnected = false;

  BluetoothDevice(this.mName,this.mAddress);
  
  Future<bool> connect() async {
    try {
      if(await blePlatform.invokeMethod("bleConnect",{"mName":this.mName,"mAddress":this.mAddress})){
          isConnected = true;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("lastBLE", mAddress);    
          await prefs.setString("lastBLEName", mName);
          return true;
      };
    } on PlatformException catch (e) {
      isConnected = false;
      print("Failed to Invoke: '${e.message}'.");
    }

    return false;
  }

  Future<bool> disconnect() async {
    try {
      if(await blePlatform.invokeMethod('bleDisconnect',{"mAddress":this.mAddress})){
        isConnected = false;
        return true;
      }
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
    }
    return false;
  }

  // Future<String> fetchCharValue() async{
  //   try {
  //     if(await gattPlatform.invokeMethod("fetchCharValue")){
  //       return "true";
  //     }
  //   } on PlatformException catch (e) {
  //     print("Failed to Invoke: '${e.message}'.");
  //   }
  //   return "false";
    
  // }

  static void scan() async{
    try {
      print("scanning ble");
      final bool result = await  blePlatform.invokeMethod('bleScan');
      // response = result;
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
      // _isScanning = false;
    }
  }
}



class BleDevicesDialog extends StatefulWidget {
  BuildContext context;
  BleDevicesDialog(this.context,{Key key}) : super(key: key);
  @override
  _BleDevicesDialogState createState() => _BleDevicesDialogState();
}



class _BleDevicesDialogState extends State<BleDevicesDialog> {
  // static const platform = const MethodChannel(BLE_CHANNEL);
  List<Map> devices = List();

  List<Widget> listOfItems(List<Map> devices){
    List<Widget> results = new List();
    // if
    devices.forEach((element) {
      results.add(
        SimpleDialogItem( 
          text:element['mName'],
          onPressed: () async{
            MyApp.bluetoothDevice = BluetoothDevice(element['mName'],element['mAddress']);
            if(!(await MyApp.bluetoothDevice.connect()))
              MyApp.bluetoothDevice = null;
            else{
              Navigator.pop(widget.context);
            }
          },
        )
      );
    });
    return results;    
  }

  @override
  void initState() {
    super.initState();
    BluetoothDevice.scan();
    blePlatform.setMethodCallHandler((call) {
        switch(call.method){
          case 'scanResult':
            handleBleScanCallback(call.arguments);
            print("scanned: " + call.arguments.toString());
            break;
          default:
            print('TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
        }
        return;
    });
  }
  
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    blePlatform.invokeMethod('bleStopScan');
    print("dialog deactivated ");
  }

  void handleBleScanCallback(Map bleDescriptor){
      print("handleBleScanCallback invoked");
      if(!devices.contains(bleDescriptor))
        setState(() {
          devices.add(bleDescriptor);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: listOfItems(devices),
    );
  }
  
}

class SimpleDialogItem extends StatelessWidget {
  // static const platform = const MethodChannel(BLE_CHANNEL);
  const SimpleDialogItem({Key key, this.text, this.onPressed})
      : super(key: key);

  // final IconData icon;
  // final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text)
          ),
        ],
      ),
    );
  }
}

