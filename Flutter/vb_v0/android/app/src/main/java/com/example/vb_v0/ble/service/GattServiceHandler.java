package com.example.vb_v0.ble.service;

import com.example.vb_v0.MainActivity;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;

import java.util.ArrayList;
import java.util.UUID;

import com.example.vb_v0.alarm.service.BootDeviceReceiver;
import com.example.vb_v0.alarm.service.util.BagActivityManager;
import com.google.gson.Gson;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class GattServiceHandler{
    private static final String CHANNEL_GATT = "com.example.vb_v0/gatt_service";
    private BluetoothDevice mBluetoothDevice;
    private Context androidContext;
    private BluetoothGatt mGatt;
    private BluetoothGattService mService;
    public static boolean isConnecting;
    private static final String SERVICE_UUID              = "3a0f9e45-81dc-4117-8f6a-8ebebd11fee8";
    private static final String CHARACTERISTIC_LIVE_UUID  = "a8eeccdd-2335-4b7e-9ca0-f22d404144f1";
    private static final String CHARACTERISTIC_BATCH_UUID = "e4a90c6d-e898-4a3a-a20f-86d9b09026b0";
    public static GattServiceHandler instance;

    public static GattServiceHandler getInstance(Context context,BluetoothDevice device){
        if(instance == null){
            instance = new GattServiceHandler(context, device);
        }
        return instance;
    }

    public static GattServiceHandler getInstance(){
        return instance;
    }

    GattServiceHandler(Context context,BluetoothDevice device){
        mBluetoothDevice = device;
        androidContext = context;

    }
    public void scanTags(){
        if(mGatt != null && mService != null)
            mGatt.readCharacteristic(mService.getCharacteristic(UUID.fromString(CHARACTERISTIC_LIVE_UUID)));
    }

    public void scanTags(MethodChannel.Result result){
        if(mGatt != null) {
            Log.d("Gatt_Service","scanTag now");
            mGatt.readCharacteristic(mService.getCharacteristic(UUID.fromString(CHARACTERISTIC_LIVE_UUID)));
            result.success(true);
        }else{
//                                    result.error();
            result.success(false);
        }
    }

    public String getConnectedDeviceAddress(){
        if(mBluetoothDevice == null)
            return null;
        return mBluetoothDevice.getAddress();
    }

    public void close(){
        this.disconnect();
        if(mGatt != null){
            mGatt.close();
            mGatt = null;
        }
    }

    public boolean connect(){
        if (mGatt == null && mBluetoothDevice != null) {
            mGatt = mBluetoothDevice.connectGatt(androidContext, true, gattCallback);
            return true;
        }
        return false;
    }

    public boolean disconnect(){
        if (mGatt == null && mBluetoothDevice != null) {
            return false;
        };
        mGatt.disconnect();
        return true;
    }

    private final BluetoothGattCallback gattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            Log.i("Gatt_service","onConnectionStateChange: " +   "Status: " + status);
            switch (newState) {
                case BluetoothProfile.STATE_CONNECTED:
                    Log.i("Gatt_service","gattCallback: "+"STATE_CONNECTED");
                    isConnecting = true;
                    gatt.discoverServices();
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    Log.i("Gatt_service","gattCallback: " + "STATE_DISCONNECTED");
                    isConnecting = false;
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

            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // Call the desired channel message here.

                    ArrayList<String> result = BleResParser.parse2BleRes(stream);
                    if(result == null){
                        result = new ArrayList<>();
                    }

                    Log.i("Gatt_service","RFID Res: " + new Gson().toJson(result) );
                    if(MainActivity.mFlutterEngine != null) {
                        new MethodChannel(MainActivity.mFlutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_GATT)
                                .invokeMethod("scanTagsRes", result);
                    }
                    if(BootDeviceReceiver.isRepeating){

                        Intent broadcastIntent = new Intent(androidContext, BagActivityManager.class);
//        Bundle bleDevice = new Bundle();
//        bleDevice.putString("bleName",device.getName());
//        bleDevice.putString("bleAddress",device.getAddress());
                        broadcastIntent.putStringArrayListExtra("in_bag",result);
                        androidContext.sendBroadcast(broadcastIntent);
                    }
                }

            });

        }
    };


}
