package com.example.vb_v0;

import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.vb_v0.alarm.service.RunAfterBootService;
import com.example.vb_v0.ble.service.BleConnector;

import java.util.HashMap;
import java.util.Map;
import com.google.gson.Gson;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.vb_v0/ble_connector";
    BleConnector mBleConnector;
    boolean mBound = false;
    public static FlutterEngine mFlutterEngine;

    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,IBinder service) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance
            BleConnector.LocalBinder binder = (BleConnector.LocalBinder) service;
            mBleConnector = binder.getService();
            Log.d("BLE_Connection","service bound");
            mBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            mBound = false;
        }
    };


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        mFlutterEngine = flutterEngine;
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        switch (call.method){
                            case "bleScan":
                                result.success(bleScan());
                                break;
                            case "bleStopScan":
                                result.success(bleStopScan());
                                break;
                            case "bleConnect":
                                result.success(bleConnect(call.argument("mAddress")));
                                break;
                            case "bleDisconnect":
                                result.success(bleDisconnect(call.argument("mAddress")));
                                break;
                            default:
                                Log.e("BLE_Connection","Wrong method invoked");
                        }
                    }
                }
        );
    }

//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//    }


    @Override
    protected void onStop() {
        super.onStop();
        Log.d("BLE_Connection","onStop");
        unbindService(connection);
        mBound = false;
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d("BLE_Connection","onStart" + String.valueOf(bindService(new Intent(this, BleConnector.class),connection,Context.BIND_AUTO_CREATE)));
//        bindService(new Intent(this, BleConnector.class),connection,Context.BIND_AUTO_CREATE);
    }

    private boolean bleScan() {
        if(mBound){
            Log.d("BLE_Connection","Starting ble service, connecting...");
            // Create intent to invoke the background service.
            // startService(new Intent(this, BleConnector.class));
            // bindService(new Intent(this, BleConnector.class),connection,Context.BIND_AUTO_CREATE);
            Log.i("BLE_Connection", "mBleConnector: "+mBleConnector.toString());
            mBleConnector.scanLeDevice(true);
            return true;
        }
        return false;
    }

    private boolean bleStopScan(){
        if(mBound){
            mBleConnector.scanLeDevice(false);
            return true;
        }
        return false;
    }

    private boolean bleConnect(String address){
        Log.d("BLE_Connection", "connecting to " + address);
        return mBleConnector.connectToDevice(address) != null;

    }

    private boolean bleDisconnect(String address){
        Log.d("BLE_Connection","disconnecting " + address);
        return mBleConnector.disconnectToDevice(address);
    }

    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

    public static class BleBroadcastReceiver extends BroadcastReceiver{

        @Override
        public void onReceive(Context context, Intent intent) {
//            Bundle value = intent.getExtras();
            BluetoothDevice btDevice = intent.getParcelableExtra("scannedBLE");
            HashMap<String,String> result  = new HashMap<String,String>();
            result.put("mName",btDevice.getName());
            result.put("mAddress",btDevice.getAddress());
            Log.i("BLE_Connection","Scanned: " + result.toString());

            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // Call the desired channel message here.
                    new MethodChannel(mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL)
                            .invokeMethod("scanResult",result);
                }
            });

        }
    }
//    @Override
//    public void onReceive(Context context, Intent intent) {
//        int value=intent.getIntExtra("VALUE", 0);
//    }
}
