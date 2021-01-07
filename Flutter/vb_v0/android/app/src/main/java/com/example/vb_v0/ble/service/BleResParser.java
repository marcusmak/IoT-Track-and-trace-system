package com.example.vb_v0.ble.service;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.Log;

public class BleResParser {
    private static byte[] getBtyes(byte[] input, int start, int len){
        byte[] result = new byte [len];
        if(start + len < input.length)
            for(int i = 0; i< len; ++i){
                result[i] = input[i+start];
            }
        return result;
    }
    public static List<String> parse2BleRes(byte[] res){
        List<SingleRfidRes> listOfCustomClass = parseRes(res);
        Set<String> result = new HashSet<>();
        if( listOfCustomClass != null){
            for(SingleRfidRes element:listOfCustomClass) {
                result.add(ByteHelper.bytesToHex(element.EPC));
//                Map<String, String> map = new HashMap<>();
//                map.put("RSSI", String.valueOf(element.RSSI));
//                map.put("EPC", ByteHelper.bytesToHex(element.EPC));
//                result.add(map);
            }
            return new ArrayList<>(result);
        };
        return null;
    }
    public static List<SingleRfidRes> parseRes(byte[] res){
        List<SingleRfidRes> result = new ArrayList<>();
        for(int i = 0; i < res.length; ++i){
            if(res[i] == (byte) 0xBB){
                if(res[i+1] == (byte) 0x02) {
                    Log.d("BleResParser", "start of a new rfid res");
                    result.add(new SingleRfidRes(getBtyes(res, i, 24)));
                }
            }
        }
        if(result.isEmpty())
            return null;
        return result;
    }
    static public class SingleRfidRes{
        private int RSSI;
        private byte[] PC = new byte[2];
        private byte[] EPC = new byte[12];
        private byte[] CRC = new byte[2];
        public SingleRfidRes(byte[] res) {
            RSSI  = res[5];
            PC[0] = res[6];
            PC[1] = res[7];
            for (int i = 0; i < 12; ++i)
                EPC[i] = res[8 + i];
            CRC[0] = res[20];
            CRC[1] = res[21];
        }

        @Override
        public String toString() {
            return "SingleRfidRes{" +
                    "RSSI=" + RSSI +
                    ", PC="  + ByteHelper.bytesToHex(PC) +
                    ", EPC=" + ByteHelper.bytesToHex(EPC) +
                    ", CRC=" + ByteHelper.bytesToHex(CRC) +
                    '}';
        }
    }
}
