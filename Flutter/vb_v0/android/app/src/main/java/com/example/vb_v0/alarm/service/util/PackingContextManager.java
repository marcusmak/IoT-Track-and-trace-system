package com.example.vb_v0.alarm.service.util;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

import java.util.Date;

//Time
//weather
//location
//event
public class PackingContextManager {
    public WeatherInfoManager weatherInfoManager;
    public GeoInfoManager geoInfoManager;
    public Context context;

    public class PackingContext{
        public Date time;
        public WeatherInfoManager.WeatherInfo weatherInfo;
        public GeoInfoManager.GeoInfo geoInfo;
//        public EventInfo eventInfo;

        PackingContext(){
            time = new Date();
            weatherInfo = getCurrentWeather();
            geoInfo = geoInfoManager.getLastGeoInfo();
            if(geoInfo != null && (geoInfo.update_timestamp - System.currentTimeMillis()/1000)/60 > 15){
                geoInfoManager.getCurrentGeoInfo();
            }
        }

        PackingContext(Date time, WeatherInfoManager.WeatherInfo weatherInfo, GeoInfoManager.GeoInfo geoInfo){
            this.time = time;
            this.weatherInfo = weatherInfo;
            this.geoInfo = geoInfo;
        }
    }

    String loc = "EX4";
    public PackingContextManager(Context ctx){
        this.context = ctx;
        this.geoInfoManager = GeoInfoManager.getInstance(ctx);
        this.weatherInfoManager = new WeatherInfoManager(ctx);
        Initialize();
    }

    private void Initialize(){
        geoInfoManager.getCurrentGeoInfo();
        weatherInfoManager.fetchDayForecast(1,loc);
    }

    public WeatherInfoManager.WeatherInfo getCurrentWeather(){
        return weatherInfoManager.getCurrentWeather(loc);
    };

    public WeatherInfoManager.WeatherInfo getTodayForecast(){
        return weatherInfoManager.getTodayForecast(loc);
    };

    public PackingContext getCurrentPC(){
        Log.i("BOOT_PC_MANAGER","getting current pc");
        return new PackingContext();
    }

}
