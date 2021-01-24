package com.example.vb_v0.alarm.service.util;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import io.flutter.Log;

public class RuleChecker {
    final static String TAG_BOOT_EXECUTE_SERVICE = "BOOT_RULE_CHECKER";
    private SQLiteDatabase db;// = dbHelper.getReadableDatabase();
    private Context context;
    public RuleChecker(Context context){
        this.context = context;
    }

    public boolean openDatabase(){
        if(context.getDatabasePath("localDB.db").exists()){
            db = SQLiteDatabase.openDatabase(context.getDatabasePath("localDB.db").getAbsolutePath(),null,SQLiteDatabase.OPEN_READONLY);
            return true;
        }else{
            Log.e(TAG_BOOT_EXECUTE_SERVICE,"local database does not exist");
        }
        return false;
    }

    public void closeDatabase(){
        if(db != null){
            db.close();
        }
    }

    public void checkRule(PackingContextManager.PackingContext current){
        browseTable("inbag_record");
        browseTable("outbag_record");
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"checking custom rule");
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"checking system rule");

    }

    public void browseTable(String table){
        if(!openDatabase())
            return;
        if(!db.isOpen())
            return;
        Cursor system_ruleRes = db.query(table,null,null,null,null,null,null);
        String[] columns = system_ruleRes.getColumnNames();
        String temp = "";
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"Table: " + table);
        for(String col: columns){
            temp += col + "|";
        }
        temp +="\n";


        while(system_ruleRes.moveToNext()){
            for(String col : columns){
                try{
                    temp += system_ruleRes.getString(system_ruleRes.getColumnIndexOrThrow(col)) + "|";
                }catch (Exception e){
                    Log.e(TAG_BOOT_EXECUTE_SERVICE,e.toString());
                    continue;
                }
            }
            temp += "\n";
        }
        Log.d(TAG_BOOT_EXECUTE_SERVICE,temp);
        closeDatabase();
    }
}
