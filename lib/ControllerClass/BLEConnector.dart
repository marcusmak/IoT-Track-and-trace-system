import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

class BLEConnector extends StatefulWidget{
  BLEConnector({Key key}) : super(key: key);
   
  @override
  _BLEConnectorState createState() => _BLEConnectorState();
}

class _BLEConnectorState extends State<BLEConnector>{
  
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
  static FlutterBlue flutterBlue = FlutterBlue.instance;
  static BluetoothDevice device;
  static BluetoothState state;
  static BluetoothDeviceState deviceState; ///Initialisation and listening to device state
  static BLEConnector instance = BLEConnector();
  static bool isBluetoothOn;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _addDeviceTolist(BluetoothDevice device){
    // this.device = device;
    print("Device: " + device.toString());
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

  void scanDevices(){
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
        // do something with scan results
        for (ScanResult r in results) {
            print('${r.device.name} found! rssi: ${r.rssi}');
        }
    });
    // Stop scanning
    flutterBlue.stopScan();
  }

  void checkState(){
    var subscription = FlutterBlue.instance.state.listen((state) {
      if(state == BluetoothState.off){
        //Alert user to turn on bluetooth
        setState(()=> isBluetoothOn = false);
        promptBluetoothQuery();
      }else{
        setState(()=> isBluetoothOn = true);
      }
    });
    // subscription.asFuture()
  }

  void promptBluetoothQuery(){
    print("Please turn on bluetooth");
  }

}







