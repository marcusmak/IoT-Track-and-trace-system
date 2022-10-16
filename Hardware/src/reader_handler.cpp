#include <Arduino.h>
const byte startByte = 0xBB;
const byte endByte = 0x7E;

const byte EURegion[] = {0xBB,  0x00, 0x07, 0x00, 0x01, 0x03, 0x0B, 0x7E};
const byte signalStrength26dbm[] = {0xBB, 0x00, 0xB6, 0x00, 0x02, 0x0A, 0x28, 0xEA, 0x7E };
const byte freq860MHZ[] = {0xBB, 0x00, 0xAB, 0x00, 0x01, 0x00, 0xAC, 0x7E };

//external resource
extern byte bufferFrames[];
extern const int S_PIN;
extern int tail, head;
extern const byte info[];
bool serialFlag = false;


void setFrequencyVM5GB() {
  Serial.println("Setting region to EU");
  Serial2.write(EURegion, sizeof(EURegion));
  Serial.println("Setting frequency to 860.125MHz");
  Serial2.write(freq860MHZ, sizeof(freq860MHZ));
}

void setSignalStrengthVM5GB() {
  Serial.println("Setting signal strength to 26dbm");
  Serial2.write(signalStrength26dbm, sizeof(signalStrength26dbm));
}

void clearVM5GBBuffer() {
  while (Serial2.available()) {
    Serial2.read();
    delay(1);
  }
}

void initializeReader() {
  setFrequencyVM5GB();
  setSignalStrengthVM5GB();
  delay(20);
  clearVM5GBBuffer();
}


bool catchRes(int timeout) {
  unsigned long timeoutStart = millis();
  //  Serial.print("serial2 length: ");
  //  Serial.println(len);

  while (millis() - timeoutStart < timeout) {
    if (!Serial2.available())
      continue;
    byte temp = Serial2.read();
    if (serialFlag) {
      bufferFrames[tail++] = temp;
      if (temp == endByte) {
//        Print(bufferFrames, tail - head);
//        Serial.println(head);
//        Serial.println(tail);
        serialFlag = false;
//        Serial.print("It takes ");
//        Serial.print(millis() - timeoutStart);
//        Serial.println("ms to get the response");
        return true;
      }

    } else if (temp == startByte) {
      serialFlag = true;
      bufferFrames[tail++] = temp;

    }
  }

  Serial.println("timeout");
  return false;
}

bool startReader(int timeout) {
  unsigned long timeoutStart = millis();
  digitalWrite (S_PIN, HIGH );
  clearVM5GBBuffer();
  tail = head;
  while (!catchRes(200)) {
    if (millis() - timeoutStart > timeout) {
      Serial.println("timeout");
      return false;
    }
    Serial2.write(info, sizeof((char*)info));
    delay(100);
  }
  clearVM5GBBuffer();
  Serial.print("It takes ");
  Serial.print(millis() - timeoutStart);
  Serial.println("ms to boot the reader");
  return true;
}
