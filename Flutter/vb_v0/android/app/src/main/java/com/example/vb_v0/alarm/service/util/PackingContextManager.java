package com.example.vb_v0.alarm.service.util;

import android.content.Context;

import java.util.Date;

//Time
//weather
//location
//event
public class PackingContextManager {
    public WeatherInfoManager weatherInfoManager;
//    public GeoInfoManager geoInfoManager;
    public Context context;
    public class PackingContext{
        public Date time;
        public WeatherInfoManager.WeatherInfo weatherInfo;
//        public GeoInfo geoInfo;
//        public EventInfo eventInfo;
        PackingContext(){
            time = new Date();
            weatherInfo = getCurrentWeather();
        }

        PackingContext(Date time,WeatherInfoManager.WeatherInfo weatherInfo){
            this.time = time;
            this.weatherInfo = weatherInfo;
        }
    }

    String loc = "EX4";
    public PackingContextManager(Context ctx){
        this.context = ctx;
//        this.geoInfoManager = new geoInfoManager(ctx);
        this.weatherInfoManager = new WeatherInfoManager(ctx);
        Initialize();
    }

    private void Initialize(){
//        geoInfo
        weatherInfoManager.fetchDayForecast(1,loc);
    }

    public WeatherInfoManager.WeatherInfo getCurrentWeather(){
        return weatherInfoManager.getCurrentWeather(loc);
    };

    public WeatherInfoManager.WeatherInfo getTodayForecast(){
        return weatherInfoManager.getTodayForecast(loc);
    };

    public PackingContext getCurrentPC(){
        return new PackingContext();
    }

}
