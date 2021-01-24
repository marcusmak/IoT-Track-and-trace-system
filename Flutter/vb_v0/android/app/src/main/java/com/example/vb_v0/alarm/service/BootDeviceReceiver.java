package com.example.vb_v0.alarm.service;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.example.vb_v0.R;


public class BootDeviceReceiver extends BroadcastReceiver {

    private static final String TAG_BOOT_BROADCAST_RECEIVER = "BOOT_BROADCAST_RECEIVER";
    private AlarmManager alarmManager;
    private PendingIntent pendingIntent;
    private Context context;
    public static boolean isRepeating = false;
    @Override
    public void onReceive(Context context, Intent intent) {
        this.context = context;
        String action = intent.getAction();

        String message = "BootDeviceReceiver onReceive, action is " + action;

        Toast.makeText(context, message, Toast.LENGTH_LONG).show();

        Log.d(TAG_BOOT_BROADCAST_RECEIVER, message);

        if(Intent.ACTION_BOOT_COMPLETED.equals(action) || action.equalsIgnoreCase("DEBUG_ALARM_SERVICE"))
        {
            SharedPreferences alarmServicePre = context.getSharedPreferences(context.getString(R.string.package_name),Context.MODE_PRIVATE);
            if(!alarmServicePre.contains("onBootTrigger")){
                SharedPreferences.Editor alarmServicePreEditor = alarmServicePre.edit();
                alarmServicePreEditor.putBoolean("onBootTrigger", true);
                alarmServicePreEditor.apply();
            }

            if(alarmServicePre.getBoolean("onBootTrigger", true)) {
                startServiceByAlarm(context);
            }

        }else if(action.equalsIgnoreCase("ACTION_CANCEL_ALARM")){
            cancelServiceByAlarm();
        };
    }

    /* Start RunAfterBootService service directly and invoke the service every 10 seconds. */
    private void startServiceDirectly(Context context)
    {
        try {
            while (true) {
                String message = "BootDeviceReceiver onReceive start service directly.";

                Toast.makeText(context, message, Toast.LENGTH_LONG).show();

                Log.d(TAG_BOOT_BROADCAST_RECEIVER, message);

                // This intent is used to start background service. The same service will be invoked for each invoke in the loop.
                Intent startServiceIntent = new Intent(context, RunAfterBootService.class);
                context.startService(startServiceIntent);

                // Current thread will sleep one second.
                Thread.sleep(10000);
            }
        }catch(InterruptedException ex)
        {
            Log.e(TAG_BOOT_BROADCAST_RECEIVER, ex.getMessage(), ex);
        }
    }

    /* Create an repeat Alarm that will invoke the background service for each execution time.
     * The interval time can be specified by your self.  */
    private void startServiceByAlarm(Context context)
    {
        // Get alarm manager.
        alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);

        // Create intent to invoke the background service.
        Intent intent = new Intent(context, RunAfterBootService.class);
        pendingIntent = PendingIntent.getService(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        long startTime = System.currentTimeMillis();
        long intervalTime =5*1000;

        String message = "Start service use repeat alarm. ";

//      Toast.makeText(context, message, Toast.LENGTH_LONG).show();

        Log.d(TAG_BOOT_BROADCAST_RECEIVER, message);

        // Create repeat alarm.
        if(!isRepeating) {
            alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, startTime, intervalTime, pendingIntent);
            isRepeating = true;
        }

    }

    private void cancelServiceByAlarm(){
        // Cancel service
        if(alarmManager != null) {
            alarmManager.cancel(pendingIntent);
            Intent intent = new Intent(context, RunAfterBootService.class);
            context.stopService(intent);
            alarmManager = null;
            isRepeating = false;
        }
    }



}