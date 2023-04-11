#ifndef _NEXTION_h
#define _NEXTION_h

//Goal:     Send the proper characters to terminate a Nextion instruction.
//Inputs:   -
//Outputs:  -
void terminate();

//Goal:     Send the Nextion screen a command to go to a specific screen
//Inputs:   int page - the page number to navigate to
//Outputs:  -
void gotoPage(int page);

//Goal:     Change parameters of a text field
//Inputs:   component: the id of the text field to be adjusted as an integer
//          value: the value for the parameter as an character array
//          field: the parameter to change (either: 0 to change to displayed text or 1 to change the background color of the text field);
//Outputs:  -
void textField(int component, const char* value, int field);

//Goal:     Change parameters of a component of the screen
//Inputs:   component: the object name of the component to change a parameter of
//          value: the value for the parameter as an character array
//          field: the parameter to change (either: 0 to change to displayed text or 1 to change the background color of the text field);
//Outputs:  -
void changeParameter(const char* component, const char* value, int field);

#endif