//
//  weatherTodaySubViewController.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherCityData.h"
#import "XImageView.h"
#import "XShare.h"

@interface weatherTodaySubViewController : UIViewController<XShareDelegate,UIActionSheetDelegate>
{
    IBOutlet UILabel * cityName;
    IBOutlet UILabel * currentTmp;
    IBOutlet UILabel * todayTmp;
    IBOutlet UILabel * feng;
    
    IBOutlet UILabel * airRegime;
    IBOutlet UILabel * firstContamination;
    IBOutlet UILabel * airAPI;
    
    IBOutlet UILabel * currentTmpTitle;
    IBOutlet UILabel * todayTmpTitle;
    IBOutlet UIImageView * background;
    IBOutlet UILabel * pm;
//    IBOutlet UILabel * airRegimeTitle;
//    IBOutlet UILabel * firstContaminationTitle;
    IBOutlet UILabel * airAPITitle;
    
    IBOutlet UIButton * refresh;
    IBOutlet UIImageView * image;
    IBOutlet XImageView * refreshImage;
    IBOutlet UILabel * refreshTime;
    IBOutlet UILabel * refreshLastTime;
    IBOutlet UIImageView * man;
    
    IBOutlet UIImageView * tagImage;
    weatherCityData * data;
    
    IBOutlet UIImageView * blank;
    int switchFlag;
    int flagConfig;
}
@property (nonatomic,retain) weatherCityData * data;
@property (nonatomic,retain) UILabel * pm;
@property (nonatomic,retain) UIImageView * blank;
@property int flagConfig;
@property (nonatomic,retain) UIButton * refresh;
@property (nonatomic,retain) UILabel * cityName;
@property (nonatomic,retain) UILabel * currentTmp;
@property (nonatomic,retain) UILabel * todayTmp;
@property (nonatomic,retain) UILabel * airRegime;
@property (nonatomic,retain) UILabel * firstContamination;
@property (nonatomic,retain) UILabel * airAPI;
@property (nonatomic,retain) UILabel * feng;
@property (nonatomic,retain) UIImageView * background;
@property (nonatomic,retain) UIImageView * man;
@property (nonatomic,retain) UILabel * airAPITitle;
@property (nonatomic,retain) UILabel * refreshTime;
@property (nonatomic,retain) UILabel * refreshLastTime;
@property (nonatomic,retain) XImageView * refreshImage;
@property (nonatomic,retain) UIImageView * tagImage;
-(void) refreshLastTimer;
-(IBAction)refreshData:(id)sender;
-(IBAction)refresh:(id)sender;
-(IBAction)sendShare:(id)sender;
-(IBAction)switchTag:(id)sender;
-(void) clearBG;
-(void) loadBG;
-(bool) setFlag:(int) flag;
@end
