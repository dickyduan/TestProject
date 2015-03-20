//
//  weatherWeakSubViewController.m
//  weather
//
//  Created by duangl on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherWeakSubViewController.h"
#import "UIImageView+AFNetworking.h"
#import "weatherAppDelegate.h"
@implementation weatherWeakSubViewController

@synthesize cityName;
@synthesize currentTmp;
@synthesize image;

@synthesize weakTmp1;
//@synthesize weakTmp2;
@synthesize weakTmp3;
//@synthesize weakTmp4;
@synthesize weakTmp5;
//@synthesize weakTmp6;
@synthesize weakTmp7;
//@synthesize weakTmp8;
@synthesize weakTmp9;
//@synthesize weakTmp10;
@synthesize weakTmp11;
//@synthesize weakTmp12;

@synthesize weak1;
@synthesize weak2;
@synthesize weak3;
@synthesize weak4;
@synthesize weak5;
@synthesize weak6;

@synthesize weakImg1;
@synthesize weakImg2;
@synthesize weakImg3;
@synthesize weakImg4;
@synthesize weakImg5;
@synthesize weakImg6;
@synthesize background;
@synthesize refreshImage;
@synthesize refreshText;
@synthesize refreshLastTime;

@synthesize data;
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
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

//     [background setImage:[UIImage imageNamed:[[app backgroundWeak] objectAtIndex:data.bgID]]];
    
    [weakTmp1 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weakTmp2 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weakTmp3 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weakTmp4 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weakTmp5 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weakTmp6 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    
    [weak1 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weak2 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weak3 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weak4 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weak5 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [weak6 setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [refreshText setTextColor:[app.textColor objectAtIndex:data.bgID]];
    [refreshLastTime setTextColor:[app.textColor objectAtIndex:data.bgID]];

    [refreshImage setImage:[UIImage imageNamed:[app.refbtn objectAtIndex:data.bgID]]];
    [refreshImage startRotatingWithSpeed:15 WithStep:20];

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
        UIImage * image2 = GetImage([[app backgroundWeak] objectAtIndex:data.bgID]);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)refresh:(id)sender
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [app refresh:data.tags];
}
-(void)refreshData:(id)sender
{
    [weakTmp1 setText:data.weakTmp1];
    [weakTmp2 setText:data.weakTmp2];
    [weakTmp3 setText:data.weakTmp3];
    [weakTmp4 setText:data.weakTmp4];
    [weakTmp5 setText:data.weakTmp5];
    [weakTmp6 setText:data.weakTmp6];
    
    [weak1 setText:data.weak1];
    [weak2 setText:data.weak2];
    [weak3 setText:data.weak3];
    [weak4 setText:data.weak4];
    [weak5 setText:data.weak5];
    [weak6 setText:data.weak6];
    
    [weakImg1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img1]]];
//    [weakImg2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img2]]];
    [weakImg3 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img3]]];
//    [weakImg4 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img4]]];
    [weakImg5 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img5]]];
//    [weakImg6 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img6]]];
    [weakImg7 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img7]]];
//    [weakImg8 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img8]]];
    [weakImg9 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img9]]];
//    [weakImg10 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img10]]];
    [weakImg11 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dbicon%d",data.bgID+1,data.img11]]];
//    [weakImg12 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"w2s%dwicon%d",data.bgID+1,data.img12]]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int hh =[[formatter stringFromDate: [NSDate date]] intValue];
    [formatter release];
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",(hh>6&&hh<18)?@"w2bicon":@"w2wicon",data.img1]]];
    
    [self refreshLastTimer];

    [currentTmp setText:data.currentTmp];
    [cityName setText:data.cityName];
    [refreshText setText:data.refreshTime];

}
-(void) refreshLastTimer
{
    if(data.LastDate)
        [self.refreshLastTime setText:[NSString stringWithFormat:@"距上次更新%d分钟",((int)-[data.LastDate timeIntervalSinceNow])/60]];
    else
        self.refreshLastTime.text = @"等待更新";
}
@end
