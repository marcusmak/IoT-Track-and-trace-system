package com.example.vb_v0.alarm.service.util;

import android.content.Context;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.RequestFuture;
import com.example.vb_v0.utilClass.network.RequestQueueSingleton;
import com.google.gson.JsonObject;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import io.flutter.Log;

public class WeatherInfoManager {
    public Context context;
    public static String TAG_BOOT_EXECUTE_SERVICE = "BOOT_WEATHER_MANAGER";
    final CountDownLatch countDownLatch = new CountDownLatch(1);
    public Date lastUpdate;
    public WeatherInfo currentWeather;
    public JSONObject weatherLocation;
    public WeatherInfo todayForecast;
    public ArrayList<WeatherInfo> hourForecast;
    public JSONArray alerts;
    public int days;
    public HashMap<Date,JSONObject> daysForecast;

    public class WeatherInfo{
        public Date date;
        public int uv;
        public Double temp_c;
        public String weatherType;
        public int pollution;
        public Double precip_mm;
        public Double cloud;

        WeatherInfo(JSONObject current) throws JSONException {

            weatherType = current.getJSONObject("condition").getString("text");
            if(current.has("last_updated_epoch")){
                date = new Date(current.getLong("last_updated_epoch")*1000);
            }else if (current.has("time_epoch")){
                date = new Date(current.getLong("time_epoch")*1000);
            }
            if(current.has("temp_c"))
                temp_c = current.getDouble("temp_c");
            else if(current.has("avgtemp_c"))
                temp_c = current.getDouble("avgtemp_c");

            // is_day = current.getInt("is_day");
            if(current.has("uv")){
                uv = current.getInt("uv");
            }else{
                uv = -1;
            }

            if(current.has("cloud"))
                cloud = current.getDouble("cloud");
            else
                cloud = -1.0;

            if(current.has("precip_mm"))
                precip_mm = current.getDouble("precip_mm");
            else if(current.has("totalprecip_mm"))
                precip_mm = current.getDouble("totalprecip_mm");

            pollution = -1;

        }

        @Override
        public String toString() {
            return "WeatherInfo{" +
                    "date=" + date +
                    ", uv=" + uv +
                    ", temp_c=" + temp_c +
                    ", weatherType='" + weatherType + '\'' +
                    ", pollution=" + pollution +
                    ", precip_mm=" + precip_mm +
                    ", cloud=" + cloud +
                    '}';
        }
    }

    @Override
    public String toString() {
        return "WeatherInfoManager{" +
                "context=" + context +
                ", lastUpdate=" + lastUpdate +
                ", currentWeather=" + currentWeather +
                ", weatherLocation=" + weatherLocation +
                ", todayForecast=" + todayForecast +
                ", hourForecast=" + hourForecast +
                ", alerts=" + alerts +
                ", days=" + days +
                ", daysForecast=" + daysForecast +
                ", fetchingFlag=" + fetchingFlag +
                '}';
    }

    public boolean fetchingFlag = false;

    public WeatherInfoManager(Context context){
        this.context = context;
    }

    public void fetchDayForecast(int numDays, String loc){
        String url = "https://weatherapi-com.p.rapidapi.com/forecast.json?q="+ loc
                        + "&days=" + String.valueOf(numDays);
        RequestFuture<JsonObjectRequest> future = RequestFuture.newFuture();

        Log.d(TAG_BOOT_EXECUTE_SERVICE,url);
        fetchingFlag = true;


        JsonObjectRequest testReq = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                countDownLatch.countDown();
                fetchingFlag = false;
                Log.d(TAG_BOOT_EXECUTE_SERVICE, "onRes()");
                //  Log.d(TAG_BOOT_EXECUTE_SERVICE, response.toString());
                lastUpdate = new Date();

                try {
                    weatherLocation = response.getJSONObject("location");
                    JSONObject current = response.getJSONObject("current");
                    currentWeather = new WeatherInfo(current);
                    if(response.has("alerts")) {
                        alerts = response.getJSONObject("alerts").getJSONArray("alert");
                    }
                    days = numDays;
                    //  forecast = new HashMap<>();
                    JSONArray temp = response.getJSONObject("forecast").getJSONArray("forecastday");
                    JSONObject today = temp.getJSONObject(0);
                    todayForecast = new WeatherInfo(today.getJSONObject("day"));
                    todayForecast.date = new Date(today.getLong("date_epoch") * 1000);

                    JSONArray hours = today.getJSONArray("hour");
                    hourForecast = new ArrayList<>();
                    for (int i = 0; i < hours.length(); i++) {
                        hourForecast.add(new WeatherInfo(hours.getJSONObject(i)));
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                    Log.e(TAG_BOOT_EXECUTE_SERVICE, e.toString());
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                fetchingFlag = false;
                Log.d(TAG_BOOT_EXECUTE_SERVICE, "onErrorRes()");
                Log.e(TAG_BOOT_EXECUTE_SERVICE,error.toString());
                countDownLatch.countDown();
            }
        }){
            @Override
            public Map<String,String> getHeaders() throws AuthFailureError {
                Map<String,String> params = new HashMap<String, String>();
                params.put("x-rapidapi-key","32dc483c9dmshfbadb164cc5117ep1b7fbejsn73ae394c3fd2");
                params.put("x-rapidapi-host", "weatherapi-com.p.rapidapi.com");
                params.put("useQueryString", "true");
                return params;
            }
        };
        try {
            RequestQueueSingleton.getInstance(context.getApplicationContext()).addToRequestQueue(testReq);
        }catch (Exception e){
            fetchingFlag = false;
            countDownLatch.countDown();
        }
//        try {
//            countDownLatch.await(5,TimeUnit.SECONDS);
//        } catch (InterruptedException e) {
//            Log.d(TAG_BOOT_EXECUTE_SERVICE,e.toString());
//        }
//        Log.d(TAG_BOOT_EXECUTE_SERVICE,"info filled");
//        Log.d(TAG_BOOT_EXECUTE_SERVICE,currentWeather.toString());
//        try {
////            JSONObject response = future.get(30, TimeUnit.SECONDS); // this will block
//        } catch (InterruptedException e) {
//            // exception handling
//        } catch (
//        ExecutionException e) {
//            // exception handling
//        }






        Log.d(TAG_BOOT_EXECUTE_SERVICE,"add to queue");

    }




    public WeatherInfo getCurrentWeather(String loc){
        final int hourMiliSec = 3600 *1000;

        if(lastUpdate == null || lastUpdate.before(new Date(System.currentTimeMillis() - hourMiliSec))){
            if(!fetchingFlag){
                fetchDayForecast(1,loc);
            }
        }

        if(lastUpdate != null){
            return currentWeather;
        }

        return null;
    }

    public WeatherInfo getTodayForecast(String loc){
        final int hourMiliSec = 6 * 3600 *1000;

        if(lastUpdate == null || lastUpdate.before(new Date(System.currentTimeMillis() - hourMiliSec))){
            if(!fetchingFlag){
                fetchDayForecast(1,loc);
            }
        }

        if(lastUpdate != null){
            return todayForecast;
        }

        return null;
    }

}
