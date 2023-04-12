#include <Arduino.h>
#include "button.h"
#include "Nextion.h"

#define empty "WHITE"
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

const char* objects[10][6] = {		//array for all clickable objects on the active page.
	{"b0","b1","b2"}, 			//page 0 homeScreen
	{"b0","b1","b2"}, 			//page 1 signalRouting
	{"b0","t1","b1","b2", "b3"}, 		//page 2 effects
	{"b0",}, 					//page 3 presets
	{"b0",}, 					//page 4 channelRouting
	{"b0","b1","b2","b3","b4","b5",}, 	//page 5 sourceSelect
	{"b0",}, 					//page 6 linkChannels
	{"b0",}, 					//page 7 gain
	{"b0",}, 					//page 8 effectLoop
	{"b0",}, 					//page 9 equalizer
};

	const int functions[10][7] = {
		{signalRouting,effects,presets,0,0,0,3},			//page 0 homeScreen
		{homeScreen,sourceSelect,channelRouting,0,0,0,3},	//page 1 signalRouting
		{homeScreen,dropdown,gain,effectLoop,equalizer,0,5},	//page 2 effects
		{homeScreen,0,0,0,0,0,1},					//page 3 presets
		{signalRouting,0,0,0,0,0,1},					//page 4 channelRouting
		{signalRouting,RCA1,TRS1,RCA2,TRS2,save,6,},		//page 5 sourceSelect
		{channelRouting,0,0,0,0,0,1},					//page 6 linkChannels
		{effects,0,0,0,0,0,1},						//page 7 gain
		{effects,0,0,0,0,0,1},						//page 8 effectLoop
		{effects,0,0,0,0,0,1},						//page 9 equalizer
	};

	const int dropdown1[] = {
		
	};

	int8_t state = 0;
	int8_t currentPage = 0;
	int8_t highlight = 0;
	int8_t lasthighlight = 0;
	int8_t navMenu = 1;
	int8_t activeChannel = 0;

void update(){
	changeParameter(objects[currentPage][lasthighlight], gray, backcolor);
	changeParameter(objects[currentPage][highlight], blue, backcolor);
	lasthighlight = highlight;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
	gotoPage(currentPage);
	update();
}

void updatePage(int newPage){
	currentPage = newPage;
	highlight = 0;
	gotoPage(currentPage);
	update();
}

//Function: create a dropdown menu to select between channels
//Inputs: toggle - a boolean to activate or deactivate the dropdown menu
//        active – the current active option as an integer index
//Outputs: -
void channelSelect(int16_t toggle, int16_t active){
  	static int previous = 0;
	static int on = 0;

  	if(toggle){
		on=!on;
		if(on){											//activate or update the dropdown list
    			for(uint16_t i = 1; i<sizeof(channels)/sizeof(const char*)+1; i++){ //loop through every option in the dropdown list
      			textField(i, channels[i], text);					//show all options on the screen
    			}
		}else{
			for(uint16_t i = 1; i<sizeof(channels)/sizeof(const char*)+1; i++){
				if(i==1)
					changeParameter(objects[2][i],channels[activeChannel],0);
				else
					textField(i,"",0);
			}
			textField(previous, empty, 1);
		}
  	} else{											//deactivate the dropdown list
    		textField(previous+1, empty, backcolor);					//dehighlight the previous selected option
    		textField(active+1, blue, backcolor);					//highlight the new selected option
  	}
  	previous = active;                                              		//upate the previous active option
}

void loop() {
	if(S1->debounce()){
		int function = functions[currentPage][highlight];	//get the function associated with the selected object
		if(function < back){						//go to the selected page
			updatePage(function);
		}else if(function == dropdown){				//Something was selected
			navMenu = !navMenu;
			channelSelect(!navMenu,0);
		}
  	}
  	if(S2->debounce() == 1){
		if(navMenu){
			highlight= (highlight + 1) % (functions[currentPage][6]);
			update();
		}else{
			activeChannel = (activeChannel+1)%(sizeof(channels)/sizeof(channels[0]));
			channelSelect(navMenu, activeChannel);
		}
	}
  	if(S3->debounce()){
		if(navMenu){
			highlight = (highlight == 0) ? functions[currentPage][6]-1: highlight-1;
			update();
		}else {
			activeChannel = (activeChannel = 1) ? sizeof(channels)/sizeof(channels[0])-1 : activeChannel-1;
			channelSelect(navMenu, activeChannel);
		}
  	}
}//*/


//Gather all information from the DSP controller
//Send all information to the screen
//Create a Function/procedure to load page (meaning all clickable objects in  objects array with their function)