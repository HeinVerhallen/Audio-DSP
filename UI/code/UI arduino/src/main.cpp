#include <Arduino.h>
#include "button.h"
#include "Nextion.h"

#define white "WHITE"
#define black "BLACK"
#define blue "BLUE"
#define gray "50712"

#define text 0
#define backcolor 1

//page defenition
#define homeScreen 0
#define signalRouting 1
#define effects 2
#define presets 3
#define channelRouting 4
#define sourceSelect 5
#define linkChannels 6
#define gain 7
#define effectLoop 8
#define equalizer 9
#define back 10
#define select 11

//function defenition
#define dropdown 100
#define RCA1 101
#define RCA2 102
#define TRS1 103
#define TRS2 104
#define save 105

Button* S1 = new Button(2);
Button* S2 = new Button(3);
Button* S3 = new Button(4);

const char* channels[6] = {"Channel 1", "Channel 2","Channel 3", "Channel 4","Channel 5", "Channel 6"};

const char* objects[10][6] = { 																//array for all clickable objects on the active page.
	{"b0","b1","b2"}, 									//page 0 homeScreen
	{"b0","b1","b2"}, 									//page 1 signalRouting
	{"b0","t2","b1","b2", "b3"}, 				//page 2 effects
	{"b0",}, 														//page 3 presets
	{"b0",}, 														//page 4 channelRouting
	{"b0","b1","b2","b3","b4","b5",}, 	//page 5 sourceSelect
	{"b0",}, 														//page 6 linkChannels
	{"b0",}, 														//page 7 gain
	{"b0",}, 														//page 8 effectLoop
	{"b0",}, 														//page 9 equalizer
};

	const int functions[10][7] = {
		{signalRouting,effects,presets,0,0,0,3},				//page 0 homeScreen
		{homeScreen,sourceSelect,channelRouting,0,0,0,3},			//page 1 signalRouting
		{homeScreen,dropdown,gain,effectLoop,equalizer,0,5},	//page 2 effects
		{homeScreen,0,0,0,0,0,1},															//page 3 presets
		{signalRouting,0,0,0,0,0,1},															//page 4 channelRouting
		{signalRouting,RCA1,TRS1,RCA2,TRS2,save,6,},							//page 5 sourceSelect
		{channelRouting,0,0,0,0,0,1},															//page 6 linkChannels
		{effects,0,0,0,0,0,1},															//page 7 gain
		{effects,0,0,0,0,0,1},															//page 8 effectLoop
		{effects,0,0,0,0,0,1},															//page 9 equalizer
	};

	int16_t state = 0;
	int16_t currentPage = 0;
	int16_t highlite = 0;
	int16_t lastHighlite = 0;
	int16_t navMenu = 1;

void update(){
	changeParameter(objects[currentPage][lastHighlite], gray, backcolor);
	changeParameter(objects[currentPage][highlite], blue, backcolor);
	lastHighlite = highlite;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
	gotoPage(currentPage);
	update();
}

void updatePage(int newPage){
	currentPage = newPage;
	highlite = 0;
	gotoPage(currentPage);
	update();
}

//Function: create a dropdown menu to select between channels
//Inputs: toggle - a boolean to activate or deactivate the dropdown menu
//        active – the current active option as an integer index
//Outputs: -
void channelSelect(int16_t toggle, int16_t active){
  static int previous = 0;

  if(toggle){                                                     //activate or update the dropdown list
    for(uint16_t i = 0; i<sizeof(channels)/sizeof(const char*); i++){  //loop through every option in the dropdown list
      textField(i+2, channels[i], text);                        //show all options on the screen
    }
    textField(previous+2, white, backcolor);                        //dehighlite the previous selected option
    textField(active+2, blue, backcolor);                           //highlite the new selected option
  } else{                                                         //deactivate the dropdown list
    for(uint16_t i = 0; i<sizeof(channels)/sizeof(const char*); i++){  //loop through every option in the dropdown list
      if(i==0)
        textField(i+2, channels[active], text);                 //show the active option on the screen
      else
        textField(i+2, "", text);                               //make the rest empty

      textField(i+2, white, backcolor);                             //set all background colors to neutral
    }
  }
  previous = active;                                              //upate the previous active option
}

void loop() {
	static int16_t activeOption = 0;
  if(S1->debounce()){
		int function = functions[currentPage][highlite];//get the function associated with the selected object
		if(function < back){														//go to the selected page
			updatePage(function);
		}else if(function == dropdown){	//Something was selected
		static int state = 0;
		state = !state;
			channelSelect(state,0);
		}
  }
  if(S2->debounce() == 1){
		if(navMenu){
			highlite= (highlite + 1) % (functions[currentPage][6]);
			update();
		}else{
			activeOption = (activeOption+1)%(sizeof(channels)/sizeof(channels[0]));
			channelSelect(state, activeOption);
		}
	}
  if(S3->debounce()){
		if(navMenu){
			highlite = (highlite == 0) ? functions[currentPage][6]-1: highlite-1;
			update();
		}else {
			activeOption = (activeOption = 0) ? sizeof(channels)/sizeof(channels[0])-1 : activeOption-1;
			channelSelect(state, activeOption);
		}
  }
}


//Gather all information from the DSP controller
//Send all information to the screen
//Create a Function/procedure to load page (meaning all clickable objects in  objects array with their function)