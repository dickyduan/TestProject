//
//  FiveViewController.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FiveViewController.h"
#import "AppDelegate.h"
#import "SettingController.h"
#import "DetailController.h"
#import "Correct Controller.h"
#import "Mytools.h"
#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 80.0
#define CAP_WIDTH 5.0

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;

@interface FiveViewController (PrivateMethods)
-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location;
-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText;
@end

@implementation FiveViewController
@synthesize m_UsedLabel;
@synthesize m_UnusedLabel;
@synthesize m_UnsetLabel;
@synthesize m_MonthLabel;
@synthesize m_MLabel;
@synthesize m_MonthRateLabel;
@synthesize m_MsgBtn;
@synthesize m_RecordBtn;
@synthesize myNetList, imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"流量", @"流量");
        self.tabBarItem.image = [UIImage imageNamed:@"optimize_net.png"];
        myNetList = [[MyNetList alloc] init];
        isNote = true;
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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    if(MYSYSVER<5.0)
    {
        
//        UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//        Name.textColor = [Mytools colorWithHexString:@"0xffffff"];
//        Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//        Name.textAlignment = UITextAlignmentCenter;
//        Name.backgroundColor = [UIColor clearColor];
//        Name.numberOfLines = 0;
//        Name.text = @"流量";
//        [self.navigationController.navigationBar insertSubview:Name atIndex:2];
//        [Name release];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidUnload
{
    [m_UsedLabel release];
    m_UsedLabel = nil;
    [self setM_UsedLabel:nil];
    [m_UnusedLabel release];
    m_UnusedLabel = nil;
    [self setM_UnusedLabel:nil];
    [m_UnsetLabel release];
    m_UnsetLabel = nil;
    [self setM_UnsetLabel:nil];
    [m_MonthLabel release];
    m_MonthLabel = nil;
    [self setM_MonthLabel:nil];
    [m_MLabel release];
    m_MLabel = nil;
    [self setM_MLabel:nil];
    [m_MonthRateLabel release];
    m_MonthRateLabel = nil;
    [self setM_MonthRateLabel:nil];
    [m_MsgBtn release];
    m_MsgBtn = nil;
    [self setM_MsgBtn:nil];
    [m_RecordBtn release];
    m_RecordBtn = nil;
    [self setM_RecordBtn:nil];
    [segmentControlTitles release];
    [myNetList release];
    [self setMyNetList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [myNetList updataMyNetList];
    
    if([myNetList m_Used] < 0.01)
        m_UsedLabel.text = @"0";
    else
        m_UsedLabel.text = [NSString stringWithFormat:@"%0.2f", [myNetList m_Used]];
    
    if([myNetList m_Above] < 0.01)
        m_UnusedLabel.text = @"0";
    else
        m_UnusedLabel.text = [NSString stringWithFormat:@"%0.2f", [myNetList m_Above]];
    
    if([myNetList m_Month] < 0.01)
    {
        m_UnsetLabel.text = @"未设置";
        m_MonthLabel.text = @"";
        m_MLabel.text = @"";
    }
    else
    {
        m_MonthLabel.text = [NSString stringWithFormat:@"%0.2f", [myNetList m_Month]];
        m_UnsetLabel.text = @"";
        m_MLabel.text = @"M";
    }
    
    if(myNetList.m_Month > 0.01)
    {
        m_MonthRateLabel.text = [NSString stringWithFormat:@"%d%%", (int)(100*myNetList.m_Used/myNetList.m_Month)];
        self.imageView.frame= CGRectMake(imageView.frame.origin.x, 13 + 174 *(1-(100*myNetList.m_Used/myNetList.m_Month)/100.0), 6, 174 *(100*myNetList.m_Used/myNetList.m_Month)/100.0);
        if(isNote && 100*myNetList.m_Used/myNetList.m_Month> myNetList.m_Note)
        {
            NSString *msg = [NSString stringWithFormat:@"您本月已用流量已超过了套餐流量的%d%%, 请注意节约您的流量！", myNetList.m_Note];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            isNote = false;
        }
    }
    else
    {
        m_MonthRateLabel.text = @"0%";
        self.imageView.frame = CGRectMake(imageView.frame.origin.x, 13+174, 6, 0);
    }
    
    self.navigationItem.rightBarButtonItem = [self woodBarButtonItemWithText:@"设置"];
    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(SettingAction:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%@",self.navigationController.navigationBar.subviews);
    
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    [m_UsedLabel release];
    [m_UsedLabel release];
    [m_UnusedLabel release];
    [m_UnusedLabel release];
    [m_UnsetLabel release];
    [m_UnsetLabel release];
    [m_MonthLabel release];
    [m_MonthLabel release];
    [m_MLabel release];
    [m_MLabel release];
    [m_MonthRateLabel release];
    [m_MonthRateLabel release];
    [m_MsgBtn release];
    [m_MsgBtn release];
    [m_RecordBtn release];
    [m_RecordBtn release];
    [myNetList release];
    [super dealloc];
}

#pragma mark -
#pragma mark CustomSegmentedControlDelegate
- (UIButton*) buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
    CapLocation location;
    if (segmentIndex == 0)
        location = CapLeft;
    else if (segmentIndex == segmentControlTitles.count - 1)
        location = CapRight;
    else
        location = CapMiddle;
    
    UIButton* button = [self woodButtonWithText:[segmentControlTitles objectAtIndex:segmentIndex] stretch:location];
    if (segmentIndex == 0)
        button.selected = YES;
    return button;
}

- (void) touchDownAtSegmentIndex:(NSUInteger)segmentIndex
{
    [[[[UIAlertView alloc] initWithTitle:[segmentControlTitles objectAtIndex:segmentIndex]
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil 
                       otherButtonTitles:NSLocalizedString(@"OK", nil), nil] autorelease] show];
}

-(UIBarButtonItem*)woodBarButtonItemWithText:(NSString*)buttonText
{
    return [[[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:buttonText stretch:CapLeftAndRight]] autorelease];
}

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    NSUInteger buttonWidth = 0;
    if (location == CapLeftAndRight)
    {
        buttonWidth = BUTTON_WIDTH;
        buttonImage = [[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    }
    else
    {
        buttonWidth = BUTTON_SEGMENT_WIDTH;
        
        buttonImage = [self image:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
        buttonPressedImage = [self image:[[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

- (void)SettingAction:(id)sender
{
    SettingController * tmpViewController = [[[SettingController alloc] initWithNibName:@"SettingController" bundle:nil] autorelease];
    [self.navigationController pushViewController:tmpViewController animated:YES];
}

-(IBAction)sendMsg:(id)sender
{
    Correct_Controller * tmpViewController = [[[Correct_Controller alloc] initWithNibName:@"Correct Controller" bundle:nil] autorelease];
    [self.navigationController pushViewController:tmpViewController animated:YES];
}

-(IBAction)seeDetail:(id)sender
{
    DetailController * tmpViewController = [[[DetailController alloc] initWithNibName:@"DetailController" bundle:nil] autorelease];
    [self.navigationController pushViewController:tmpViewController animated:YES];
}
@end
