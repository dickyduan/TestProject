//
//  weatherWeakSubViewController.h
//  weather
//
//  Created by duangl on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherCityData.h"
#import "XImageView.h"

@interface weatherWeakSubViewController : UIViewController
{
    IBOutlet UILabel * cityName;
    IBOutlet UILabel * currentTmp;
    IBOutlet UIImageView * image;
    
    IBOutlet UILabel * refreshLastTime;

    
    IBOutlet UILabel * weakTmp1;
    IBOutlet UILabel * weakTmp2;
    IBOutlet UILabel * weakTmp3;
    IBOutlet UILabel * weakTmp4;
    IBOutlet UILabel * weakTmp5;
    IBOutlet UILabel * weakTmp6;
    
    IBOutlet UILabel * weak1;
    IBOutlet UILabel * weak2;
    IBOutlet UILabel * weak3;
    IBOutlet UILabel * weak4;
    IBOutlet UILabel * weak5;
    IBOutlet UILabel * weak6;
    
    IBOutlet UIImageView * weakImg1;
//    IBOutlet UIImageView * weakImg2;
    IBOutlet UIImageView * weakImg3;
//    IBOutlet UIImageView * weakImg4;
    IBOutlet UIImageView * weakImg5;
//    IBOutlet UIImageView * weakImg6;
    IBOutlet UIImageView * weakImg7;
//    IBOutlet UIImageView * weakImg8;
    IBOutlet UIImageView * weakImg9;
//    IBOutlet UIImageView * weakImg10;
    IBOutlet UIImageView * weakImg11;
//    IBOutlet UIImageView * weakImg12;
    
    IBOutlet UIImageView * background;
    
    IBOutlet XImageView * refreshImage;
    IBOutlet UILabel * refreshText;
    
    weatherCityData * data;

}  
@property (nonatomic,retain) UILabel * refreshLastTime;

@property(nonatomic,retain)  XImageView * refreshImage;
@property(nonatomic,retain)  UILabel * refreshText;
@property(nonatomic,retain)  UILabel * cityName;
@property(nonatomic,retain)  UILabel * currentTmp;
@property(nonatomic,retain)  UILabel * todayTmp;

@property(nonatomic,retain)  UILabel * weakTmp1;
@property(nonatomic,retain)  UILabel * weakTmp2;
@property(nonatomic,retain)  UILabel * weakTmp3;
@property(nonatomic,retain)  UILabel * weakTmp4;
@property(nonatomic,retain)  UILabel * weakTmp5;
@property(nonatomic,retain)  UILabel * weakTmp6;
@property(nonatomic,retain)  UILabel * weakTmp7;
@property(nonatomic,retain)  UILabel * weakTmp8;
@property(nonatomic,retain)  UILabel * weakTmp9;
@property(nonatomic,retain)  UILabel * weakTmp10;
@property(nonatomic,retain)  UILabel * weakTmp11;
@property(nonatomic,retain)  UILabel * weakTmp12;

@property(nonatomic,retain) UILabel * weak1;
@property(nonatomic,retain) UILabel * weak2;
@property(nonatomic,retain) UILabel * weak3;
@property(nonatomic,retain) UILabel * weak4;
@property(nonatomic,retain) UILabel * weak5;
@property(nonatomic,retain) UILabel * weak6;

@property(nonatomic,retain) UIImageView * image;
@property(nonatomic,retain) UIImageView * background;
@property(nonatomic,retain) UIImageView * weakImg1;
@property(nonatomic,retain) UIImageView * weakImg2;
@property(nonatomic,retain) UIImageView * weakImg3;
@property(nonatomic,retain) UIImageView * weakImg4;
@property(nonatomic,retain) UIImageView * weakImg5;
@property(nonatomic,retain) UIImageView * weakImg6;
@property(nonatomic,retain) weatherCityData * data;
-(void)refreshData:(id)sender;
-(IBAction)refresh:(id)sender;
-(void) refreshLastTimer;

-(void) clearBG;
-(void) loadBG;
@end
