package com.example.vb_v0.utilClass.network;

import android.content.Context;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public class RequestQueueSingleton {
    private static RequestQueueSingleton instance;
    private RequestQueue requestQueue;
    private static Context ctx;

    private RequestQueueSingleton(Context context){
        ctx = context;
        requestQueue = getRequestQueue();
    }

    public static synchronized RequestQueueSingleton getInstance(Context context){
        Log.d("BOOT_BROADCAST_SERVICE","get instance of requestQueueSingleton");
        if(instance == null){
            instance = new RequestQueueSingleton(context);
        }
        return instance;
    }

    public RequestQueue getRequestQueue(){
        if(requestQueue == null){
            requestQueue = Volley.newRequestQueue(ctx.getApplicationContext());
        }
        return requestQueue;
    }

    public <T> Request<T> addToRequestQueue(Request<T> req){
//        Log.d("BOOT_BROADCAST_SERVICE","added: " + req.toString());
        getRequestQueue().add(req);
        return req;
    }

}
