//
//  weatherLiveSubViewController.m
//  weather
//
//  Created by duangl on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherLiveSubViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSObject+SBJson.h"
#import "weatherAppDelegate.h"

@implementation weatherLiveSubViewController
@synthesize data;
@synthesize title; //标题
@synthesize ct_hint; //穿衣
@synthesize co_hint; //舒适度
@synthesize gm_hint; //感冒
@synthesize yd_hint; //运动
@synthesize sd;      //空气湿度
@synthesize uv_hint; //紫外线 
@synthesize refresh;
@synthesize ag_hint; //污染
@synthesize xc_hint; //洗车
@synthesize refreshTime;
@synthesize todayDate;
@synthesize background;
@synthesize refreshImage;
@synthesize refreshLastTime;
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
    // Do any additional setup after loading the view from its nib.
//    [self refreshData:nil];
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    [background setImage:[UIImage imageNamed:[app.backgroundLive objectAtIndex:data.bgID]]];
    [refreshImage setImage:[UIImage imageNamed:[app.refbtn objectAtIndex:data.bgID]]];
    [refreshImage startRotatingWithSpeed:15 WithStep:20];

//    [title setShadowColor:[app.textColor objectAtIndex:data.bgID]];
    [ct_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [co_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [gm_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [yd_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [sd setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [uv_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [ag_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [xc_hint setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [refreshLastTime setTextColor:[app.textColor objectAtIndex:data.bgID]];

    [refreshTime setTextColor:[app.textColor objectAtIndex:data.bgID]];
    
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
-(IBAction)iap:(id)sender
{
    UIButton * button = sender;
    if(button.tag == 0)
    {
        [[ECPurchase shared] requestProductData:[NSArray arrayWithObjects:@"com.cicada.zawether.pro",nil]];
    }else if(button.tag == 1)
    {
        [[ECPurchase shared] requestProductData:[NSArray arrayWithObjects:@"com.cicada.zawether.hello",nil]];
    }
}
-(void) loadBG
{
    if(!self.background.image)
    {
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
        UIImage * image2 = GetImage([[app backgroundLive] objectAtIndex:data.bgID]);
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

-(IBAction)refresh:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [app refresh:data.tags];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)refreshData:(id)sender
{
    [[self ct_hint] setText:self.data.ct_hint];
    [[self co_hint] setText:self.data.co_hint];
    [[self gm_hint] setText:self.data.gm_hint];
    [[self yd_hint] setText:self.data.yd_hint];
    [[self uv_hint] setText:self.data.uv_hint];
    [[self ag_hint] setText:self.data.ag_hint];
    [[self xc_hint] setText:self.data.xc_hint];
    [[self sd] setText:self.data.sd];
    [[self title] setText:self.data.cityName];
    [[self todayDate] setText:self.data.live_date];
    [self refreshLastTimer];
    [[self refreshTime] setText:data.refreshTime];
}

-(void) refreshLastTimer
{
    if(data.LastDate)
        [self.refreshLastTime setText:[NSString stringWithFormat:@"距上次更新%d分钟",((int)-[data.LastDate timeIntervalSinceNow])/60]];
    else
        self.refreshLastTime.text = @"等待更新";
}
@end
