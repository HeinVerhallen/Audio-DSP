#include <Arduino.h>

void terminate(){
  Serial.write(0xff);
  Serial.write(0xff);
  Serial.write(0xff);
}

void gotoPage(uint16_t page){
  Serial.print("page ");
  Serial.print(page);
  terminate();
}

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
}

int16_t state = 0;

void loop() {
  // put your main code here, to run repeatedly:
  gotoPage(state);
  state=(state+1)%7;
  delay(1000);
}

