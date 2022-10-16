package com.example.vb_v0.alarm.service.util;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

    public Set<String> checkRule(PackingContextManager.PackingContext current){
        //todo
        Set<String> result = new HashSet<>();
//        browseTable("inbag_record");
//      ["Never","Every day","Every week","Every weekdays","Every month", "Every year"]
//        BagActivityManager.inbag_items
        Log.d(TAG_BOOT_EXECUTE_SERVICE,"checking custom rule");
        HashMap<String,String> customTemp = getCustomRecom(current);
        if(customTemp != null && !customTemp.isEmpty()){
            Set<String> temps = BagActivityManager.NotInBag(customTemp.keySet());
            for(String temp: temps){
                result.add(customTemp.get(temp));
            }
//            result.addAll();
//            result.addAll(customTemp);
        };


//        browseTable("outbag_record");

//        Log.d(TAG_BOOT_EXECUTE_SERVICE,"checking system rule");
//        Log.d(TAG_BOOT_EXECUTE_SERVICE,"checking server rule");
//        result.add("Laptop");
        return result;
    }

    private String padZero(int n){
        if(n < 10){
            return "0" + n;
        }
        return "" + n;
    }

    private String timeShift(int hour, int min, int shift){
        min = min + shift;

        if(min < 0){
            min += 60;
            hour -= 1;
        }

        if(min > 60){
            min -= 60;
            hour += 1;
        }

        return padZero(hour) + ":" + padZero(min);
    }

    public HashMap<String,String> getCustomRecom(PackingContextManager.PackingContext current){
        HashMap<String,String> result = new HashMap<>();

        Calendar currentTime = Calendar.getInstance();

        //Never repeat reminder
        //Every day
        String sql = "SELECT name, Item.EPC, classID, in_bag FROM custom_rule INNER JOIN Item \n" +
                "                ON Item.EPC = custom_rule.EPC \n" +
                "                WHERE (   \n" +
                "\t\t\t\t\t\t(start_date = CURRENT_DATE AND frequency = 'Never') \n" +
                "\t\t\t\t\t\tOR (start_date <= CURRENT_DATE \n" +
                "\t\t\t\t\t\t\tAND (\n" +
                "\t\t\t\t\t\t\t\t\tfrequency = 'Every day'\n" +
                "\t\t\t\t\t\t\t\tOR (frequency = 'Every week' AND start_weekday = ?)\n" +
                "\t\t\t\t\t\t\t\tOR (frequency = 'Every weekdays' AND ?<='5' AND ?>='1')\n" +
                "\t\t\t\t\t\t\t\tOR (frequency = 'Every month' AND  substr(custom_rule.start_date,9,2) = substr(CURRENT_DATE,9,2) )\n" +
                "\t\t\t\t\t\t\t\tOR (frequency = 'Every year' AND  substr(custom_rule.start_date,6,5) =  substr(CURRENT_DATE,6,5))\n" +
                "\t\t\t\t\t\t\t)\n" +
                "\t\t\t\t\t\t)\n" +
                "\t\t\t\t\t  )\n" +
                "\t\t\t\t\t\tAND (start_time >= ? AND start_time <= ?) GROUP BY Item.EPC, name";

        int currentHOUR = currentTime.get(Calendar.HOUR_OF_DAY);
        int currentMIN = currentTime.get(Calendar.MINUTE);
//        String[] args = {};
        int weirdwkdays = currentTime.get(Calendar.DAY_OF_WEEK);
        String weekdays = "" + (weirdwkdays == 1?"7":weirdwkdays-1);
        String[] args = {weekdays,weekdays,weekdays,timeShift(currentHOUR,currentMIN,-1),timeShift(currentHOUR,currentMIN,+1)};
//        Log.i(TAG_BOOT_EXECUTE_SERVICE,sql);
//        Log.i(TAG_BOOT_EXECUTE_SERVICE,args[0] +" " +args[1]);

        result.putAll(customRulesByCondition(sql,args));
//        Log.i(TAG_BOOT_EXECUTE_SERVICE,""+result.size());

//        sql = "SELECT name, Item.EPC, classID, in_bag FROM custom_rule INNER JOIN Item " +
//                "ON Item.EPC = custom_rule.EPC " +
//                "WHERE (start_Date = CURRENT_DATE AND (start_time >= ? AND start_time <= ?)" +
//                "AND frequency = 'Never'  COLLATE NOCASE )";


//        Cursor custom_ruleRes = db.rawQuery(sql,args);

        return result;
    }


    private Map<String,String> customRulesByCondition(String sql, String[] args){
        HashMap<String,String> result = new HashMap<>();

        if(!openDatabase())
            return null;
        if(!db.isOpen())
            return null;

        Cursor custom_ruleRes = db.rawQuery(sql,args);
        Log.i(TAG_BOOT_EXECUTE_SERVICE,"number of results: " + custom_ruleRes.getCount());

        while(custom_ruleRes.moveToNext()){
            String name = custom_ruleRes.getString(custom_ruleRes.getColumnIndex("name"));
            String epc = custom_ruleRes.getString(custom_ruleRes.getColumnIndex("EPC"));

            Log.i(TAG_BOOT_EXECUTE_SERVICE,name);
            if(!result.containsKey(epc))
                result.put(epc,name);
        }
        custom_ruleRes.close();
        closeDatabase();
        return result;
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
        system_ruleRes.close();
        Log.d(TAG_BOOT_EXECUTE_SERVICE,temp);
        closeDatabase();
    }
}
