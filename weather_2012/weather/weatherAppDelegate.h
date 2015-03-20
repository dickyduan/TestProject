//
//  weatherAppDelegate.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherCityData.h"
#import "MBProgressHUD.h"
#import "ECStoreObserver.h"
#import "ECPurchase.h"
#define GetImage(x) [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:x ofType:@"png"]]



@interface weatherAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,MBProgressHUDDelegate,ECPurchaseProductDelegate,ECPurchaseTransactionDelegate>
{
    NSMutableArray * city;
    NSMutableArray * pm25city;

    NSArray * sourceData;
    NSMutableArray *fileData;
    NSArray * backgroundToday;
    NSArray * backgroundWeak;
    NSArray * backgroundLive;
    NSArray * backgroundHelp;
    NSArray * backgroundShare;
    NSArray * backgroundAddCity;
    
    NSArray * textColor;
    NSArray * refbtn;
    MBProgressHUD * HUD;
    int currentCityIndex;
    NSDictionary *pushInfo;
    NSDictionary * cityConfig;
    
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary * cityConfig;

@property (nonatomic, retain) NSMutableArray* city;
@property (nonatomic, retain) NSMutableArray* fileData;
@property (nonatomic, retain) NSMutableArray* pm25city;

@property (nonatomic, retain) NSArray * sourceData;
@property (nonatomic, retain) NSArray * backgroundToday;
@property (nonatomic, retain) NSArray * backgroundWeak;
@property (nonatomic, retain) NSArray * backgroundLive;
@property (nonatomic, retain) NSArray * backgroundHelp;
@property (nonatomic, retain) NSArray * backgroundShare;
@property (nonatomic, retain) NSArray * backgroundAddCity;

@property (nonatomic, retain) NSArray * textColor;
@property (nonatomic, retain) NSArray * refbtn;
@property (nonatomic, retain)  MBProgressHUD * HUD;
@property (nonatomic,retain) NSDictionary *pushInfo;

@property int currentCityIndex;


-(void) initImage;
-(void) initCity;
-(void) refresh:(int) index;
-(void) refreshTimer:(NSNumber*) index;
-(void) refreshNetwork:(id) sender;
-(void) refreshView;
-(void) refreshLastTime;
-(NSString *)EncodeGB2312Str:(NSString *)encodeStr;
-(UIColor*) decRed:(int) red Green:(int) green Blue:(int) blue; 


-(void) reSK:(id) _json data:(weatherCityData*) _data;
-(void) reData:(id) _json data:(weatherCityData*) _data;
-(void) reZS:(id) _json data:(weatherCityData*) _data isReadFile:(bool) isReadFile;
-(void) reWR:(id) _json data:(weatherCityData*) _data;
-(void) reTime:(id) _json data:(weatherCityData*) _data;
-(void) reLoaclNotifi;
-(NSString *) NotifyTmpWith:(NSString*) tmp status:(int) img;
-(void) reLocalNotifiWithTime:(NSString*) weakTime afterDay:(int) weakDay;
-(void) registerLocalNotification:(int)notifyType;
-(void) showLocalNotification:(UILocalNotification*)notification;
-(void) showPushNotification:(NSDictionary*)userInfo;

-(void)registerNetWorkPush;
- (NSString *)lang;
- (NSString*)getMACAddress;
-(void)setPushRecord_YES;
-(void)setPushRecord_NO;

//-(void) 

@end


