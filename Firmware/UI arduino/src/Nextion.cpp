#include "Nextion.h"
#include <Arduino.h>

void terminate(){
  Serial.write(0xff);
  Serial.write(0xff);
  Serial.write(0xff);
}

void gotoPage(int page){
  Serial.print("page ");
  Serial.print(page);
  terminate();
}

void textField(int component, const char* value, int field){
  if(field == 0){
    Serial.print("t");
    Serial.print(component);
    Serial.print(".txt=\"");
    Serial.print(value);
    Serial.print("\"");
    terminate();
  }else if(field == 1){
    Serial.print("t");
    Serial.print(component);
    Serial.print(".bco=");
    Serial.print(value);
    terminate();
  }
}

void changeParameter(const char* component, const char* value, int field){
  if(field == 0){
    Serial.print(component);
    Serial.print(".txt=\"");
    Serial.print(value);
    Serial.print("\"");
    terminate();
  }else if(field == 1){
    Serial.print(component);
    Serial.print(".bco=");
    Serial.print(value);
    terminate();
  }
}