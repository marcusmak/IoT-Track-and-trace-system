package com.example.vb_v0;

import android.app.ActivityManager;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import android.os.Looper;
import android.preference.PreferenceManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.vb_v0.alarm.service.BootDeviceReceiver;
import com.example.vb_v0.alarm.service.LocalNotificationManager;
import com.example.vb_v0.ble.service.BleScanner;
import com.example.vb_v0.ble.service.GattServiceHandler;

import java.util.HashMap;
import java.util.UUID;

//import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static boolean hasActivity;
    private static final String CHANNEL_BLE = "com.example.vb_v0/ble_connector";
    private static final String CHANNEL_GATT = "com.example.vb_v0/gatt_service";
    BleScanner mBleConnector;
    boolean mBound = false;
    public static FlutterEngine mFlutterEngine;
    private boolean debugMode = true;
    private BroadcastReceiver mBootDeviceReceiver;
    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,IBinder service) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance
            BleScanner.LocalBinder binder = (BleScanner.LocalBinder) service;
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
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL_BLE).setMethodCallHandler(
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
                            case "bleGetConnected":
                                String res = bleGetConnected();
//                                if(res != null)
                                    result.success(res);
//                                else
//                                    result.success("not connected",null,null);
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

        new MethodChannel(MainActivity.mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL_GATT).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        switch (call.method){
                            case "scanTags":
//                                mGatt.setCharacteristicNotification()
                                if(GattServiceHandler.getInstance()!= null)
                                    GattServiceHandler.getInstance().scanTags(result);
                            break;
                            default:
                                Log.e("Gatt_Service","Wrong method invoked");

                        }
                    }
                }
        );



    }

    @Override
    protected void onDestroy() {
        if (mBootDeviceReceiver != null) {
            unregisterReceiver(mBootDeviceReceiver);
            mBootDeviceReceiver = null;
        }
        Log.d("MainActivity","onStop");
        if(connection != null && mBound){
            unbindService(connection);
            mBound = false;
        }
        hasActivity = false;
        super.onDestroy();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        mBootDeviceReceiver = new BootDeviceReceiver();
        IntentFilter filter = new IntentFilter();
        if (debugMode || !prefs.getBoolean("firstTime", false)) {
            // <---- run your one time code here

            filter.addAction("android.intent.action.BOOT_COMPLETED");
            Log.d("BOOT_BROADCAST_RECEIVER","Registered boot_completed action");

            // mark first time has ran.
            SharedPreferences.Editor editor = prefs.edit();
            editor.putBoolean("firstTime", true);
            editor.commit();
        }

        filter.addAction("ACTION_CANCEL_SERVICE");
        filter.addAction("DEBUG_ALARM_SERVICE");
        HandlerThread handlerThread = new HandlerThread("ht");
        handlerThread.start();
        Looper looper = handlerThread.getLooper();
        Handler handler = new Handler(looper);
        getContext().registerReceiver(mBootDeviceReceiver, filter, null, handler);

    }


    @Override
    protected void onStop() {
        super.onStop();

    }

    @Override
    protected void onRestart() {
        super.onRestart();

    }

    @Override
    protected void onStart() {
        super.onStart();
        hasActivity = true;
        if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, R.string.ble_not_supported, Toast.LENGTH_LONG).show();
            Log.d("MainActivity","Sorry, you device does not support BLE.");
        }else {
            Log.d("MainActivity", "onStart: " + String.valueOf(bindService(new Intent(this, BleScanner.class), connection, Context.BIND_AUTO_CREATE)));
            //!!!!!!!!!!!!!!!!!!!!!!!!
//            //TODO comment for debug only
//            if(!debugMode)
            bindService(new Intent(this, BleScanner.class),connection,Context.BIND_AUTO_CREATE);
        }


        //alarm service
        Intent debugAlramTrigger = new Intent();
        debugAlramTrigger.setAction("DEBUG_ALARM_SERVICE");
        Log.d("BOOT_BROADCAST_RECEIVER",debugAlramTrigger.getAction());
        sendBroadcast(debugAlramTrigger);
    }

    private boolean bleScan() {
        if(mBound && !GattServiceHandler.isConnecting){
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

    private String bleGetConnected(){
        Log.d("BLE_Connection", "connecting to background");
        if(GattServiceHandler.getInstance() != null && GattServiceHandler.isConnecting){
            return GattServiceHandler.getInstance().getConnectedDeviceName() +"|" + GattServiceHandler.getInstance().getConnectedDeviceAddress();
        };
        return null;
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

            //scan ble devices result
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // Call the desired channel message here.
                    Log.d("BLE callback", "result callback");
                    new MethodChannel(mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL_BLE)
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
