#include <Arduino.h>
#include "BluetoothSerial.h"
#include "OPCODE.h"
extern bool readerOn;

//external resources
bool startReader(int timeout);
extern BluetoothSerial SerialBT;
void initializeReader();
int scan_tags(int duration);
extern const int S_PIN;
extern String operand,opcode;



bool parseInput(byte cmd[], int len) {
  if (cmd[0] == ' ')
    return false;

  byte oc[16];
  byte od[256];
  int i = 0;
  int oc_size;
  while (i < 15) {
    oc[i] = cmd[i];
    if (cmd[++i] == ' ') {
      oc[i] = 0;
      break;
    }
    if (i == len || i == 15)
      return false;
  }
  oc_size = i;
  //  Serial.print("oc_size");
  //  Serial.println(oc_size);
  ++i;
  int j;
  for (j = 0; j < len - oc_size - 1 ; ++i, ++j) {
    //    Serial.println(i);
    od[j] = cmd[i];
    if (j == 255)
      return false;
  }
  if (j == 0)
    return false;
  od[j] = 0;

  opcode = String((char*)oc);
  operand = String((char*)od);
  return true;
}
int parseOpcode (String ocd) {
  if (ocd == "open") {
    return OPEN;
  }
  if (ocd == "poll") {
    return POLL;
  }
  if (ocd == "close" ) {
    return CLOSE ;
  }
  return -1;
}

bool Execute(String ocd, String opd) {
  Serial.print("ocode> ");
  Serial.println(ocd);
  Serial.print("operand> ");
  Serial.println(opd);
  Serial.println("\n");

  switch (parseOpcode(ocd)) {
    case OPEN:
      SerialBT.print(opd);
      SerialBT.println(" opening......");
      if (opd == "reader") {
        if (startReader(5000)) {
          readerOn = true;
          initializeReader();

        }

      }
      break;
    case POLL:
      if (readerOn) {
        int temp = scan_tags(5000);
        Serial.print("Detected ");
        Serial.print(temp);
        Serial.println(" times.");
      }
      break;
    case CLOSE:
      SerialBT.print(opd);
      SerialBT.println(" closing......");
      if (opd == "reader") {
        digitalWrite(S_PIN, LOW);
        readerOn = false;
      }
      return true;
    default:
      SerialBT.print("\'");
      SerialBT.print(ocd);
      SerialBT.println("\' is not recognized as an internal or external command");
      return false;
  }

  opcode = "";
  operand = "";
  return false;
}


