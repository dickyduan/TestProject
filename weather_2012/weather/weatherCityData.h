//
//  weatherCityData.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface weatherCityData : NSObject
{
    NSString * cityName;
    NSString * weatherCode;
//    NSString * adCode99;
    
    //today
    NSString * currentTmp;
    NSString * todayTmp;
    
//    NSString * airRegime;
    NSString * firstContamination;
//    NSString * airAPI;
    NSString * airAPIpm25cn;
    NSString * airAPIpm25us;
    NSString * airAPIpm10cn;
//    NSString * image;
    NSString * fengxiang; //风向
    NSString * fengli; //风力
    
    //weak
    NSString * weakTmp1;
    NSString * weakTmp2;
    NSString * weakTmp3;
    NSString * weakTmp4;
    NSString * weakTmp5;
    NSString * weakTmp6;
    
    NSString * weak1;
    NSString * weak2;
    NSString * weak3;
    NSString * weak4;
    NSString * weak5;
    NSString * weak6;
    
//    NSString * weakImg1;
//    NSString * weakImg2;
//    NSString * weakImg3;
//    NSString * weakImg4;
//    NSString * weakImg5;
//    NSString * weakImg6;
    
    //live
    NSString * live_date;
    NSString * ct_hint; //穿衣
    NSString * co_hint; //舒适度
    NSString * gm_hint; //感冒
    NSString * yd_hint; //运动
    NSString * sd;      //空气湿度
    NSString * uv_hint; //紫外线
    NSString * xc_hint; //洗车指数
    NSString * ag_hint; //洗车指数
    
    NSString * refreshTime;
    NSString * refreshLastTime;
    NSDate * LastDate;
    
    int bgID;
    
    bool updateSK;
    bool updateData;
    bool updateZS;
    bool updateWR;
    bool updateTime;
    
    int img1;
    int img2;
    int img3;
    int img4;
    int img5;
    int img6;
    int img7;
    int img8;
    int img9;
    int img10;
    int img11;
    int img12;
    
    int tags;
    int manid;
    
    int index;

    
}
@property (nonatomic,retain) NSString * refreshTime;
@property (nonatomic,retain) NSString * refreshLastTime;
@property (nonatomic,retain) NSString * cityName;
@property (nonatomic,retain) NSString * weatherCode;
//@property (nonatomic,retain) NSString * adCode99;

@property (nonatomic,retain) NSString * currentTmp;
@property (nonatomic,retain) NSString * todayTmp;
//@property (nonatomic,retain) NSString * airRegime;
@property (nonatomic,retain) NSString * firstContamination;
@property (nonatomic,retain)NSString * airAPIpm25cn;
@property (nonatomic,retain)NSString * airAPIpm25us;
@property (nonatomic,retain)NSString * airAPIpm10cn;
@property (nonatomic,retain) NSString * fengxiang; //风向
@property (nonatomic,retain) NSString * fengli; //风力

//@property (nonatomic,retain) NSString * image;
@property (nonatomic,retain) NSString * ct_hint; //穿衣
@property (nonatomic,retain) NSString * co_hint; //舒适度
@property (nonatomic,retain) NSString * gm_hint; //感冒
@property (nonatomic,retain) NSString * yd_hint; //运动
@property (nonatomic,retain) NSString * sd;      //空气湿度
@property (nonatomic,retain) NSString * uv_hint; //紫外线
@property (nonatomic,retain) NSString * xc_hint; //洗车指数
@property (nonatomic,retain) NSString * ag_hint; //洗车指数
@property (nonatomic,retain) NSString * live_date; //洗车指数

@property (nonatomic,retain) NSString * weakTmp1;
@property (nonatomic,retain) NSString * weakTmp2;
@property (nonatomic,retain) NSString * weakTmp3;
@property (nonatomic,retain) NSString * weakTmp4;
@property (nonatomic,retain) NSString * weakTmp5;
@property (nonatomic,retain) NSString * weakTmp6;

@property (nonatomic,retain) NSString * weak1;
@property (nonatomic,retain) NSString * weak2;
@property (nonatomic,retain) NSString * weak3;
@property (nonatomic,retain) NSString * weak4;
@property (nonatomic,retain) NSString * weak5;
@property (nonatomic,retain) NSString * weak6;
@property (nonatomic,retain) NSDate * LastDate;
@property int tags;

//@property (nonatomic,retain) NSString * weakImg1;
//@property (nonatomic,retain) NSString * weakImg2;
//@property (nonatomic,retain) NSString * weakImg3;
//@property (nonatomic,retain) NSString * weakImg4;
//@property (nonatomic,retain) NSString * weakImg5;
//@property (nonatomic,retain) NSString * weakImg6;

@property int bgID;
@property bool updateSK;
@property bool updateData;
@property bool updateZS;
@property bool updateWR;
@property bool updateTime;
@property int img1;
@property int img2;
@property int img3;
@property int img4;
@property int img5;
@property int img6;
@property int img7;
@property int img8;
@property int img9;
@property int img10;
@property int img11;
@property int img12;
@property int manid;
@property int index;

-(void)LoadFromJson:(NSDictionary *) dict;
-(NSMutableDictionary *)SaveToDict;

@end
