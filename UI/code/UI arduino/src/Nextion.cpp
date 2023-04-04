#include "Nextion.h"
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

void textField(int component, const char* value, const char* field){

if(field == "text"){
  Serial.print("t");
  Serial.print(component);
  Serial.print(".txt=\"");
  Serial.print(value);
  Serial.print("\"");
  terminate();
}else if(field == "color"){
  Serial.print("t");
  Serial.print(component);
  Serial.print(".bco=");
  Serial.print(value);
  terminate();
}
}