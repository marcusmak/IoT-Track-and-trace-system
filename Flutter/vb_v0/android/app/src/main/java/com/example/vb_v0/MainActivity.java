package com.example.vb_v0;

import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
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
    private static FlutterEngine mFlutterEngine;

    private ServiceConnection connection = new ServiceConnection() {

        @Override
        public void onServiceConnected(ComponentName className,
                                       IBinder service) {
            // We've bound to LocalService, cast the IBinder and get LocalService instance
            BleConnector.LocalBinder binder = (BleConnector.LocalBinder) service;
            mBleConnector = binder.getService();
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
                        if(call.method.equals("bleConnect")){
                            boolean greetings = bleConnect();
                            result.success(greetings);
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
        unbindService(connection);
        mBound = false;
    }

    private boolean bleConnect() {
        if(!mBound){
            Log.d("BLE_Connection","Starting ble service, connecting...");
            // Create intent to invoke the background service.
            // startService(new Intent(this, BleConnector.class));
            bindService(new Intent(this, BleConnector.class),connection,Context.BIND_AUTO_CREATE);
            return true;
        }else{
            return false;
        }
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

//    private BleBroadcastReceiver mBleBroadcastReceiver = new BleBroadcastReceiver();

    public static class BleBroadcastReceiver extends BroadcastReceiver{

        @Override
        public void onReceive(Context context, Intent intent) {
            Bundle value = intent.getExtras();
            Log.i("BLE_Connection","Scanned: " + value.getString("bleName"));
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    // Call the desired channel message here.
                    new MethodChannel(mFlutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).invokeMethod("test",value.getString("bleName"));
                }
            });

        }
    }
//    @Override
//    public void onReceive(Context context, Intent intent) {
//        int value=intent.getIntExtra("VALUE", 0);
//    }
}
