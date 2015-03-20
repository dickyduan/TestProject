//
//  weatherTodaySubViewController.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherTodaySubViewController.h"
#import "weatherAppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "NSObject+SBJson.h"
#include "caledate.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/CALayer.h>

static int manid [32][7] = {
	{1,	1,	7,	11,	11,	11,	11},
	{2,	2,	6,	11,	11,	11,	11},
	{2,	2,	6,	11,	11,	11,	11},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{2,	2,	6,	11,	11,	11,	11},
	{5,	5,	10,	14,	14,	14,	14},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{3,	3,	8,	12,	12,	12,	12},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{4,	4,	9,	13,	13,	13,	13},
	{6,	6,	6,	11,	11,	11,	11},
	{6,	6,	6,	11,	11,	11,	11},
	{6,	6,	6,	11,	11,	11,	11}
};
static int manid2 [32][7] = {
    {2, 2, 6, 11, 11, 11, 11},
    {2, 2, 6, 11, 11, 11, 11},
    {2, 2, 6, 11, 11, 11, 11},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {2, 2, 6, 11, 11, 11, 11},
    {5, 5, 10, 14, 14, 14, 14},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {3, 3, 8, 12, 12, 12, 12},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {4, 4, 9, 13, 13, 13, 13},
    {6, 6, 6, 11, 11, 11, 11},
    {6, 6, 6, 11, 11, 11, 11},
    {6, 6, 6, 11, 11, 11, 11}
};
static char * testchar[7] = {
	"优",
	"良",
	"轻微污染",
	"轻度污染",
	"中度污染",
	"中度重污染",
	"重污染"
};
@implementation weatherTodaySubViewController
@synthesize data;
@synthesize refresh;
@synthesize cityName;
@synthesize todayTmp;
@synthesize currentTmp;
@synthesize airAPI;
@synthesize airRegime;
@synthesize firstContamination;
@synthesize background;
@synthesize feng;
@synthesize airAPITitle;
@synthesize refreshTime;
@synthesize refreshImage;
@synthesize man;
@synthesize refreshLastTime;
@synthesize pm;
@synthesize tagImage;
@synthesize blank,flagConfig;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
 
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self refreshData:nil];
    // Do any additional setup after loading the view from its nib.
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    if([data.data.cityName length] == 0)
//        return;
    
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [[NSBundle mainBundle] pathForResource:@"" ofType:@""];
    
//    [self loadBG];
    [refreshImage setImage:[UIImage imageNamed:[app.refbtn objectAtIndex:data.bgID]]];
    [refreshImage startRotatingWithSpeed:15 WithStep:20];
    [airAPITitle setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [airAPI setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [firstContamination setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [airRegime setShadowColor:[app.textColor objectAtIndex:data.bgID]];
    [refreshTime setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [refreshLastTime setTextColor:[app.textColor objectAtIndex:data.bgID]];

    [pm setTextColor:[app.textColor objectAtIndex:data.bgID]];

    id flag = [[NSUserDefaults standardUserDefaults] objectForKey:data.weatherCode];
    if(flag)
    {
        switchFlag = [flag intValue];
    }
    else 
    {
        switchFlag = 0;
    }
    
    [self refreshData:nil];

}
-(void) clearBG
{
    if(self.background.image)
    {
        self.background.image = nil;
        [refreshImage stopRotating];

    }
}
-(void) loadBG
{
    if(!self.background.image)
    {
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
        UIImage * image2 = GetImage([[app backgroundToday] objectAtIndex:data.bgID]);
        [self.background setImage:image2];
        [image2 release];
        [refreshImage startRotatingWithSpeed:15 WithStep:20];
    }
}

- (void)viewDidUnload
{
    [self clearBG];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)sendShare:(id)sender
{

    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"微博分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:@"新浪微博",@"腾讯微博", nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet showFromRect:app.tabBarController.view.bounds inView:app.tabBarController.view animated:YES];
    [sheet release];
 
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
    if (buttonIndex == actionSheet.cancelButtonIndex) 
    { return; }
    
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    switch (buttonIndex) 
    { 
        case 0: { 
            XShare * share = [[XShare alloc] initWithNibName:@"XShare" bundle:nil];
            share.delegate = self;
            share.type = 1;
            [app.tabBarController presentModalViewController:share animated:YES];
            [share release];
            break; 
        } 
        case 1: { 
            XShare * share = [[XShare alloc] initWithNibName:@"XShare" bundle:nil];
            share.delegate = self;
            share.type = 2;
            [app.tabBarController presentModalViewController:share animated:YES];
            [share release];
            break; 
        } 
    } 
}
-(void) viewInited:(XShare*) share
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    int *net = NULL;
//    NSString * string = nil;
    NSString * string = [NSString stringWithFormat:@"%@ #空气质量报告# %@ 空气污染指数 %@ %@ 空气质量等级 %@ ,欢迎使用 #全国天气监测# 下载地址：http://itunes.apple.com/cn/app/id503814207?mt=8",data.live_date,data.cityName,self.airAPI.text,self.firstContamination.text,self.airRegime.text];
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.view.frame.size);
    }      
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [share setWithbackground:[[app backgroundHelp] objectAtIndex:data.bgID]  buttonNormal:[NSString stringWithFormat:@"btn%d_1",data.bgID+1] buttonHighly:[NSString stringWithFormat:@"btn%d_2",data.bgID+1] text:string image:image2];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)refreshData:(id)sender
{

    
    [self.cityName setText:self.data.cityName];
    [self.currentTmp setText:self.data.currentTmp];
    [self.todayTmp setText:self.data.todayTmp];
//    self.airAPI.text = self.data.airAPI;
//    self.airRegime.text = self.data.airRegime;
    [self.feng setText:[NSString stringWithFormat:@"%@ %@",data.fengxiang,data.fengli]];
    
    [self.refreshTime setText:data.refreshTime];
    [self refreshLastTimer];
//  [self.refreshLastTime setText:[NSString stringWithFormat:@"距上次更新%d分钟",((int)-[data.LastDate timeIntervalSinceNow])/60]];
    self.flagConfig = 0;
    if ([self.data.airAPIpm25us intValue] != -1)
        self.flagConfig++;
    if([self.data.airAPIpm25cn intValue] != -1)
        self.flagConfig++;
    if([self.data.airAPIpm10cn intValue] != -1)
        self.flagConfig++;
    self.blank.hidden = flagConfig>1;
    [self setFlag:switchFlag] || [self setFlag:++switchFlag] || [self setFlag:++switchFlag];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int hh =[[formatter stringFromDate: [NSDate date]] intValue];
    [formatter release];
    for (int i=0; i<7; i++) 
    {
        if([airRegime.text isEqual:[NSString stringWithCString:testchar[i] encoding:NSUTF8StringEncoding]])
        {
            self.data.manid = (hh>6&&hh<18)?manid[data.img1][i]:manid2[data.img1][i];
            [self.man setImage:[UIImage imageNamed:[NSString stringWithFormat:@"man%d",data.manid]]];
            break;
        }
    }
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",(hh>6&&hh<18)?@"w1bicon":@"w1wicon",data.img1]]];

}

-(IBAction)refresh:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [app refresh:data.tags];
}
-(void) refreshLastTimer
{
    if(data.LastDate)
        [self.refreshLastTime setText:[NSString stringWithFormat:@"距上次更新%d分钟",((int)-[data.LastDate timeIntervalSinceNow])/60]];
    else
        self.refreshLastTime.text = @"等待更新";
}
-(IBAction)switchTag:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    if(self.flagConfig>1)
    {
        [app.HUD show:YES];
        [app.HUD hide:YES afterDelay:0.3];
    }
    [self setFlag:++switchFlag] || [self setFlag:++switchFlag] || [self setFlag:++switchFlag];   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int hh =[[formatter stringFromDate: [NSDate date]] intValue];
    [formatter release];
    for (int i=0; i<7; i++) 
    {
        if([airRegime.text isEqual:[NSString stringWithCString:testchar[i] encoding:NSUTF8StringEncoding]])
        {
            self.data.manid = (hh>6&&hh<18)?manid[data.img1][i]:manid2[data.img1][i];
            [self.man setImage:[UIImage imageNamed:[NSString stringWithFormat:@"man%d",data.manid]]];
            break;
        }
    }
    
}
-(bool) setFlag:(int) flag
{
    switch (flag%3) {
        case 0:
        {
            if(!data.airAPIpm25us || [data.airAPIpm25us intValue] == -1)
                return NO;
            self.airAPI.text = data.airAPIpm25us;
            self.airRegime.text = [NSString stringWithUTF8String:caleApi2([data.airAPIpm25us intValue])];
            self.firstContamination.text = [NSString stringWithFormat:@"首要污染物 %@",@"可吸入颗粒物"];
            self.pm.text = @"PM2.5";
            self.tagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag4_%d",data.bgID+1]];
        }
            break;
        case 1:
        {
            if(!data.airAPIpm25cn || [data.airAPIpm25cn intValue] == -1)
                return NO;
            self.airAPI.text = data.airAPIpm25cn;
            self.airRegime.text = [NSString stringWithUTF8String:caleApi2([data.airAPIpm25cn intValue])];
            self.firstContamination.text = [NSString stringWithFormat:@"首要污染物 %@",@"可吸入颗粒物"];
            self.pm.text = @"PM2.5";
            self.tagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag3_%d",data.bgID+1]];
        }
            break;
        case 2:
        {
            if(!data.airAPIpm10cn || [data.airAPIpm10cn intValue] == -1)
            {
//                self.airAPI.text = @"获取中";
//                self.airRegime.text = @"获取中";
//                self.firstContamination.text = [NSString stringWithFormat:@"首要污染物 %@",@"获取中"];
//
//                self.firstContamination.text = @"获取中";
                return NO;
            }
            else
            {
                self.airAPI.text = data.airAPIpm10cn;
                self.airRegime.text = [NSString stringWithUTF8String:caleApi2([data.airAPIpm10cn intValue])];
                self.firstContamination.text = [NSString stringWithFormat:@"首要污染物 %@",data.firstContamination];
            }
            self.pm.text = @"PM10";
            self.tagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"tag3_%d",data.bgID+1]];
        }
            break;
        default:
            break;
    }
    switchFlag = flag%3;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:flag] forKey:data.weatherCode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

@end
