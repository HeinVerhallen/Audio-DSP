// Button.h

#ifndef _BUTTON_h
#define _BUTTON_h

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

class Button {
public:
	Button(int pin);
	bool debounce();

private:
	int btnPin, state, pState;
	unsigned long delay, temp;

};

#endif

