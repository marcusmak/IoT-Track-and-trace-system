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
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.example.vb_v0.R;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;

import static androidx.core.app.ActivityCompat.startActivityForResult;

public class BleConnector extends Service {
    private static final int REQUEST_ENABLE_BT = 1;
    private BluetoothManager mBluetoothManager;
    private BluetoothAdapter mBluetoothAdapter;

    private BluetoothLeScanner mLEScanner;
    private boolean mScanning;
    private Handler mHandler = new Handler();;

    // Stops scanning after 10 seconds.
    private static final long SCAN_PERIOD = 10000;

    private ScanSettings settings;
    private List<ScanFilter> filters;
    private BluetoothGatt mGatt;


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        Log.d("BLE_Connection","onBind");
        return null;
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
        if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, R.string.ble_not_supported, Toast.LENGTH_SHORT).show();
            stopSelf();
        }
        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            Toast.makeText(this,R.string.bluetooth_disabled, Toast.LENGTH_LONG).show();
//            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
//            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
        if (Build.VERSION.SDK_INT >= 21) {
            mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
        }
        scanLeDevice(true);
    }

    @Override
    public void onRebind(Intent intent) {
        super.onRebind(intent);
        if (Build.VERSION.SDK_INT >= 21) {
            mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
            settings = new ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                    .build();
            filters = new ArrayList<ScanFilter>();
        }
        scanLeDevice(true);

    }

    @Override
    public void onDestroy() {
        if (mGatt == null) {
            return;
        }
        mGatt.close();
        mGatt = null;
        super.onDestroy();
    }

    private void scanLeDevice(final boolean enabled) {
        if(enabled){
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    mScanning = false;
                    if(Build.VERSION.SDK_INT >= 21) {
                        mLEScanner.stopScan(mLeScanCallback);
                    }else{
                        mBluetoothAdapter.stopLeScan(mScanCallback);
                    }
                    Log.d("BLE_Connection","Scanning period over...");
                }
            },SCAN_PERIOD);
            mScanning = true;
            if(Build.VERSION.SDK_INT >= 21){
                mLEScanner.startScan(mLeScanCallback);
            }else{
                mBluetoothAdapter.startLeScan(mScanCallback);
            };
        } else {
            mScanning = false;
            if(Build.VERSION.SDK_INT >= 21) {
                mLEScanner.stopScan(mLeScanCallback);
            }else{
                mBluetoothAdapter.stopLeScan(mScanCallback);
            }
        }
    }

//    private LeDeviceListAdapter leDeviceListAdapter;

    // Device scan callback.
    private ScanCallback mLeScanCallback = Build.VERSION.SDK_INT>= Build.VERSION_CODES.LOLLIPOP?
            new ScanCallback() {
                @Override
                public void onScanResult(int callbackType, ScanResult result) {
                    Log.d("BLE_Connection", "callbackType: "+String.valueOf(callbackType));
                    Log.d("BLE_Connection", "result: " + result.toString());
                    BluetoothDevice btDevice = result.getDevice();
                    connectToDevice(btDevice);
                }
                @Override
                public void onBatchScanResults(List<ScanResult> results) {
                    for (ScanResult sr : results) {
                        Log.i("BLE_Connection","ScanResult - Results: " + sr.toString());
                    }
                }
                @Override
                public void onScanFailed(int errorCode) {
                    Log.e("BLE_Connection","Scan Failed" + "Error Code: " + errorCode);
                }
            }:null;


    private BluetoothAdapter.LeScanCallback mScanCallback = Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP ? new BluetoothAdapter.LeScanCallback() {
            @Override
            public void onLeScan(final BluetoothDevice device, int rssi,
            byte[] scanRecord) {
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        Log.i("BLE_Connection","onLeScan: " + device.getName());
                        connectToDevice(device);
                    }
                });
            }
        }: null;

    public void connectToDevice(BluetoothDevice device) {
        if (mGatt == null) {
            mGatt = device.connectGatt(this, false, gattCallback);
            scanLeDevice(false);// will stop after first device detection
        }
    }

    private final BluetoothGattCallback gattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            Log.i("BLE_Connection","onConnectionStateChange: " +   "Status: " + status);
            switch (newState) {
                case BluetoothProfile.STATE_CONNECTED:
                    Log.i("BLE_Connection","gattCallback: "+"STATE_CONNECTED");
                    gatt.discoverServices();
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    Log.e("BLE_Connection","gattCallback: " + "STATE_DISCONNECTED");
                    break;
                default:
                    Log.e("BLE_Connection","gattCallback: " + "STATE_OTHER");
            }
        }
        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            List<BluetoothGattService> services = gatt.getServices();
            Log.i("BLE_Connection","onServicesDiscovered: "+ services.toString());
            gatt.readCharacteristic(services.get(1).getCharacteristics().get
                    (0));
        }
        @Override
        public void onCharacteristicRead(BluetoothGatt gatt,
                                         BluetoothGattCharacteristic
                                                 characteristic, int status) {
            Log.i("BLE_Connection","onCharacteristicRead: " +  characteristic.toString());
            gatt.disconnect();
        }
    };

}
