//
//  weatherShareViewController.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherShareViewController.h"
#import "weatherAppDelegate.h"
#import "weatherTodayViewController.h"
#import "weatherTodaySubViewController.h"
#import "NSObject+SBJson.h"
#import <QuartzCore/QuartzCore.h>

@interface weatherShareViewController (Private)

- (void)dismissTimelineViewController;
- (void)presentTimelineViewController:(BOOL)animated;
- (void)presentTimelineViewControllerWithoutAnimation;

@end

@implementation weatherShareViewController
@synthesize background;
@synthesize helpWeather;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"更多";
        self.tabBarItem.image = [UIImage imageNamed:@"baricon_7"];
        helpWeather = [[weatherHelpViewController alloc] initWithNibName:@"weatherHelpViewController" bundle:nil] ;
        [self.view addSubview:helpWeather.view];
        [helpWeather.view removeFromSuperview];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
//    [engine setRootViewController:self];
//    [engine setDelegate:self];
//    [engine setRedirectURI:@""];
//    [engine setIsUserExclusive:NO];
//    self.weiBoEngine = engine;
//    [engine release];
    

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated;     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    [background setImage:[UIImage imageNamed:[app.backgroundShare objectAtIndex:[[app.city objectAtIndex:app.currentCityIndex] bgID]]]];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)sinaWeibo:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    XShare * share = [[XShare alloc] initWithNibName:@"XShare" bundle:nil];
    share.delegate = self;
    share.type = 1;
    [app.tabBarController presentModalViewController:share animated:YES];
    [share release];
}
-(IBAction)tencentWeibo:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    XShare * share = [[XShare alloc] initWithNibName:@"XShare" bundle:nil];
    share.delegate = self;
    share.type = 2;
    [app.tabBarController presentModalViewController:share animated:YES];
    [share release];
    
}
-(IBAction)goTOhelp:(id)sender
{
    [helpWeather viewWillAppear:YES];
    
    [self.view addSubview:helpWeather.view];
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setType:@"rippleEffect"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self.view layer]addAnimation:animation forKey:@"rippleEffect"];
}
-(void) viewInited:(XShare*) share
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    weatherCityData * data = [[app city] objectAtIndex:[app currentCityIndex]];
    NSString * string = @"#天气质量报告# 全国控制质量与#天气情况#超强监控。最全面的信息，最新颖的设计，最酷的天气类应用程序！#全国天气监测# 下载地址：http://itunes.apple.com/cn/app/id503814207?mt=8";
    
    UIImage * image2 = GetImage(@"share1");
    [share setWithbackground:[[app backgroundHelp] objectAtIndex:data.bgID]  buttonNormal:[NSString stringWithFormat:@"btn%d_1",data.bgID+1] buttonHighly:[NSString stringWithFormat:@"btn%d_2",data.bgID+1] text:string image:image2];
    [image2 release];
}

@end
