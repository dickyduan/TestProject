#include "caledate.h"

float apidata[6] = {
	50,
	100,
	200,
	300,
	400,
	500
};

float so2data[6] = {
	0.050,
	0.150,
	0.800,
	1.600,
	2.100,
	2.620
};

float no2data[6] = {
	0.080,
	0.120,
	0.280,
	0.565,
	0.750,
	0.940
};

float pm10data[6] = {
	0.050,
	0.150,
	0.350,
	0.420,
	0.500,
	0.600
};

char * testchar[7] = {//index = (api-1)/50 ,index > 6 ‘Ú index = 6
	"优",
	"良",
	"轻微污染",
	"轻度污染",
	"中度污染",
	"中度重污染",
	"重污染"
};

char * wrwchar[3] = {
    "二氧化硫",  
    "二氧化氮",
    "可吸入颗粒物"
};

char * weakStatus[32] = {
    "正常",
    "正常",
    "正常",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雪",
    "雪",
    "雪",
    "雪",
    "雪",
    "正常",
    "雨",
    "正常",
    "雨",
    "雨",
    "雨",
    "雨",
    "雨",
    "雪",
    "雪",
    "雪",
    "正常",
    "正常",
    "正常"
};
char * tmpStatus(int a)
{
    return weakStatus[a];
}
float caledata(float c,float * data)
{
	float ib = 0;
	float is = 0;
	float cb = 0;
	float cs = 0;
	for (int i=0;i<6;i++)
	{
		if(data[i] <= c)
		{
			is = apidata[i];
			cs = data[i];
		}
		else
		{
			ib = apidata[i];
			cb = data[i];
			break;
		}
	}
//	if(is == 0)
//        return apidata[0];
//	if(ib == 0)
//        return apidata[5];

	return (ib - is)/(cb - cs)*(c - cs) + is;
}
char * caleApi2(int pm25)
{
    int index = (pm25-1)/50;
    if(index<0) index=0;
    else if(index>6)index=6;
    
    return testchar[index];
}
void caleApi(float so2,float no2,float pm10,RESULT *_result)
{
	float apiso2 = caledata(so2,so2data);
	float apino2 = caledata(no2,no2data);
	float apipm10 = caledata(pm10,pm10data);
    int type = 0;
	float result = apiso2;
	if(result < apino2)
    {
        result = apino2; 
        type = 1;
    }
	if(result < apipm10)
    {
        result = apipm10;
        type =2;
    }
    _result->api = result;
    
    int index = (result-1)/50;
    if(index<0) index=0;
    else if(index>6)index=6;
    
    _result->api_text = testchar[index];
    _result->wrw_text = wrwchar[type];
//	printf("so2api = %f no2api = %f pm10api = %f resapi = %f",apiso2,apino2,apipm10,result);
}
/*
void main()
{
	caleApi(0.105,0.080,0.215); 
	getchar();
}
*/