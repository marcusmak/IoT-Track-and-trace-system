package com.example.vb_v0.alarm.service.util;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.tasks.CancellationTokenSource;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.SuccessContinuation;
import com.google.android.gms.tasks.Task;

import java.util.Calendar;

public class GeoInfoManager {
    Context context;
    //    LocationRequest locationRequest;
//    LocationCallback locationCallback;
    FusedLocationProviderClient fusedLocationClient;
    CancellationTokenSource cts = new CancellationTokenSource();
    private GeoInfo last_update;
    private static GeoInfoManager instance;

    public class GeoInfo {
        double latitude;
        double longitude;
        float accuracy;
        String nature;
        String postcode;
        long update_timestamp;

        public GeoInfo(double latitude, double longitude, float accuracy,String nature, long update_timestamp){
            this.latitude = latitude;
            this.longitude = longitude;
            this.accuracy = accuracy;
            this.nature = nature;
            this.update_timestamp = update_timestamp;
        }
    }

    public static GeoInfoManager getInstance(Context ctx){
        if(instance == null){
            instance = new GeoInfoManager(ctx);
        }
        return instance;
    }

    private GeoInfoManager(Context ctx) {
        context = ctx;
        fusedLocationClient = new FusedLocationProviderClient(ctx);
    }

    private boolean checkPermission(){
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return false;
        }
        return true;
    }


    public Task<Location> getCurrentLocation(){
        Log.i("BOOT_GEOINFO_MANAGER","acquiring location");
        try {
            if(!checkPermission())
                return null;
            Task<Location> task = fusedLocationClient.getCurrentLocation(LocationRequest.PRIORITY_HIGH_ACCURACY, cts.getToken());
            return task;
        } catch (Exception e) {
            Log.e("BOOT_GEOINFO_MANAGER",e.toString());
        }
        return null;
    };

    public GeoInfo getLastGeoInfo(){
        return last_update;
    };

    public Task<GeoInfo> getCurrentGeoInfo(){
        Log.i("BOOT_GEOINFO_MANAGER","acquiring geo info");
        Task<Location> task = getCurrentLocation();

        if(task == null) {
            Log.i("BOOT_GEOINFO_MANAGER","unsuccessful GETCURRENTGEOINFO LOCATION");
            return null;
        }
        Log.i("BOOT_GEOINFO_MANAGER","task received");
        return task.continueWith(new Continuation<Location, GeoInfo>() {
            @Override
            public GeoInfo then(@NonNull Task<Location> task) throws Exception {
                if(task.isSuccessful()) {
                    try {
                        Location result = task.getResult();
                        if(result != null) {
                            Log.i("BOOT_GEOINFO_MANAGER", result.toString());
                            Log.i("BOOT_GEOINFO_MANAGER", result.getProvider());
                            last_update = new GeoInfo(result.getLatitude(), result.getLongitude(), result.getAccuracy(),null,System.currentTimeMillis()/1000);
                            return last_update;
                        }else{
                            Log.i("BOOT_GEOINFO_MANAGER", "no geo data received");
                            return null;
                        }
                    } catch (Exception e) {
                        Log.e("BOOT_GEOINFO_MANAGER",e.toString());
                        return null;
                    }
                }
                Log.i("BOOT_GEOINFO_MANAGER","unsuccessful geo request");
                return null;
            }
        });
    };

}



//
//    public GeoInfo getGeoInfo() {
//        try {
//            if(!checkPermission())
//                return null;
//            Task<Location> task = fusedLocationClient.getCurrentLocation(LocationRequest.PRIORITY_HIGH_ACCURACY, cts.getToken());
//            task.addOnCompleteListener(new OnCompleteListener<Location>() {
//                @Override
//                public void onComplete(@NonNull Task<Location> task) {
//                    if(task.getResult() != null)
//                        Log.i("BOOT_GEOINFO_MANAGER", task.getResult().toString());
//                    else
//                        Log.i("BOOT_GEOINFO_MANAGER", "no geo result");
//                }
//            });
//            task.addOnFailureListener(new OnFailureListener() {
//                @Override
//                public void onFailure(@NonNull Exception e) {
//                    Log.i("BOOT_GEOINFO_MANAGER","geo info task failed");
//                }
//            });
//
//        } catch (Exception e) {
//            Log.e("BOOT_GEOINFO_MANAGER",e.toString());
//        }
////        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
////                && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
////
////        }else{
////            Log.i("BOOT_GEOINFO_MANAGER", "turn on gps");
////        }
//        return null;
////                .requestLocationUpdates(locationRequest,
////                locationCallback,
////                Looper.getMainLooper());
//
//    }