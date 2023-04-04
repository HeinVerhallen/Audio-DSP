#include <Arduino.h>
#include "button.h"
#include "Nextion.h"

#define white "WHITE"
#define blue "BLUE"

Button* S1 = new Button(2);
Button* S2 = new Button(3);
Button* S3 = new Button(4);

const char* channels[6] = {"Channel 1", "Channel 2","Channel 3", "Channel 4","Channel 5", "Channel 6"};
int16_t state = 0;

//Function: create a dropdown menu to select between channels
//Inputs: toggle - a boolean to activate or deactivate the dropdown menu
//        active

void channelSelect(uint16_t toggle, uint16_t active){
  static int previous = 0;

  if(toggle){                                                     //activate or update the dropdown list
    for(int i = 0; i<sizeof(channels)/sizeof(const char*); i++){  //loop through every option in the dropdown list
      textField(i+2, channels[i], "text");                        //show all options on the screen
    }
    textField(previous+2, white, "color");                        //dehighlite the previous selected option
    textField(active+2, blue, "color");                           //highlite the new selected option
  } else{                                                         //deactivate the dropdown list
    for(int i = 0; i<sizeof(channels)/sizeof(const char*); i++){  //loop through every option in the dropdown list
      if(i==0)
        textField(i+2, channels[active], "text");                 //show the active option on the screen
      else
        textField(i+2, "", "text");                               //make the rest empty

      textField(i+2, white, "color");                             //set all background colors to neutral
    }
  }
  previous = active;                                              //upate the previous active option
}

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  static int active = 0;
  if(S1->debounce()){
    state = !state;
    channelSelect(state, active);
  }
  if(S2->debounce() == 1){
    active=(active+state)%6;
    channelSelect(state, active);
  }

  if(S3->debounce()){
    active=active-state;
    if(active < 0)
      active=5;
    channelSelect(state, active);
  }
}

