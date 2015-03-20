//
//  caledate.h
//  weather
//
//  Created by duangl on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef weather_caledate_h
#define weather_caledate_h

typedef struct 
{
    float api;
    char * api_text;
    char * wrw_text;
}RESULT;

char * caleApi2(int pm25);
void caleApi(float so2,float no2,float pm10,RESULT *_result);
char * tmpStatus(int a);

#endif
