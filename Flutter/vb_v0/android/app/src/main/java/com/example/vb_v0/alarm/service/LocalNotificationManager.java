package com.example.vb_v0.alarm.service;

import android.app.NotificationChannel;
import android.app.NotificationManager;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.example.vb_v0.R;

import java.util.List;

import static androidx.core.content.ContextCompat.getSystemService;

public class LocalNotificationManager {
    private static final String TAG_LOCALNOTIFICATIONMANAGER = "BOOT_LOCAL_TAG";
    NotificationCompat.Builder builder;
    NotificationManager notificationManager;
    Context context;
    String CHANNEL_ID;
    int notificationId = 0;


    public LocalNotificationManager(Context context, String CHANNEL_ID){

        Log.i(TAG_LOCALNOTIFICATIONMANAGER,"constructor");
        this.CHANNEL_ID = CHANNEL_ID;
        this.context = context;
        createNotificationChannel();


    }


    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = context.getResources().getString(R.string.channel_name);
            String description = context.getResources().getString(R.string.channel_description);
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            notificationManager = getSystemService(context,NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }else{
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        }
    }

    public void showNotification(List<String> reminderString, boolean bring){
        if(bring) {
            builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(R.drawable.notification_icon)
                    .setContentTitle("Remember to bring")
                    .setContentText("You may forget to bring: " + reminderString.toString())
                    .setStyle(new NotificationCompat.BigTextStyle()
                            .bigText("Much longer text that cannot fit one line..."))
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setCategory(NotificationCompat.CATEGORY_REMINDER);
        }else{
            builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(R.drawable.notification_icon)
                    .setContentTitle("Remember to use")
                    .setContentText("You may need to use: " + reminderString.toString())
                    .setStyle(new NotificationCompat.BigTextStyle()
                            .bigText("Much longer text that cannot fit one line..."))
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setCategory(NotificationCompat.CATEGORY_REMINDER);
        }
        notificationManager.notify(notificationId++, builder.build());
        Log.i(TAG_LOCALNOTIFICATIONMANAGER,"build" + notificationId);
    }

}
