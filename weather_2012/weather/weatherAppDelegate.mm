//
//  weatherAppDelegate.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherAppDelegate.h"
#import "NSObject+SBJson.h"
#import "weatherTodayViewController.h"
#import "weatherLiveViewController.h"
#import "weatherAddCityViewController.h"
#import "weatherHelpViewController.h"
#import "weatherShareViewController.h"
#import "weatherWeakViewController.h"
#import "weatherCityData.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "XTabBarController.h"
#include "caledate.h"

#if !(TARGET_IPHONE_SIMULATOR)
#import "DiamondADView.h"
#endif
#pragma mark- debug
//#define DEBUG_MEMERY

#ifdef DEBUG_MEMERY
#import <mach/mach.h>
UILabel *moeryLab;
struct task_basic_info info;
#endif

#define LocalPush 1

static char * weaktext[7] ={
    "星期一",
    "星期二",
    "星期三",
    "星期四",
    "星期五",
    "星期六",
    "星期日",
};

static int iconreal[32] = {0,1,2,3,4,5,6,10,10,10,12,12,12,13,14,14,17,17,18,19,20,10,10,10,12,12,14,17,17,29,30,31};


@implementation weatherAppDelegate
@synthesize sourceData;
@synthesize city;
@synthesize fileData;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize backgroundToday;
@synthesize backgroundWeak;
@synthesize textColor;
@synthesize HUD;
@synthesize currentCityIndex;
@synthesize refbtn;
@synthesize backgroundLive;
@synthesize backgroundHelp;
@synthesize backgroundShare;
@synthesize backgroundAddCity;
@synthesize pushInfo;
@synthesize cityConfig;
@synthesize pm25city;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [city removeAllObjects];
    [city release];
    [backgroundToday release];
    [textColor release];
    [backgroundWeak release];
    [fileData removeAllObjects];
    [fileData release];
    [sourceData release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initImage];
    self.tabBarController = [[[XTabBarController alloc] init] autorelease];
    self.tabBarController.delegate = self;
    HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    
    HUD.delegate = self;
    HUD.labelText = @"加载中";
	HUD.square = YES;
	    
    [self initCity];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView) userInfo:nil repeats:YES] ;
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[weatherTodayViewController alloc] initWithNibName:@"weatherTodayViewController" bundle:nil] autorelease];
    UIViewController *viewController6 = [[[weatherWeakViewController alloc] initWithNibName:@"weatherWeakViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[weatherLiveViewController alloc] initWithNibName:@"weatherLiveViewController" bundle:nil] autorelease];
    UIViewController *viewController3 = [[[weatherAddCityViewController alloc] initWithNibName:@"weatherAddCityViewController" bundle:nil] autorelease];
    UIViewController *viewController4 = [[[weatherHelpViewController alloc] initWithNibName:@"weatherHelpViewController" bundle:nil] autorelease];
    UIViewController *viewController5 = [[[weatherShareViewController alloc] initWithNibName:@"weatherShareViewController" bundle:nil] autorelease];
    self.tabBarController.view.frame = CGRectMake(0, 480-79, 320, 59);
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController6,viewController2,viewController3,viewController5,nil];
//   self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController5,nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [self.window addSubview:HUD];
#if !(TARGET_IPHONE_SIMULATOR)

    DiamondADView *adView = [[DiamondADView alloc] requestAdOfSize:CGSizeMake(320, 50) bundleID:@"com.cicada.zaconstellation"];
    adView.parentVC = self.tabBarController;
	[self.tabBarController.view addSubview:adView];

#endif
    
    [self refresh:-1];
    [NSTimer scheduledTimerWithTimeInterval:60*20 target:self selector:@selector(refreshTimer:) userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:-1] forKey:@"index"] repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLastTime) userInfo:nil repeats:YES];
    
    /*
     根据用户状态注册本地通知
     */ 
//	[self registerLocalNotification:0];
	switch (LocalPush)
	{
		case 0:
		{
            // 如果需要本地+网络通知
			[self registerNetWorkPush];
		}
			break;
		case 1:
		{
            //如果仅用本地通知
			[[UIApplication sharedApplication] 
			 registerForRemoteNotificationTypes:
			(UIRemoteNotificationType) (UIRemoteNotificationTypeAlert |
			  UIRemoteNotificationTypeBadge |
			  UIRemoteNotificationTypeSound)];
		}
			break;
		default:
			break;
	}	
    /*
     完全推出程序后，通过通知进入程序，优先处理通知内容
     */	
	// 如果是点击本地通知进入，则弹出本地通知内容
	UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
		NSLog(@"是点击本地通知进入并启动程序，弹出本地通知内容");
		[self showLocalNotification:localNotification];
    }
	// 如果是点击推送通知进入，则弹出推送通知内容
	NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	if (userInfo) {
		NSLog(@"是点击推送进入并启动程序，弹出推送内容");
	}

    // debug
#ifdef DEBUG_MEMERY
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changedata) userInfo:nil repeats:YES];
    moeryLab = [[UILabel alloc] init];
    moeryLab.frame=CGRectMake(0., 20., 200., 15.);
    moeryLab.font = [UIFont systemFontOfSize:16.]; 
    moeryLab.text = [NSString stringWithFormat:@"内存:%gM",(info.resident_size/1024)/1024];
    [self.window addSubview:moeryLab];
#endif
    [[ECPurchase shared] addTransactionObserver];
    [[ECPurchase shared] setProductDelegate:self];
    [[ECPurchase shared] setTransactionDelegate:self];
    [[ECPurchase shared] setVerifyRecepitMode:ECVerifyRecepitModeiPhone];
    return YES;
}

#ifdef DEBUG_MEMERY
-(void)changedata{
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        moeryLab.text = [NSString stringWithFormat:@"内存:%lf",info.resident_size/1024.0/1024.0];
    } 
    else
    {
        moeryLab.text = @"error";
    }
}
#endif
-(UIColor*) decRed:(int) red Green:(int) green Blue:(int) blue
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

-(void) initImage
{
    backgroundToday = [[NSArray alloc] initWithObjects:@"background1_1",@"background1_2",@"background1_3",@"background1_4",@"background1_5", nil];
    backgroundWeak = [[NSArray alloc] initWithObjects:@"background2_1",@"background2_2",@"background2_3",@"background2_4",@"background2_5", nil];
    textColor = [[NSArray alloc] initWithObjects:[self decRed:30 Green:145 Blue:150],[self decRed:133 Green:136 Blue:143],[self decRed:197 Green:30 Blue:73],[self decRed:221 Green:97 Blue:35],[self decRed:90 Green:158 Blue:55],nil];
    refbtn = [[NSArray alloc] initWithObjects:@"refbtn1",@"refbtn2",@"refbtn3",@"refbtn4",@"refbtn5",nil];
    backgroundLive = [[NSArray alloc] initWithObjects:@"background3_1",@"background3_2",@"background3_3",@"background3_4",@"background3_5", nil];
    backgroundHelp = [[NSArray alloc] initWithObjects:@"background5_1",@"background5_2",@"background5_3",@"background5_4",@"background5_5", nil];
    backgroundShare = backgroundHelp;
    backgroundAddCity = backgroundHelp;
}

-(void) initCity
{

    NSData * file = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"]];
    sourceData = [[NSArray alloc] initWithArray:[file JSONValue]];
    [file release];
    self.city = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString * filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    self.fileData = [[NSMutableArray alloc] initWithCapacity:0];
    NSData * config = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/config.json",filepath]];
    if(config)
    {
        self.cityConfig = [config JSONValue];
    }
    else 
    {
        self.cityConfig = [[NSString stringWithString:@"{\"update\":false,\"rev\":\"1.1.0\",\"上海\":\"1\",\"广州\":\"2\",\"北京\":\"2\",\"深圳\":\"1\",\"厦门\":\"1\"}"] JSONValue];
    }
    self.pm25city = [[NSMutableArray alloc] initWithCapacity:0];
    for (id str in self.cityConfig) 
    {
        for (int i=0; i<[self.sourceData count]; i++) 
        {
            id array = [[self.sourceData objectAtIndex:i] objectForKey:@"citys"];
            for (int j=0; j<[array count]; j++) 
            {
                id dict = [array objectAtIndex:j];
                if([[dict objectForKey:@"name"] isEqual:str])
                {
                    [self.pm25city addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index1",[NSNumber numberWithInt:j],@"index2",str,@"name",nil]];
                    break;
                }
            }
        }
//        if([str isEqualToString:_city.cityName])
//        {
//            break;
//        }
    }
    
    
    
    file = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/record.json",filepath]];
    if(file)
    {
        self.fileData = [file JSONValue];

    }
    else
    {
        self.fileData = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"index1",@"0",@"index2",[NSNull null],@"date",nil];
        NSMutableDictionary * dict2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"index1",@"0",@"index2",[NSNull null],@"date",nil];
        [self.fileData addObject:dict1];
        [self.fileData addObject:dict2];
  
       [[self.fileData JSONRepresentation] writeToFile:[NSString stringWithFormat:@"%@/record.json",filepath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    int max = [backgroundToday count] -1;
    int ran = arc4random() % max;
    if(ran == 0) ran++;
    int tag = 0;
//    for (NSDictionary * dict in self.fileData) {
    for (int i=0; i<[self.fileData count]; i++) {
        NSDictionary * dict = [self.fileData objectAtIndex:i];
        weatherCityData * _city = [[[weatherCityData alloc] init] autorelease];
        int index1 = [[dict objectForKey:@"index1"] intValue];
        int index2 = [[dict objectForKey:@"index2"] intValue];
        _city.index = i;
        id citydata = [[[self.sourceData objectAtIndex:index1] objectForKey:@"citys"] objectAtIndex:index2];
        
        _city.weatherCode = [citydata objectForKey:@"weatherCode"];
        _city.cityName = [citydata objectForKey:@"name"];
        _city.bgID = ++ran>max?ran=0:ran;
        
        id date = [dict objectForKey:@"date"];
        if([date isKindOfClass:[NSNull class]])
        {
            _city.LastDate = nil;
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            _city.LastDate = [formatter dateFromString:date];
            [formatter release];
        }
        
        [self reSK:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.sk",filepath,_city.weatherCode]] data:_city];
        [self reData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.data",filepath,_city.weatherCode]] data:_city];
        [self reWR:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.wr3",filepath,_city.weatherCode]] data:_city];

        [self reZS:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.zs",filepath,_city.weatherCode]] data:_city isReadFile:YES];
        [self reTime:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.time",filepath,_city.weatherCode]] data:_city];

        _city.updateSK = false;
        _city.updateData = false;
        _city.updateWR = false;
        _city.updateZS = false;
        _city.updateTime = false;
        
        _city.tags = tag ++;
        [self.city addObject:_city];
    }
    
}
-(void) refresh:(int) index
{
    [HUD showWhileExecuting:@selector(refreshNetwork:) onTarget:self withObject:[NSNumber numberWithInt:index] animated:YES];
}
-(void) refreshTimer:(id) index
{
    [HUD showWhileExecuting:@selector(refreshNetwork:) onTarget:self withObject:[[index userInfo] objectForKey:@"index"] animated:YES];
}
-(void) refreshLastTime
{
    
    [[[[self tabBarController] viewControllers] objectAtIndex:0] refreshLastTimer];
    [[[[self tabBarController] viewControllers] objectAtIndex:1] refreshLastTimer];
    [[[[self tabBarController] viewControllers] objectAtIndex:2] refreshLastTimer];

}
-(void) reSK:(id) _json data:(weatherCityData *) _data
{
    if(!_json) return;
    id json = [[_json JSONValue] objectForKey:@"weatherinfo"];
    _data.sd = [json objectForKey:@"SD"];
    _data.currentTmp = [NSString stringWithFormat:@"%@℃",[json objectForKey:@"temp"]];
    _data.fengxiang = [json objectForKey:@"WD"];
    _data.fengli = [json objectForKey:@"WS"];   

    _data.updateSK=true; 
}

-(void) reData:(id) _json data:(weatherCityData*) _data
{
    if(!_json) return;

    weatherCityData * data = _data;
    id json = [[_json JSONValue] objectForKey:@"weatherinfo"];
    data.todayTmp = [json objectForKey:@"temp1"];
    
    data.img1 = [[json objectForKey:@"img1"] intValue];
    data.img2 = [[json objectForKey:@"img2"] intValue];
    data.img3 = [[json objectForKey:@"img3"] intValue];
    data.img4 = [[json objectForKey:@"img4"] intValue];
    data.img5 = [[json objectForKey:@"img5"] intValue];
    data.img6 = [[json objectForKey:@"img6"] intValue];
    data.img7 = [[json objectForKey:@"img7"] intValue];
    data.img8 = [[json objectForKey:@"img8"] intValue];
    data.img9 = [[json objectForKey:@"img9"] intValue];
    data.img10 = [[json objectForKey:@"img10"] intValue];
    data.img11 = [[json objectForKey:@"img11"] intValue];
    data.img12 = [[json objectForKey:@"img12"] intValue];
    
    data.img1 = data.img1 == 99 ? 0 :  iconreal[data.img1];
    data.img2 = data.img2 == 99 ? 0 :  iconreal[data.img2];
    data.img3 = data.img3 == 99 ? 0 :  iconreal[data.img3];
    data.img4 = data.img4 == 99 ? 0 :  iconreal[data.img4];
    data.img5 = data.img5 == 99 ? 0 :  iconreal[data.img5];
    data.img6 = data.img6 == 99 ? 0 :  iconreal[data.img6];
    data.img7 = data.img7 == 99 ? 0 :  iconreal[data.img7];
    data.img8 = data.img8 == 99 ? 0 :  iconreal[data.img8];
    data.img9 = data.img9 == 99 ? 0 :  iconreal[data.img9];
    data.img10 = data.img10 == 99 ? 0 :  iconreal[data.img10];
    data.img11 = data.img11 == 99 ? 0 :  iconreal[data.img11];
    data.img12 = data.img12 == 99 ? 0 :  iconreal[data.img12];
    
    
    data.weakTmp1 = [json objectForKey:@"temp1"];
    data.weakTmp2 = [json objectForKey:@"temp2"];
    data.weakTmp3 = [json objectForKey:@"temp3"];
    data.weakTmp4 = [json objectForKey:@"temp4"];
    data.weakTmp5 = [json objectForKey:@"temp5"];
    data.weakTmp6 = [json objectForKey:@"temp6"];    
    
    NSString * temp = [json objectForKey:@"week"];
    for (int i=0; i<7; i++) {
        if([temp isEqual:[NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding]])
        {
            data.weak1 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            if(++i>6) i=0;
            data.weak2 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            if(++i>6) i=0;
            data.weak3 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            if(++i>6) i=0;
            data.weak4 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            if(++i>6) i=0;
            data.weak5 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            if(++i>6) i=0;
            data.weak6 = [NSString stringWithCString:weaktext[i] encoding:NSUTF8StringEncoding];
            break;
        }
    }
    
    _data.updateData = true;
}

-(void) reZS:(id) _json data:(weatherCityData*) _data isReadFile:(bool) isReadFile
{
    if(!_json) return;

    weatherCityData * data = _data;

    id json = [[_json JSONValue] objectForKey:@"zs"];
    
//    data.live_date = [NSString stringWithFormat:@"%@/%@/%@",[[json objectForKey:@"date"] substringWithRange:NSMakeRange(0, 4)],[[json objectForKey:@"date"] substringWithRange:NSMakeRange(4, 2)],[[json objectForKey:@"date"] substringWithRange:NSMakeRange(6, 2)]];
    
    data.ct_hint = [json objectForKey:@"ct_hint"];
    data.co_hint = [json objectForKey:@"co_hint"];
    data.gm_hint = [json objectForKey:@"gm_hint"];
    data.yd_hint = [json objectForKey:@"yd_hint"];
    data.uv_hint = [json objectForKey:@"uv_hint"];
    data.ag_hint = [json objectForKey:@"ag_hint"];
    data.xc_hint = [json objectForKey:@"xc_hint"];
    
    NSString * temp = [json objectForKey:@"date"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSString * filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSData * file = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/record.json",filepath]];

    if(!isReadFile)
    {   

        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:00"];
        temp = [formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        data.LastDate = [formatter dateFromString:temp];
        
//        self.fileData = [file JSONValue];
        id dict = [self.fileData objectAtIndex:data.index] ;
        [dict setObject:[formatter stringFromDate:data.LastDate] forKey:@"date"];
        [[self.fileData JSONRepresentation] writeToFile:[NSString stringWithFormat:@"%@/record.json",filepath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
//    [file release];

    if(data.LastDate)
    {
        [formatter setDateFormat:@"yyyy/MM/dd"];
        data.live_date = [formatter stringFromDate:data.LastDate];
        
        [formatter setDateFormat:@"MM/dd HH:mm"];
        data.refreshTime = [NSString stringWithFormat:@"更新于 %@",[formatter stringFromDate:data.LastDate]];
    }
    else
    {
        data.live_date = @"----/--/--";
        data.refreshTime = @"更新于 N/A";
    }
    [formatter release];
    
    _data.updateTime = true;
    _data.updateZS = true;
}

-(void) reWR:(id) _json data:(weatherCityData*) _data
{
    if(!_json) return;

    weatherCityData * data = _data;
    id json = [_json JSONValue];
    data.airAPIpm10cn = [json objectForKey:@"pm10"];
    data.airAPIpm25cn = [json objectForKey:@"gov"];
    data.airAPIpm25us = [json objectForKey:@"embassy"];
    data.firstContamination = [json objectForKey:@"first"];
    
    data.updateWR=true;    

}


-(void) reTime:(id) _json data:(weatherCityData*) _data
{
    if(!_json) return;

    NSString * json = [[NSString alloc] initWithData:_json encoding:NSUTF8StringEncoding];
    
    NSRange range1 = [json rangeOfString:@"<year>"];
    NSRange range2 = [json rangeOfString:@"</year>"];
    NSMutableString * date = [[NSMutableString alloc] initWithString:[json substringWithRange:NSMakeRange(range1.location+6,range2.location-range1.location-6)]] ;
    [date appendString:@"/"];
    
    range1 = [json rangeOfString:@"<month>"];
    range2 = [json rangeOfString:@"</month>"];
    [date appendString:[json substringWithRange:NSMakeRange(range1.location+7,range2.location-range1.location-7)]];
    [date appendString:@"/"];
    
    
    range1 = [json rangeOfString:@"<day>"];
    range2 = [json rangeOfString:@"</day>"];
    [date appendString:[json substringWithRange:NSMakeRange(range1.location+5,range2.location-range1.location-5)]];
    [date appendString:@" "];
    
    range1 = [json rangeOfString:@"<hour>"];
    range2 = [json rangeOfString:@"</hour>"];
    [date appendString:[json substringWithRange:NSMakeRange(range1.location+6,range2.location-range1.location-6)]];
    [date appendString:@":"];
    
    range1 = [json rangeOfString:@"<minite>"];
    range2 = [json rangeOfString:@"</minite>"];
    [date appendString:[json substringWithRange:NSMakeRange(range1.location+8,range2.location-range1.location-8)]];
    _data.live_date = [[date componentsSeparatedByString:@" "] objectAtIndex:0];
    _data.refreshTime = [NSString stringWithFormat:@"更新于: %@",date];
    [date release];
    [json release];
    _data.updateTime = true;

}

-(void) refreshNetwork:(id) sender
{
   
    int updateIndex = [sender intValue];
    
    NSString * filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL * url =nil;

    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://219.235.240.51/api/city/%@.json",@"config"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        
        [JSON writeToFile:[NSString stringWithFormat:@"%@/config.json",filepath] atomically:NO];
        
        self.cityConfig = [JSON JSONValue];
        
        [client release];  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
    }];
    
    for (int index = 0;index<[city count];index++) {
        if(updateIndex != -1 )
            if(updateIndex != index)
                continue;
        weatherCityData * data  = [city objectAtIndex:index];
        
        if(!data.updateSK)
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",data.weatherCode]];
            AFHTTPClient *client1 = [[AFHTTPClient alloc] initWithBaseURL:url];
            [client1 registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client1 getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

                [JSON writeToFile:[NSString stringWithFormat:@"%@/%@.sk",filepath,data.weatherCode] atomically:NO];
                
                [self reSK:JSON data:data];
                          
                [client1 release];  
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
            }];
        }
        
        if(!data.updateData)
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",data.weatherCode]];
            AFHTTPClient *client2 = [[AFHTTPClient alloc] initWithBaseURL:url];
            [client2 registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client2 getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                
                
                [JSON writeToFile:[NSString stringWithFormat:@"%@/%@.data",filepath,data.weatherCode] atomically:NO];

                
                [self reData:JSON data:data];
                
                [client2 release];   
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
            }];
        }
        
        if(!data.updateWR)
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://219.235.240.51/api/city/%@.json",data.weatherCode]];

            AFHTTPClient *client3 = [[AFHTTPClient alloc] initWithBaseURL:url];
//            [client3 registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client3 getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                
                [JSON writeToFile:[NSString stringWithFormat:@"%@/%@.wr3",filepath,data.weatherCode] atomically:NO];
                
                
                [self reWR:JSON data:data];
                
                
                [client3 release];   
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ErrorWR Code: %i - %@",[error code], [error localizedDescription]);
            }];

        }
        
        if(!data.updateZS)
        {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.weather.com.cn/data/zs/%@.html",data.weatherCode]];
            AFHTTPClient *client4 = [[AFHTTPClient alloc] initWithBaseURL:url];
            [client4 registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client4 getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                
                
                [JSON writeToFile:[NSString stringWithFormat:@"%@/%@.zs",filepath,data.weatherCode] atomically:NO];

                
                [self reZS:JSON data:data isReadFile:NO];
               
                [client4 release];  
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
            }];
        }
        if(0)//!data.updateTime)
        {
            url = [NSURL URLWithString:@"http://www.time.ac.cn/timeflash.asp?user=flash"];
            AFHTTPClient *client5 = [[AFHTTPClient alloc] initWithBaseURL:url];
//            [client4 registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [client5 getPath:@"" parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
                
                
                [JSON writeToFile:[NSString stringWithFormat:@"%@/%@.time",filepath,data.weatherCode] atomically:NO];
                
                
                [self reTime:JSON data:data];
                
                [client5 release];  
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
            }];
        }

    }
   
}
-(void) refreshView
{
//    NSLog(@"refreshView");
    for (int index = 0;index<[city count];index++) {
        
        weatherCityData * data  = [city objectAtIndex:index];
        
        if(data.updateData && data.updateSK && data.updateWR && data.updateZS && data.updateTime)
        {
            [((weatherTodayViewController*)[[self.tabBarController viewControllers] objectAtIndex:0]) reloadIndex:index];
            [((weatherLiveViewController*)[[self.tabBarController viewControllers] objectAtIndex:1]) reloadIndex:index];
            [((weatherWeakViewController*)[[self.tabBarController viewControllers] objectAtIndex:2]) reloadIndex:index];
            data.updateData = false;
            data.updateSK = false;
            data.updateWR = false;
            data.updateZS = false;
            data.updateTime = false;
            if(index ==0)
            {
                [self reLoaclNotifi];
            }
        }
    }

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [[[[[self tabBarController] viewControllers] objectAtIndex:0] scrollView] setContentOffset:CGPointMake(currentCityIndex*320, 0)];
    [[[[[self tabBarController] viewControllers] objectAtIndex:1] scrollView] setContentOffset:CGPointMake(currentCityIndex*320, 0)];
    [[[[[self tabBarController] viewControllers] objectAtIndex:2] scrollView] setContentOffset:CGPointMake(currentCityIndex*320, 0)];
    
    UIView * sub = [[[[[self tabBarController] viewControllers] objectAtIndex:4] helpWeather] view];
    UIView * sub2 = [[[[self tabBarController] viewControllers] objectAtIndex:4] view] ;

    for (id subview in sub2.subviews) {
        if(subview == sub)
        {
            [sub removeFromSuperview];
        }
    }
}
#pragma mark -
#pragma mark Encode Chinese to GB2312 in URL
-(NSString *)EncodeGB2312Str:(NSString *)encodeStr{
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");        
	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);        
	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
	[preprocessedString release];
	return newStr;        
}
#pragma mark -
#pragma mark net push

- (NSString *) urlVerificationEncode:(NSString *)requestFuncName
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    long long count = (long long)(timeInterval * 1000);
    NSString *valueCount = [NSString stringWithFormat:@"%lld",count];
    NSLog(@"%@=%@",@"The timeIntervalSine1970", valueCount);
    NSString *unencrypted = [@"1.1.9|" stringByAppendingFormat:@"%@", requestFuncName];
    //    unencrypted = [unencrypted stringByAppendingFormat:@"%@,%@",@"|",(NSString *)count];
    unencrypted = [unencrypted stringByAppendingFormat:@"|%@", [[NSString alloc] initWithFormat:@"%lld", count]];
    
    NSLog(@"%@", unencrypted);
    char tmp;
    char str[100] = "\0";
    int upper = [unencrypted length];
    for (int i=0 ;i < upper; i++)
    {
        tmp = [unencrypted characterAtIndex:i];
        
        
        //        (tmp % 2 == 1) ? ((strcat(str,"|"), strcat(str, chrToStringOri)))
        //        :
        //        (tmp < 64 ?strcat(str,chrToStringMul):strcat(str,chrToStringDiv));
        if(tmp % 2 ==1)
        {
            char chrToStringOri[2]={tmp};
            ((strcat(str,"|"), strcat(str, chrToStringOri)));
        }
        else 
            if(tmp < 64)
            {
                char chrToStringMul[2]={tmp*2};
                strcat(str,chrToStringMul);
            }
            else
            {
                char chrToStringDiv[2]={tmp/2};
                strcat(str,chrToStringDiv);
            }
    }
    
    printf("%s", str);
    
    //    encrypted = [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
    
    //    NSString *encrypted = [encrypted initWithUTF8String:str];
    NSString *encrypted = [NSString stringWithFormat:@"%s", str];
    
    
    NSLog(@"%@=%@",@"Encrypted String",encrypted);
    
    //    NSString *urlEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes
    //    (
    //        NULL,
    //        (CFStringRef)encrypted,
    //        NULL, 
    //        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    //        kCFStringEncodingUTF8
    //    );
    //    
    //    return urlEncoded;
    return encrypted;
    [date release];
    [valueCount release];
    [encrypted release];
    [unencrypted release];
    //    [urlEncoded release];
    free(str);
}   

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSLog(@"register for push notification succeed");
    
    NSString *pushType = @"ap";
    NSString *appid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
	NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
	NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";	
	UIDevice *dev = [UIDevice currentDevice];
//	NSString *deviceUuid = dev.uniqueIdentifier;
//    if (deviceUuid == nil) {
//        deviceUuid = @"0";
//    }
    NSString *devicemac = [self getMACAddress];
    NSLog(@"devicemac = %@", devicemac);
	NSString *deviceModel = [dev.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *deviceSystemVersion = dev.systemVersion;

    NSString *deviceToken = [[[[devToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] 
                              stringByReplacingOccurrencesOfString:@">" withString:@""] 
                             stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Device Token : %@",deviceToken);
    NSString *languageStr = [self lang];
    
    NSString *timezoneStr = [[NSTimeZone systemTimeZone] name];
    NSLog(@"timezoneStr = %@", timezoneStr);
    
    NSString *secondsfromGMTStr = [NSString stringWithFormat:@"%d", [[NSTimeZone systemTimeZone] secondsFromGMT]];
    
    NSString *validationCode = [self urlVerificationEncode:(@"authorization")];	
#pragma mark push http
    
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{
	NSLog(@"Error in registration. Error: %@", err);
    [self setPushRecord_NO];

}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
#pragma mark -
#pragma mark Register a local notification

-(NSString *) NotifyTmpWith:(NSString*) tmp status:(int) img
{
    weatherCityData* _city = [self.city objectAtIndex:0];

    switch (img) {
        case 1:
            img = _city.img1;
            break;
        case 2:
            img = _city.img3;
            break;
        case 3:
            img = _city.img5;
            break;
        case 4:
            img = _city.img7;
            break;
        case 5:
            img = _city.img9;
            break;
        case 6:
            img = _city.img11;
            break;
        default:
            break;
    }
    NSString * status = [NSString stringWithUTF8String:tmpStatus(img)];
    NSString * result = nil;
    int  temp = [[[tmp componentsSeparatedByString:@"℃"] objectAtIndex:0] intValue];
    if([status isEqual:@"正常"])
    {
        if(temp >20)
        {
            result = [NSString stringWithFormat:@"日气温%d度,适宜穿轻薄或单层棉麻类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }else if(temp <= 20 && temp >= 5)
        {
            result = [NSString stringWithFormat:@"日气温%d度,适宜穿套装夹克、毛衣、防寒类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }else if(temp <5)
        {
            result = [NSString stringWithFormat:@"日气温%d度,适宜穿棉衣、厚外套、羽绒服类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }
    }else if([status isEqual:@"雨"])
    {
        if(temp >20)
        {
            result = [NSString stringWithFormat:@"日气温%d度,有雨,地面湿滑,建议携带雨具,适宜穿轻薄或单层棉麻类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }else if(temp <= 20 && temp >= 5)
        {
            result = [NSString stringWithFormat:@"日气温%d,有雨,地面湿滑,建议携带雨具,适宜穿夹克、套装、毛衣类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }else if(temp <5)
        {
            result = [NSString stringWithFormat:@"日气温%d,有雨,地面湿滑,建议携带雨具,适宜穿棉衣、厚外套、羽绒服类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
        }
    }else if([status isEqual:@"雪"])
    {
        result = [NSString stringWithFormat:@"日气温%d,有雪,地面湿滑出门请小心,适宜穿棉衣、厚外套、羽绒服类衣服,更多穿衣建议及pm2.5数据请开启软件",temp];
    }
    
    
    return result;
}
-(void) reLocalNotifiWithTime:(NSString*) weakTime afterDay:(int) weakDay
{    
    UILocalNotification *notification=nil; 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString * nowdate = nil;
    NSDate * now = nil;
    NSArray * tmp = [weakTime componentsSeparatedByString:@"~"];
    NSString * body = [self NotifyTmpWith:[tmp objectAtIndex:1] status:weakDay+1];
    
    [formatter setDateFormat:@"HH"];

    if(weakDay != 1 || [[formatter stringFromDate:[NSDate date]] intValue] < 19)
    {
        [formatter setDateFormat:@"yyyy/MM/dd 19:00:00"];
        nowdate = [formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        now = [formatter dateFromString:nowdate];
        notification=[[UILocalNotification alloc] init]; 
        if (notification!=nil) {//判断系统是否支持本地通知
            notification.fireDate=[now addTimeInterval:3600*24*(weakDay-1)];//本次开启立即执行的周期
            notification.repeatInterval=0;//循环通知的周期
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.alertBody= [NSString stringWithFormat:@"明%@",body];//弹出的提示信息
            notification.soundName= nil;//本地化通知的声音
            notification.alertAction = @"天气预报";  //弹出的提示框按钮
            [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
            [notification release];
        } 
    }
    
    [formatter setDateFormat:@"yyyy/MM/dd 07:30:00"];
    nowdate = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    now = [formatter dateFromString:nowdate];
    
    notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {//判断系统是否支持本地通知
        notification.fireDate=[now addTimeInterval:3600*24*weakDay];//本次开启立即执行的周期
        notification.repeatInterval=0;//循环通知的周期
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=[NSString stringWithFormat:@"今%@",body] ;//弹出的提示信息
        notification.soundName= nil;//本地化通知的声音
        notification.alertAction = @"天气预报";  //弹出的提示框按钮
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
        [notification release];
    } 
    


    [formatter release];

}
-(void) reLoaclNotifi
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
    weatherCityData* _city = [self.city objectAtIndex:0];
    
    [self reLocalNotifiWithTime:_city.weakTmp2 afterDay:1];
    [self reLocalNotifiWithTime:_city.weakTmp3 afterDay:2];
    [self reLocalNotifiWithTime:_city.weakTmp4 afterDay:3];
    [self reLocalNotifiWithTime:_city.weakTmp5 afterDay:4];
    [self reLocalNotifiWithTime:_city.weakTmp6 afterDay:5];

}

-(void) registerLocalNotification:(int) notifyType 

{
    
	NSLog(@"Registering Local Notification with type:%d",notifyType);
	NSDate *now = [NSDate date];
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	if (1){//localNotif == nil) {
		NSLog(@"can't create local notification object. And I don't know why.");
	}
    return;
	localNotif.timeZone = [NSTimeZone defaultTimeZone];
	localNotif.soundName = nil;
	
	localNotif.fireDate = [now dateByAddingTimeInterval:30];
	localNotif.alertBody = [NSString stringWithFormat:@"测试推送"];
	localNotif.alertAction = @"确定";
    
	// 注册之
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	[localNotif release];
	
}
#pragma mark -
#pragma mark Push Show Views

-(void) showLocalNotification:(UILocalNotification *)notification {
	
	
//	// 根据 [[notification.userInfo objectForKey:@"notifyType"] intValue]的值，显示相应的本地推送信息界面，共6种
//
	NSLog(@"notifyType: %d",[[notification.userInfo objectForKey:@"notifyType"] intValue]);
//
//	// 以下为推送处理代码
//	
//	Local *local = [[Local alloc] initWithNibName:@"Local" bundle:nil];
//	[self.navigationController pushViewController:local animated:YES];
//	[local release];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	self.pushInfo = userInfo;
	if (application.applicationState == UIApplicationStateInactive) {
		// 用户点击推送的确认按钮进入，直接弹推送的内容
		NSLog(@"用户点击推送的确认按钮进入，直接弹本地推送的内容");
	}
	if (application.applicationState == UIApplicationStateActive) {
		// 当前程序正在运行中，弹一个AlertView通知用户
		NSLog(@"当前程序正在运行中，弹一个AlertView通知用户");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
														message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
													   delegate:self
											  cancelButtonTitle:@"关闭"
											  otherButtonTitles:@"显示",nil];
		[alert show];
		[alert release];
	}		
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//	if (notification) {
//		if (application.applicationState == UIApplicationStateInactive) {
//			// 用户点击本地推送的确认按钮进入，直接弹本地推送的内容
//			NSLog(@"用户点击本地推送的确认按钮进入，直接弹本地推送的内容");
//			[self showLocalNotification:notification];
//		}
//		if (application.applicationState == UIApplicationStateActive) {
//			// 不进行任何操作，直接再根据当前的状况，重新预定一次
//			[self registerLocalNotification:0];
//		}
//    }
//	// 在处理完通知后，清空程序图标
//	application.applicationIconBadgeNumber = 0;
}
- (NSString *)lang
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
- (NSString*)getMACAddress
{
	int                 mib[6];
	size_t              len;
	char                *buf;
	unsigned char       *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl  *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) 
	{
		NSLog(@"Error: if_nametoindex error\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
	{
		NSLog(@"Error: sysctl, take 1\n");
		return NULL;
	}
	
	if ((buf = (char*)malloc(len)) == NULL) 
	{
		NSLog(@"Could not allocate memory. error!\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) 
	{
		NSLog(@"Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *macAddress = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
                            *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	macAddress = [macAddress lowercaseString];
	free(buf);
	
	return macAddress;
}


#pragma mark network push
-(void)setPushRecord_YES{
	
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setValue:appVersion forKey:@"appVersion"];
    [def setBool:YES forKey:@"registerNetWork_SUCCESS"];
	
	
}
-(void)setPushRecord_NO{
	
	
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
	[def setValue:@"0" forKey:@"appVersion"];
	
    [def setBool:NO forKey:@"registerNetWork_SUCCESS"];
	
}
-(BOOL)readPushRecord{
	
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	NSString *str=[def stringForKey:@"appVersion"];
	
	
	if (![str isEqualToString:appVersion])
	{
		[self setPushRecord_NO];
	}
	
	return [def boolForKey:@"registerNetWork_SUCCESS"];
	
}
-(void)registerNetWorkPush{
	
	
	
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	NSLog(@"版本号:==================%@",appVersion);	
	
    if ([self readPushRecord] == NO) {
        
		NSLog(@"推送:==================push");	
		
		
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        [self setPushRecord_YES];
    }
}

#pragma mark- IAP

-(void)didReceivedProducts:(NSArray *)products
{
    SKProduct * product = [products objectAtIndex:0];
    NSLog(@"%@",product.productIdentifier);
    [[ECPurchase shared] addPayment:product.productIdentifier];
    
}
-(void)didCompleteTransactionAndVerifySucceed:(NSString *)proIdentifier
{
    NSLog(@"sucess proID =%@",proIdentifier);
}
-(void)didCompleteTransactionAndVerifyFailed:(NSString *)proIdentifier withError:(NSString *)error
{
    NSLog(@"Failed proID =%@,error = %@",proIdentifier,error);

}
-(void)didFailedTransaction:(NSString *)proIdentifier
{
    NSLog(@"Failed proID =%@",proIdentifier);

}
-(void)didRestoreTransaction:(NSString *)proIdentifier
{
    NSLog(@"RestoreT proID =%@",proIdentifier);

}
@end
