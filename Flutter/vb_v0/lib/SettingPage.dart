import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vb_v0/ControllerClass/BluetoothDevice.dart';
import 'package:vb_v0/main.dart';

import 'Global_var.dart';

const Color barBgColor = Color.fromARGB(255, 79, 79, 79);
/// This is the stateful widget that the main application instantiates.
class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingPageState extends State<SettingPage> {
  //bridge to native code
  // bool _isScanning = false;
  // static const platform = const MethodChannel(BLE_CHANNEL);
  

  BleDevicesDialog mBleDevicesDialog = BleDevicesDialog();


  @override
  Widget build(BuildContext context) {
    // if(devicesName.isNotEmpty){
    //   print("devices list: " + devicesName.toString());

    // }
    return Scaffold(
        backgroundColor: Color.fromARGB(125, 100, 100, 100),

        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:MediaQuery.of(context).size.width * 0.05, 
              vertical:  MediaQuery.of(context).size.height * 0.05
          ),
          child:
              Column(
                children:[
                  Row(children: [
                    GestureDetector(
                      onTap: (){
                        print("back");
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30.0,
                        color: Color.fromRGBO(207, 190, 190, 1)
                      )
                    ),
                    Text("Setting",
                        style: TextStyle(color: Colors.white60, fontSize: 30),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width  * 0.01,
                      vertical:   MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: 
                      Column(
                        children: <Widget>[
                          //connect ble button
                          MaterialButton(
                            color: Colors.white54,
                            onPressed: () async{
                              bool response = false;
                              // if(_isScanning){
                              showDialog(context: context, builder:(context)=>
                                mBleDevicesDialog
                              );
                              try {
                                final bool result = await  blePlatform.invokeMethod('bleScan');
                                response = result;
                              } on PlatformException catch (e) {
                                print("Failed to Invoke: '${e.message}'.");
                                // _isScanning = false;
                              }
                              print("isAlrdyScanning: " + (!response).toString());
                                // setState(() {
                                //   // _isScanning = response;
                                // });
                              // }
                            },
                            child: Text("Connect the bag")
                          ),
                          MaterialButton(
                            color: Colors.white54,
                            onPressed: () async{
                              // try {
                              //   if(await  blePlatform.invokeMethod('bleDisconnect',{"mAddress":MyApp.bluetoothDevice.mAddress})){
                              MyApp.bluetoothDevice.disconnect().then((value) => value?MyApp.bluetoothDevice = null:null);
                              //   }
                              // } on PlatformException catch (e) {
                              //   print("Failed to Invoke: '${e.message}'.");
                              // }
                            },
                            child: Text("Disconnect the bag")
                          ),
                          //Logout button
                          GestureDetector(
                            onTap: (){
                              print("LOGOUT");
                              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(
                                vertical:10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child:
                                Center(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout),
                                      Text("LOGOUT",style: TextStyle(color:Colors.black45,fontSize: 25),),
                                    ],
                                  )
                                )
                                
                            ),
                          )
                        ]
                      )
                    ,

                  )
                ]
              )
              
            
            )
              
          
          
      );
  }
}

class BleDevicesDialog extends StatefulWidget {
  BleDevicesDialog({Key key}) : super(key: key);

  @override
  _BleDevicesDialogState createState() => _BleDevicesDialogState();
}



class _BleDevicesDialogState extends State<BleDevicesDialog> {
  // static const platform = const MethodChannel(BLE_CHANNEL);
  List<Map> devices = List();

  List<Widget> listOfItems(List<Map> devices){
    List<Widget> results = new List();
    devices.forEach((element) {
      results.add(
        SimpleDialogItem( 
          text:element['mName'],
          onPressed: () async{
            MyApp.bluetoothDevice = BluetoothDevice(element['mName'],element['mAddress']);
            if(!(await MyApp.bluetoothDevice.connect()))
              MyApp.bluetoothDevice = null;
          },
        )
      );
    });
    return results;    
  }

  @override
  void initState() {
    super.initState();
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