// 
// 
// 

#include "Button.h"
#include <Arduino.h>;

Button::Button(int pin) {
    btnPin = pin;
    delay = 50;
    state = 0;
    pState = 0;
}

bool Button::debounce() {
    // read the state of the switch into a local variable:
    int reading = digitalRead(btnPin);
    bool isTrue = false;

    // If the switch changed, due to noise or pressing:
    if (reading != pState) {
        // reset the debouncing timer
        temp = millis();
    }

    if ((millis() - temp) > delay) {
        // whatever the reading is at, it's been there for longer than the debounce
        // delay, so take it as the actual current state:

        // if the button state has changed:
        if (reading != state) {
            state = reading;

            // only toggle the LED if the new button state is HIGH
            if (state == HIGH) {
                isTrue = true;
            }
        }
    }
    // save the reading. Next time through the loop, it'll be the lastButtonState:
    pState = reading;
    return isTrue;
}