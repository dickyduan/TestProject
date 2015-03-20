//
//  weatherHelpViewController.m
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "weatherHelpViewController.h"
#import "weatherAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@implementation weatherHelpViewController
@synthesize background;
@synthesize text;
@synthesize closed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"帮助说明";
        self.tabBarItem.image = [UIImage imageNamed:@"baricon_5"];
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
//    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
//    
//    [background setImage:[UIImage imageNamed:[app.backgroundAddCity objectAtIndex:[[app.city objectAtIndex:app.currentCityIndex] bgID]]]];
//    [closed setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
//    [closed setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//
//
//}
- (void)viewWillAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    [background setImage:[UIImage imageNamed:[app.backgroundAddCity objectAtIndex:[[app.city objectAtIndex:app.currentCityIndex] bgID]]]];
    [closed setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_1",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateNormal];
    [closed setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d_2",[[app.city objectAtIndex:app.currentCityIndex] bgID]+1]] forState:UIControlStateHighlighted];
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)Closed:(id)sender
{
    [self.view removeFromSuperview];
}

@end
