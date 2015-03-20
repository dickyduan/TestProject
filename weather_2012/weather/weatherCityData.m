//
//  weatherCityData.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherCityData.h"

@implementation weatherCityData
@synthesize cityName;
@synthesize weatherCode;
//@synthesize adCode99;

@synthesize currentTmp;
@synthesize todayTmp;
//@synthesize airRegime;
@synthesize airAPIpm10cn,airAPIpm25cn,airAPIpm25us;
@synthesize firstContamination;

@synthesize refreshLastTime;
//@synthesize image;

@synthesize fengli;
@synthesize fengxiang;

@synthesize ct_hint; //穿衣
@synthesize co_hint; //舒适度
@synthesize gm_hint; //感冒
@synthesize yd_hint; //运动
@synthesize sd;      //空气湿度
@synthesize uv_hint; //紫外线
@synthesize xc_hint;  //洗车
@synthesize ag_hint;  //洗车
@synthesize live_date;

@synthesize weakTmp1;
@synthesize weakTmp2;
@synthesize weakTmp3;
@synthesize weakTmp4;
@synthesize weakTmp5;
@synthesize weakTmp6;

@synthesize weak1;
@synthesize weak2;
@synthesize weak3;
@synthesize weak4;
@synthesize weak5;
@synthesize weak6;

//@synthesize weakImg1;
//@synthesize weakImg2;
//@synthesize weakImg3;
//@synthesize weakImg4;
//@synthesize weakImg5;
//@synthesize weakImg6;
@synthesize refreshTime;
@synthesize LastDate;
@synthesize bgID;

@synthesize updateData;
@synthesize updateSK;
@synthesize updateWR;
@synthesize updateZS;

@synthesize img1;
@synthesize img2;
@synthesize img3;
@synthesize img4;
@synthesize img5;
@synthesize img6;
@synthesize img7;
@synthesize img8;
@synthesize img9;
@synthesize img10;
@synthesize img11;
@synthesize img12;
@synthesize tags;
@synthesize updateTime;
@synthesize manid;
@synthesize index;

- (id)init
{
    [super init];
    
    updateData = false;
    updateSK = false;
    updateWR = false;
    updateZS = false;
    
    
    cityName = @"获取中";
    weatherCode = @"获取中";
//    adCode99 = @"获取中";
    
    //today
    currentTmp = @"获取中";
    todayTmp = @"获取中";
    
//    airRegime = @"获取中";
    firstContamination = @"获取中";
//    airAPI = @"获取中";
    
//    image = @"获取中";
    fengxiang = @"获取中"; //风向
    fengli = @"获取中"; //风力
    
    //weak
    weakTmp1 = @"获取中";
    weakTmp2 = @"获取中";
    weakTmp3 = @"获取中";
    weakTmp4 = @"获取中";
    weakTmp5 = @"获取中";
    weakTmp6 = @"获取中";
    
    weak1 = @"获取中";
    weak2 = @"获取中";
    weak3 = @"获取中";
    weak4 = @"获取中";
    weak5 = @"获取中";
    weak6 = @"获取中";
    
//    weakImg1 = @"获取中";
//    weakImg2 = @"获取中";
//    weakImg3 = @"获取中";
//    weakImg4 = @"获取中";
//    weakImg5 = @"获取中";
//    weakImg6 = @"获取中";
    
    //live
    live_date = @"获取中";
    ct_hint = @"获取中"; //穿衣
    co_hint = @"获取中"; //舒适度
    gm_hint = @"获取中"; //感冒
    yd_hint = @"获取中"; //运动
    sd = @"获取中";      //空气湿度
    uv_hint = @"获取中"; //紫外线
    xc_hint = @"获取中"; //洗车指数
    ag_hint = @"获取中"; //洗车指数
    
    refreshTime = @"更新于: N/A";
    return self;
}

-(void)LoadFromJson:(NSDictionary *) dict
{
    if(!dict)
        return;
    weatherCityData * result = self;
    
//    result.cityName = [dict objectForKey:@"cityName"];
//    result.weatherCode = [dict objectForKey:@"weatherCode"];
//    result.adCode99 = [dict objectForKey:@"adCode99"];
    
    result.currentTmp = [dict objectForKey:@"currentTmp"];
    result.todayTmp = [dict objectForKey:@"todayTmp"];
//    result.airRegime = [dict objectForKey:@"airRegime"];
//    result.airAPI = [dict objectForKey:@"airAPI"];
    result.firstContamination = [dict objectForKey:@"firstContamination"];
    
//    result.image = [dict objectForKey:@"image"];
    
    result.fengli = [dict objectForKey:@"fengli"];
    result.fengxiang = [dict objectForKey:@"fengxiang"];
    
    result.ct_hint = [dict objectForKey:@"ct_hint"]; //穿衣
    result.co_hint = [dict objectForKey:@"co_hint"]; //舒适度
    result.gm_hint = [dict objectForKey:@"gm_hint"]; //感冒
    result.yd_hint = [dict objectForKey:@"yd_hint"]; //运动
    result.sd = [dict objectForKey:@"sd"];      //空气湿度
    result.uv_hint = [dict objectForKey:@"uv_hint"]; //紫外线
    result.xc_hint = [dict objectForKey:@"xc_hint"];  //洗车
    result.ag_hint = [dict objectForKey:@"ag_hint"];  //洗车
    result.live_date = [dict objectForKey:@"live_date"];
    
    result.weakTmp1 = [dict objectForKey:@"weakTmp1"];
    result.weakTmp2 = [dict objectForKey:@"weakTmp2"];
    result.weakTmp3 = [dict objectForKey:@"weakTmp3"];
    result.weakTmp4 = [dict objectForKey:@"weakTmp4"];
    result.weakTmp5 = [dict objectForKey:@"weakTmp5"];
    result.weakTmp6 = [dict objectForKey:@"weakTmp6"];
    
    result.weak1 = [dict objectForKey:@"weak1"];
    result.weak2 = [dict objectForKey:@"weak2"];
    result.weak3 = [dict objectForKey:@"weak3"];
    result.weak4 = [dict objectForKey:@"weak4"];
    result.weak5 = [dict objectForKey:@"weak5"];
    result.weak6 = [dict objectForKey:@"weak6"];
    
//    result.weakImg1 = [dict objectForKey:@"weakImg1"];
//    result.weakImg2 = [dict objectForKey:@"weakImg2"];
//    result.weakImg3 = [dict objectForKey:@"weakImg3"];
//    result.weakImg4 = [dict objectForKey:@"weakImg4"];
//    result.weakImg5 = [dict objectForKey:@"weakImg5"];
//    result.weakImg6 = [dict objectForKey:@"weakImg6"];
    result.refreshTime = [dict objectForKey:@"refreshTime"];
//    result.bgID = [[dict objectForKey:@"bgID"] intValue];
    
}
-(NSMutableDictionary *)SaveToDict
{
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
//    [dict setValue:cityName  forKey:@"cityName"];
//    [dict setValue:weatherCode  forKey:@"weatherCode"];
//    [dict setValue:adCode99  forKey:@"adCode99"];
    
    [dict setValue:currentTmp  forKey:@"currentTmp"];
    [dict setValue:todayTmp  forKey:@"todayTmp"];
//    [dict setValue:airRegime  forKey:@"airRegime"];
//    [dict setValue:airAPI  forKey:@"airAPI"];
    [dict setValue:firstContamination  forKey:@"firstContamination"];
    
//    [dict setValue:image  forKey:@"image"];
    
    [dict setValue:fengli  forKey:@"fengli"];
    [dict setValue:fengxiang  forKey:@"fengxiang"];
    
    [dict setValue:ct_hint  forKey:@"ct_hint"]; //穿衣
    [dict setValue:co_hint  forKey:@"co_hint"]; //舒适度
    [dict setValue:gm_hint  forKey:@"gm_hint"]; //感冒
    [dict setValue:yd_hint  forKey:@"yd_hint"]; //运动
    [dict setValue:sd  forKey:@"sd"];      //空气湿度
    [dict setValue:uv_hint  forKey:@"uv_hint"]; //紫外线
    [dict setValue:xc_hint  forKey:@"xc_hint"];  //洗车
    [dict setValue:ag_hint  forKey:@"ag_hint"];  //洗车
    [dict setValue:live_date  forKey:@"live_date"];
    
    [dict setValue:weakTmp1  forKey:@"weakTmp1"];
    [dict setValue:weakTmp2  forKey:@"weakTmp2"];
    [dict setValue:weakTmp3  forKey:@"weakTmp3"];
    [dict setValue:weakTmp4  forKey:@"weakTmp4"];
    [dict setValue:weakTmp5  forKey:@"weakTmp5"];
    [dict setValue:weakTmp6  forKey:@"weakTmp6"];
    
    [dict setValue:weak1  forKey:@"weak1"];
    [dict setValue:weak2  forKey:@"weak2"];
    [dict setValue:weak3  forKey:@"weak3"];
    [dict setValue:weak4  forKey:@"weak4"];
    [dict setValue:weak5  forKey:@"weak5"];
    [dict setValue:weak6  forKey:@"weak6"];
    
//    [dict setValue:weakImg1  forKey:@"weakImg1"];
//    [dict setValue:weakImg2  forKey:@"weakImg2"];
//    [dict setValue:weakImg3  forKey:@"weakImg3"];
//    [dict setValue:weakImg4  forKey:@"weakImg4"];
//    [dict setValue:weakImg5  forKey:@"weakImg5"];
//    [dict setValue:weakImg6  forKey:@"weakImg6"];
    [dict setValue:refreshTime  forKey:@"refreshTime"];
//    [dict setValue:[NSNumber numberWithInt:bgID] forKey:@"bgID"];
    
    return dict;
}
@end
