package com.example.vb_v0.alarm.service.util;

import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Build;
import android.util.Log;

//import com.tekartik.sqflite.Database;

//import java.sql.Date;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class BagActivityManager extends BroadcastReceiver {


    private static final String TAG_BOOT_EXECUTE_SERVICE = "BOOT_BAG_ACT";
    private Context context;

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("in_bag","intent action: " + intent.getAction());
        this.context = context;
        ArrayList<String> tags = intent.getStringArrayListExtra("in_bag");
        storeRecord(new HashSet<String>(tags));
    }
    private void storeRecord(HashSet<String> tags){
        if(context.getDatabasePath("localDB.db").exists()){
            SQLiteDatabase db;
            db = SQLiteDatabase.openDatabase(context.getDatabasePath("localDB.db").getAbsolutePath(),null,SQLiteDatabase.OPEN_READWRITE);
            inbagRecord(db,tags);
            outbagRecord(db,tags);
            db.close();
        }else{
            Log.e(TAG_BOOT_EXECUTE_SERVICE,"local database does not exist");
        }


        inbag_items.clear();
        inbag_items.addAll(tags);

    }

    private void inbagRecord(SQLiteDatabase db, HashSet<String> items){
        Log.d(TAG_BOOT_EXECUTE_SERVICE, "old in bag: " + inbag_items.toString());
        Log.d(TAG_BOOT_EXECUTE_SERVICE, "new in bag: " + items.toString());
        if(inbag_items.containsAll(items))
            return;
        for(String epc : items){
            if(!inbag_items.contains(epc)) {
                ContentValues contentVal = new ContentValues();
                contentVal.put("timestamp", (new Date()).getTime());
                contentVal.put("loc","null");
                contentVal.put("EPC", epc);
                db.insert("inbag_record", null, contentVal);
            }
        }
    }

    private void outbagRecord(SQLiteDatabase db, HashSet<String> newItems){
        HashSet<String> outbag_records = LeftComplement(inbag_items,newItems);
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"removed items: " + outbag_records.toString());
        if(outbag_records.isEmpty())
            return;
        for(String epc : outbag_records){
            ContentValues contentVal = new ContentValues();
            contentVal.put("timestamp", (new Date()).getTime());
            contentVal.put("loc","null");
            contentVal.put("EPC", epc);
            db.insert("outbag_record", null, contentVal);
        }
    }

    private HashSet<String> LeftComplement(HashSet<String> oldItems, HashSet<String> newItems){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            oldItems.removeIf((itemEPC)->newItems.contains(itemEPC));
        }else{
            HashSet<String> temp = new HashSet<>(newItems);
            temp.retainAll(oldItems);
            oldItems.removeAll(temp);
        };
        return oldItems;
    }
    public static HashSet<String> inbag_items = new HashSet<>();
}
