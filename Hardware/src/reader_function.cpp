//byte single_polling_cmd[] = {0xBB, 0x00, 0x22, 0x00, 0x00, 0x22, 0x7E};
#include <Arduino.h>
#include "BluetoothSerial.h"

//external resource
void clearVM5GBBuffer();
void catchRes(int);
extern BluetoothSerial SerialBT;

const byte multi_polling_cmd[] = {0xBB,  0x00,  0x27,  0x00,  0x03,  0x22,  0x27,  0x10, 0x83,  0x7E};
byte bufferFrames[256] ;
int head = 0 , tail = 0;
extern const byte info[] = {0xBB , 0x00, 0x03, 0x00, 0x01, 0x02, 0x06, 0x7E};

//scan with timeout
int scan_tags(int timeout) {
  unsigned long start = millis();
  int num = 0;
  Serial.print("Scanning...");
  do {
    clearVM5GBBuffer();
    tail = head;
    Serial.print(".");
    Serial2.write(multi_polling_cmd, sizeof(multi_polling_cmd));
    catchRes(200);
    if (bufferFrames[head + 1] == 0x02)
      ++num;
  } while (millis() - start < timeout);
  Serial.println();
  return num;
}

void debug() {
  while (Serial2.available()) {
    SerialBT.print(Serial2.read(), HEX);
    SerialBT.print(" ");
  }
  SerialBT.println();
}