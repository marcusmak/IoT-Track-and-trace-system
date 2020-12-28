package com.example.vb_v0.ble.service;

import android.app.Service;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.example.vb_v0.MainActivity;
import com.example.vb_v0.R;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.lang.String;
import java.util.Set;

import io.flutter.Log;

import static androidx.core.app.ActivityCompat.startActivityForResult;

public class BleConnector extends Service {
    private static final int REQUEST_ENABLE_BT = 1;
    private BluetoothManager mBluetoothManager;
    private BluetoothAdapter mBluetoothAdapter;

    private BluetoothLeScanner mLEScanner;
    private boolean mScanning;
    private Handler mHandler = new Handler();;

    // Stops scanning after 60 seconds.
    private static final long SCAN_PERIOD = 1000 * 60;

    private ScanSettings settings;
    private List<ScanFilter> filters;
//    private BluetoothGatt mGatt;
    private GattServiceHandler mGattServiceHandler;
    private final IBinder binder = new LocalBinder();
    private ArrayList<BluetoothDevice> ble_devices;
    private void addDevice(BluetoothDevice device){
        if(!ble_devices.contains(device)) {
            ble_devices.add(device);
            returnDevice(device);
        }
    }

    public class LocalBinder extends Binder {
        public BleConnector getService() {
            // Return this instance of LocalService so clients can call public methods
            return BleConnector.this;
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        Log.d("BLE_Connection","onBind");
        return binder;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("BLE_Connection","onStartCommand");
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("BLE_Connection","onCreate");
        this.mBluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        this.mBluetoothAdapter = mBluetoothManager.getAdapter();
        this.ble_devices = new ArrayList<>();
        if (Build.VERSION.SDK_INT >= 21) {
            mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
            settings = new ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                    .build();
            filters = new ArrayList<ScanFilter>();
        };

        if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, R.string.ble_not_supported, Toast.LENGTH_SHORT).show();
            stopSelf();
        }
        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            Toast.makeText(this,R.string.bluetooth_disabled, Toast.LENGTH_LONG).show();
//            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
//            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
    }

    @Override
    public void onRebind(Intent intent) {
        super.onRebind(intent);
        Log.i("BLE_Connection","onReBind");
        if (Build.VERSION.SDK_INT >= 21) {
            mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
            settings = new ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                    .build();
            filters = new ArrayList<ScanFilter>();
        }
    }

    @Override
    public void onDestroy() {
        Log.i("BLE_Connection","onDestory");
        if (mGattServiceHandler == null) {
            return;
        }
        mGattServiceHandler.close();
        mGattServiceHandler = null;
        super.onDestroy();
    }

    public void scanLeDevice(final boolean enabled) {
        ble_devices.clear();
        if(enabled){
            if(!mScanning){
                mHandler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        //only stop when it is scanning and reaches timeout
                        if(mScanning) {
                            Log.d("BLE_Connection","stop scanning");
                            if (Build.VERSION.SDK_INT >= 21) {
                                mLEScanner.stopScan(mScanCallback);
                            } else {
                                mBluetoothAdapter.stopLeScan(mLeScanCallback);
                            }
                            mScanning = false;
                        }
                    }
                }, SCAN_PERIOD);
                mScanning = true;
                if (Build.VERSION.SDK_INT >= 21) {
                    mLEScanner.startScan(mScanCallback);
                } else {
                    mBluetoothAdapter.startLeScan(mLeScanCallback);
                }
                ;
            }
        } else {
            if(mScanning) {
                Log.d("BLE_Connection","stop scanning");
                mScanning = false;
                if(Build.VERSION.SDK_INT >= 21) {
                    mLEScanner.stopScan(mScanCallback);
                }else{
                    mBluetoothAdapter.stopLeScan(mLeScanCallback);
                }
            }
        }
    }

    // Device scan callback.
    private ScanCallback mScanCallback = Build.VERSION.SDK_INT>= Build.VERSION_CODES.LOLLIPOP?
            new ScanCallback() {
                @Override
                public void onScanResult(int callbackType, ScanResult result) {
                    Log.d("BLE_Connection", "callbackType: "+String.valueOf(callbackType));
                    Log.d("", "result: " + result.toString());
                    BluetoothDevice btDevice = result.getDevice();
                    addDevice(btDevice);

//                    connectToDevice(btDevice);
                }
                @Override
                public void onBatchScanResults(List<ScanResult> results) {
                    for (ScanResult sr : results) {
                        addDevice(sr.getDevice());
                        Log.i("BLE_Connection","ScanResult - Results: " + sr.toString());
                    }
                }
                @Override
                public void onScanFailed(int errorCode) {
                    Log.e("BLE_Connection","Scan Failed" + "Error Code: " + errorCode);
                }
            }:null;

    //send data back to activity and then back to flutter
    private void returnDevice(BluetoothDevice device){
        if(device.getName() == null){
            return;
        }

        Intent broadcastIntent=new Intent(this, MainActivity.BleBroadcastReceiver.class);
//        Bundle bleDevice = new Bundle();
//        bleDevice.putString("bleName",device.getName());
//        bleDevice.putString("bleAddress",device.getAddress());
        broadcastIntent.putExtra("scannedBLE",device);
        sendBroadcast(broadcastIntent);
    }


    private BluetoothAdapter.LeScanCallback mLeScanCallback = Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP ? new BluetoothAdapter.LeScanCallback() {
            @Override
            public void onLeScan(final BluetoothDevice device, int rssi,
            byte[] scanRecord) {
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
//                        Log.i("BLE_Connection","onLeScan: " + device.getName());
                        addDevice(device);
//                        connectToDevice(device);
                    }
                });
            }
        }: null;









    //not yet used
    private BluetoothDevice addressToDevice(String address){

        for(int i = 0; i < ble_devices.size(); ++i)
            if(ble_devices.get(i).getAddress().equals(address))
                return ble_devices.get(i);
        return null;
    }

    public GattServiceHandler connectToDevice(String address) {
        BluetoothDevice temp = addressToDevice(address);
        if(temp == null)
            return null;
        return connectToDevice(temp);
    }

    public GattServiceHandler connectToDevice(BluetoothDevice device) {
        mGattServiceHandler = new GattServiceHandler(this,device);
        if(mGattServiceHandler.connect()){
            scanLeDevice(false);
            return mGattServiceHandler;
        };
        return null;
    }

    public boolean disconnectToDevice(String address){
        String connectedAddress = mGattServiceHandler.getConnectedDeviceAddress();
        if(connectedAddress == null || !connectedAddress.equals(address)){
            return false;
        }
        mGattServiceHandler.close();
        mGattServiceHandler = null;
        return true;
    }


}
