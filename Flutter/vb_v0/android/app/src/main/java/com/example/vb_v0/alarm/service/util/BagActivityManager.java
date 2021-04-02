package com.example.vb_v0.alarm.service.util;

import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.location.Location;
import android.os.Build;
import android.util.Log;

//import com.tekartik.sqflite.Database;

//import java.sql.Date;
import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class BagActivityManager extends BroadcastReceiver {


    private static final String TAG_BOOT_EXECUTE_SERVICE = "BOOT_BAG_ACT";
    private Context context;
    public static HashSet<String> inbag_items = new HashSet<>();

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("in_bag","intent action: " + intent.getAction());
        this.context = context;
        ArrayList<String> tags = intent.getStringArrayListExtra("in_bag");
        GeoInfoManager.getInstance(context).getCurrentLocation().addOnCompleteListener(new OnCompleteListener<Location>() {
            @Override
            public void onComplete(@NonNull Task<Location> task) {
                if(task.isSuccessful()){
                    storeRecord(new HashSet<String>(tags),task.getResult());
                }else{
                    storeRecord(new HashSet<String>(tags),null);
                }
            }
        });

    }

    private void storeRecord(HashSet<String> tags,Location location){
        if(context.getDatabasePath("localDB.db").exists()){
            SQLiteDatabase db;
            db = SQLiteDatabase.openDatabase(context.getDatabasePath("localDB.db").getAbsolutePath(),null,SQLiteDatabase.OPEN_READWRITE);
            String coordinates = location.getLatitude() + "," + location.getLongitude();
            inbagRecord(db,tags,coordinates);
            outbagRecord(db,tags,coordinates);
            db.close();
        }else{
            Log.e(TAG_BOOT_EXECUTE_SERVICE,"local database does not exist");
        }


        inbag_items.clear();
        inbag_items.addAll(tags);

    }

    private void inbagRecord(SQLiteDatabase db, HashSet<String> items, String loc){
        Log.d(TAG_BOOT_EXECUTE_SERVICE, "old in bag: " + inbag_items.toString());
        Log.d(TAG_BOOT_EXECUTE_SERVICE, "new in bag: " + items.toString());
//        request
        if(inbag_items.containsAll(items))
            return;
        for(String epc : items){
            if(!inbag_items.contains(epc)) {
                ContentValues contentVal = new ContentValues();
                contentVal.put("timestamp", (new Date()).getTime());
                if(loc != null)
                    contentVal.put("loc",loc);
                contentVal.put("EPC", epc);
                db.insert("inbag_record", null, contentVal);
                contentVal.clear();
                contentVal.put("in_bag",1);
                db.update("Item", contentVal,"EPC = ?", new String[] {epc});
            }
        }
    }

    private void outbagRecord(SQLiteDatabase db, Set<String> newItems, String loc){
        Set<String> outbag_records = LeftComplement(inbag_items,newItems);
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"removed items: " + outbag_records.toString());
        if(outbag_records.isEmpty())
            return;
        for(String epc : outbag_records){
            ContentValues contentVal = new ContentValues();
            contentVal.put("timestamp", System.currentTimeMillis()/1000);
            if(loc != null)
                contentVal.put("loc", loc);
            contentVal.put("EPC", epc);
            db.insert("outbag_record", null, contentVal);
            contentVal.clear();
            contentVal.put("in_bag",0);
            db.update("Item", contentVal,"EPC = ?", new String[] {epc});
        }
    }

    //

    //helper function to determine what have been removed
    private static Set<String> LeftComplement(Set<String> oldItems, Set<String> newItems){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            oldItems.removeIf((itemEPC)->newItems.contains(itemEPC));
        }else{
            HashSet<String> temp = new HashSet<>(newItems);
            temp.retainAll(oldItems);
            oldItems.removeAll(temp);
        };
        return oldItems;
    }

    public static Set<String> NotInBag(Set<String> requestItems){
        return LeftComplement(requestItems,inbag_items);
    }

}
