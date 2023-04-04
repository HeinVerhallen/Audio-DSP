#ifndef _NEXTION_h
#define _NEXTION_h

void terminate();

void gotoPage(int page);

void textField(int component, const char* value, const char* field);

#endif