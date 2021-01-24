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
    public static ArrayList<String> parse2BleRes(byte[] res){
        ArrayList<SingleRfidRes> listOfCustomClass = parseRes(res);
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
    public static ArrayList<SingleRfidRes> parseRes(byte[] res){
        ArrayList<SingleRfidRes> result = new ArrayList<>();
        for(int i = 0; i < res.length - SingleRfidRes.LENGTH; ++i){
            if(res[i] == (byte) 0xBB){
                if(res[i+1] == (byte) 0x02 && res[i+23] == (byte) 0x7E) {
                    Log.d("BleResParser", "start of a new rfid res");
                    SingleRfidRes temp = new SingleRfidRes(getBtyes(res, i, 24));
                    Log.d("BleResParser", ByteHelper.bytesToHex(temp.EPC,true));
                    if(temp.EPC[0] == (byte) 0xE2)
                        result.add(temp);
                }
            }
        }
        if(result.isEmpty())
            return null;
        return result;
    }
    static public class SingleRfidRes{
        public static final int LENGTH = 24;
        private int RSSI;
        private byte[] PC = new byte[2];
        private byte[] EPC = new byte[12];
        private byte[] CRC = new byte[2];
        private byte checksum;

        public SingleRfidRes(byte[] res) {
            RSSI  = res[5];
            PC[0] = res[6];
            PC[1] = res[7];
            for (int i = 0; i < 12; ++i)
                EPC[i] = res[8 + i];
            CRC[0] = res[20];
            CRC[1] = res[21];
            checksum = res[LENGTH-1];
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
