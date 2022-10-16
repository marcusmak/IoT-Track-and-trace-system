#include <Arduino.h>
#include "BluetoothSerial.h"
#include "OPCODE.h"
#define RXD2 16
#define TXD2 17
extern const int S_PIN = 19;


#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

//external resource
extern bool parseInput(byte[], int);
extern bool Execute(String, String);
extern void debug();

BluetoothSerial SerialBT;
void initializeBT() {
  SerialBT.begin("ESP32test"); //Bluetooth device name
}

bool readerOn = false;
byte cmd[256];
int ptr = 0;
String opcode;
String operand;
byte single_polling_cmd[] = {0xBB, 0x00, 0x22, 0x00, 0x00, 0x22, 0x7E};

void setup() {
  Serial.begin(115200);
  Serial2.begin(115200, SERIAL_8N1, RXD2, TXD2);
  pinMode(S_PIN, OUTPUT);
  initializeBT();
}

void loop() {
  while (SerialBT.available()) {
    cmd[ptr] = SerialBT.read();
    if (cmd[ptr] == 0 || cmd[ptr] == '\n') {
      SerialBT.println((char*)cmd);
      if (parseInput(cmd, ptr)) {
        Execute(opcode, operand);
      } else {
        SerialBT.println("Cannot parse the command!");
      };
      ptr = 0;
    } else {
      ++ptr;
    }
  }

  while (Serial.available()) {
    cmd[ptr] = Serial.read();
    if (cmd[ptr] == 0 || cmd[ptr] == '\n') {
      Serial.println((char*)cmd);
      if (parseInput(cmd, ptr)) {
        Execute(opcode, operand);
      } else {
        Serial.println("Cannot parse the command!");
      };
      ptr = 0;
    } else {
      ++ptr;
    }
  }

  if(readerOn) {
    Serial2.write(single_polling_cmd, sizeof(single_polling_cmd));
    delay(20);
    if(Serial2.available()){
      debug();
    }
    delay(500);
  }
}


void Print(byte printText[], int len) {
  Serial.println("print byte");
  for (int i = 0; i < len; ++i) {
    //    if(printText[i])
    Serial.print(printText[i], HEX);
    Serial.print(" ");
    //    else{
    //      Serial.print("0");
    //    }
  }
  Serial.println();
}