#include <Arduino.h>
#include "button.h"
#include "Nextion.h"

#define empty "WHITE"
#define black "BLACK"
#define highlighted "BLUE"
#define button "50712"

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

	int8_t currentPage = 0;
	int8_t highlight = 0;
	int8_t lasthighlight = 0;
	int8_t activeChannel = 0;

void update(){
	changeParameter(objects[currentPage][lasthighlight], button, backcolor);
	changeParameter(objects[currentPage][highlight], highlighted, backcolor);
	lasthighlight = highlight;
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
	gotoPage(currentPage);
	update();
}

//Function: load page specific variables
//Inputs: page - an integer which represents the desired page
//Outputs: -
void loadPage(uint8_t page){
	switch (page)
	{
	case 2:
		changeParameter(objects[page][1], channels[activeChannel], text); 
		break;
	case 7:
	case 8: 
	case 9:
		textField(2,channels[activeChannel],text);
		break;
	default:
		return;
		break;
	}
}

//Function: show the next page on the screen
//Inputs: newPage - an integer which represents the desired page
//Outputs: -
void updatePage(int newPage){
	gotoPage(newPage);	//go to the new page
	//loadPage(newPage);	//load page variables
	highlight = 0;		//set the first menu option active
	update();			//update the highlighted option
	currentPage = newPage;	//set the new page as current page
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
		//activate the dropdown list
		if(on){
			//loop through every option in the dropdown list
    			for(uint16_t i = 1; i<=sizeof(channels)/sizeof(const char*); i++){
      			textField(i, channels[i-1], text);
    			}
			//hightlight the active channel
			changeParameter(objects[2][1],empty,backcolor);
			textField(active+1, highlighted, backcolor);
		//deactivate the dropdown list
		}else{
			//clear all dropdown menu options and set the dropdown menu to the selected channel
			for(uint16_t i = 1; i<=sizeof(channels)/sizeof(const char*); i++){
				if(i==1)
					changeParameter(objects[2][i],channels[active],text);
				else
					textField(i,"",0);
			}
			//highlight the dropdown menu
			textField(active+1, empty, backcolor);
			changeParameter(objects[2][1],highlighted, backcolor);
		}
	//deactivate the dropdown list	
  	} else{
		//highlight the new selected option
    		textField(previous+1, empty, backcolor);
    		textField(active+1, highlighted, backcolor);
  	}
	//update the previous active option
  	previous = active;
}

byte buffer[16];
int dataReceived = 0;

void uartReceive(){
	static int index = 0;
	while(Serial.available()){
		byte incoming = Serial.read();
		buffer[index++] = incoming;
		if(incoming == 255 && buffer[index-2]==255 && buffer[index-3]==255){

			index = 0;
			dataReceived = 1;
		}
	}
}

void loop() {
	uartReceive();
	if(dataReceived){
		int command = buffer[0];	
		int page = buffer[1];
		int id = buffer[2]-2;

		if(command == 101){
			updatePage(functions[page][id]);
		}
		dataReceived = 0;
		memset(buffer,0,16);
	}

	static int8_t navMenu = 1;

	//detect select button press
	if(S1->debounce()){
		//get the function associated with the selected object
		int function = functions[currentPage][highlight];
		//go to the selected page
		if(function < back){
			updatePage(function);
		//toggle the dropdown menu
		}else if(function == dropdown){
			channelSelect(1,activeChannel);
			navMenu = !navMenu;
		}
  	}

	//detect nextoption button press
  	if(S2->debounce() == 1){
		//check if the menu navigation is enabled
		if(navMenu){
			//highlight next menu object
			highlight= (highlight + 1) % (functions[currentPage][6]);
			update();
		}else{
			//highlight next dropdown menu object
			activeChannel = (activeChannel+1)%(sizeof(channels)/sizeof(channels[0]));
			channelSelect(0, activeChannel);
		}
	}

	//detect previousoption button press
  	if(S3->debounce()){
		//check if the menu navigation is enabled
		if(navMenu){
			//highlight previous menu object
			highlight = (highlight == 0) ? functions[currentPage][6]-1: highlight-1;
			update();
		}else {
			//highlight previous dropdown menu object
			activeChannel = (--activeChannel < 0) ? sizeof(channels)/sizeof(channels[0])-1 : activeChannel;
			channelSelect(0, activeChannel);
		}
  	}
}