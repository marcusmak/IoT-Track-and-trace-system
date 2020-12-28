package com.example.vb_v0.ble.service;

import com.example.vb_v0.MainActivity;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import com.google.gson.Gson;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class GattServiceHandler{
    private static final String CHANNEL = "com.example.vb_v0/gatt_service";
    private BluetoothDevice mBluetoothDevice;
    private Context androidContext;
    private BluetoothGatt mGatt;
    private BluetoothGattService mService;
    private static final String SERVICE_UUID              = "3a0f9e45-81dc-4117-8f6a-8ebebd11fee8";
    private static final String CHARACTERISTIC_LIVE_UUID  = "a8eeccdd-2335-4b7e-9ca0-f22d404144f1";
    private static final String CHARACTERISTIC_BATCH_UUID = "e4a90c6d-e898-4a3a-a20f-86d9b09026b0";

    GattServiceHandler(Context context,BluetoothDevice device){
        mBluetoothDevice = device;
        androidContext = context;
        new MethodChannel(MainActivity.mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        switch (call.method){
//                            case "":
//                                ;
                            case "fetchItems":
//                                mGatt.setCharacteristicNotification()
                                mGatt.readCharacteristic(mService.getCharacteristic(UUID.fromString(CHARACTERISTIC_LIVE_UUID)));
                                result.success(true);
                                break;
                            default:
                                Log.e("Gatt_Service","Wrong method invoked");

                        }
                    }
                }
        );
    }

    public String getConnectedDeviceAddress(){
        if(mBluetoothDevice == null)
            return null;
        return mBluetoothDevice.getAddress();
    }

    public void close(){
        this.disconnect();
        mGatt.close();
    }

    public boolean connect(){
        if (mGatt == null && mBluetoothDevice != null) {
            mGatt = mBluetoothDevice.connectGatt(androidContext, false, gattCallback);
            return true;
        }
        return false;
    }

    public boolean disconnect(){
        if (mGatt == null && mBluetoothDevice != null) {
            return false;
        };
        mGatt.disconnect();
        mGatt = null;
        return true;
    }


    private final BluetoothGattCallback gattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            Log.i("Gatt_service","onConnectionStateChange: " +   "Status: " + status);
            switch (newState) {
                case BluetoothProfile.STATE_CONNECTED:
                    Log.i("Gatt_service","gattCallback: "+"STATE_CONNECTED");
                    gatt.discoverServices();
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    Log.i("Gatt_service","gattCallback: " + "STATE_DISCONNECTED");
                    break;
                default:
                    Log.e("Gatt_service","gattCallback: " + "STATE_OTHER");
            }
        }
        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
//            List<BluetoothGattService> services = gatt.getServices();
            mService = gatt.getService(UUID.fromString(SERVICE_UUID));
            if(mService == null) {
                disconnect();
                return;
            }

        }
        @Override
        public void onCharacteristicRead(BluetoothGatt gatt,
                                         BluetoothGattCharacteristic
                                                 characteristic, int status) {
            byte[] stream = characteristic.getValue();
            Log.i("Gatt_service","onCharacteristicRead: " + ByteHelper.bytesToHex(stream) );

//            for(BleResParser.SingleRfidRes rfidTag : BleResParser.parseRes(stream)){

//            }

            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // Call the desired channel message here.
                    Log.i("Gatt_service","RFID Res: " + new Gson().toJson(BleResParser.parse2BleRes(stream)) );
                    new MethodChannel(MainActivity.mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL)
                            .invokeMethod("fetchItemsRes",BleResParser.parse2BleRes(stream));
                }
            });

        }
    };


}
