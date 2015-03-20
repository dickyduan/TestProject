//
//  weatherLiveSubViewController.h
//  weather
//
//  Created by duangl on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherCityData.h"
#import "XImageView.h"

@interface weatherLiveSubViewController : UIViewController
{
    weatherCityData * data;
    
    IBOutlet UILabel * title; //标题
    IBOutlet UILabel * ct_hint; //穿衣
    IBOutlet UILabel * co_hint; //舒适度
    IBOutlet UILabel * gm_hint; //感冒
    IBOutlet UILabel * yd_hint; //运动
    IBOutlet UILabel * sd;      //空气湿度
    IBOutlet UILabel * uv_hint; //紫外线 
    IBOutlet UILabel * ag_hint; //过敏
    IBOutlet UILabel * xc_hint; //洗车指数
    IBOutlet UILabel * refreshTime;
    IBOutlet UILabel * todayDate;
    IBOutlet XImageView * refreshImage;
    IBOutlet UIImageView * background;
    IBOutlet UIButton * refresh; //刷新
    IBOutlet UILabel * refreshLastTime;
    

}
@property (nonatomic,retain) UILabel * refreshLastTime;
@property(nonatomic,retain) weatherCityData * data;
@property(nonatomic,retain) UILabel * title; //标题
@property(nonatomic,retain) UILabel * ct_hint; //穿衣
@property(nonatomic,retain) UILabel * co_hint; //舒适度
@property(nonatomic,retain) UILabel * gm_hint; //感冒
@property(nonatomic,retain) UILabel * yd_hint; //运动
@property(nonatomic,retain) UILabel * sd;      //空气湿度
@property(nonatomic,retain) UILabel * uv_hint; //紫外线 
@property(nonatomic,retain) UILabel * ag_hint; //过敏
@property(nonatomic,retain) UILabel * xc_hint; //洗车指数
@property(nonatomic,retain) XImageView * refreshImage;
@property(nonatomic,retain) UIImageView * background;
@property(nonatomic,retain) UILabel * todayDate;
@property(nonatomic,retain) UILabel * refreshTime;
@property(nonatomic,retain) UIButton * refresh; //刷新
-(IBAction)refresh:(id)sender;
-(IBAction)refreshData:(id)sender;
-(void) refreshLastTimer;
-(void) clearBG;
-(void) loadBG;
-(IBAction)iap:(id)sender;
@end
