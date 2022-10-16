import 'package:flutter/services.dart';
const SERVER_URL = "http://192.168.0.49:5000/";
const String BLE_CHANNEL = "com.example.vb_v0/ble_connector";
const blePlatform = const MethodChannel(BLE_CHANNEL);
const String GATT_CHANNEL = "com.example.vb_v0/gatt_service";
const gattPlatform = const MethodChannel(GATT_CHANNEL);