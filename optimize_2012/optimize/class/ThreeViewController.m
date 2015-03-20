//
//  ThreeViewController.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThreeViewController.h"
#import "Mytools.h"
#import "UIDevice-Hardware.h"
#import "AppDelegate.h"
@implementation ThreeViewController
@synthesize LabeLatteryleft;
@synthesize LabelBatteryState;
@synthesize myBattery;
@synthesize tableView;
@synthesize phoneInfo;
@synthesize ImgBattery;
@synthesize drawtime;
@synthesize charge1,charge2,charge_null,charge_full;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"电池", @"电池");
        self.tabBarItem.image = [UIImage imageNamed:@"optimize_bat.png"];
         phoneInfo  = [[MyPhoneInfo alloc]init];
        
        myBattery = [[MyBattery alloc]init];
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
    
    if(MYSYSVER <5.0)
    {
//        UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//        Name.textColor = [Mytools colorWithHexString:@"0xffffff"];
//        Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//        Name.textAlignment = UITextAlignmentCenter;
//        Name.backgroundColor = [UIColor clearColor];
//        Name.numberOfLines = 0;
//        Name.text = @"电池";
//        [self.navigationController.navigationBar insertSubview:Name atIndex:2];
//        [Name release];
    }
    else
    {
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [myBattery updataMyBatteryInfo];
    [self Updata];
    [self UpImg];
    [self updataMyPhoneInfo];
    [self DrawPage];

}

- (void)viewDidUnload
{
    [LabeLatteryleft release];
    LabeLatteryleft = nil;
    [LabelBatteryState release];
    LabelBatteryState = nil;
    [self setLabelBatteryState:nil];
    [self setLabeLatteryleft:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.drawtime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flash) userInfo:nil repeats:YES];
} 
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
     [self.drawtime invalidate];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)DrawPage
{
    

}
- (void)dealloc {
    [LabeLatteryleft release];
    [LabelBatteryState release];
    [LabelBatteryState release];
    [LabeLatteryleft release];
    [charge1 release];
    [charge2 release];
    [charge_null release];
    [charge_full release];

    [super dealloc];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
    return [phoneInfo.arrMyPhoneInfo count]; 
} 


// Customize the appearance of table view cells. 
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TailCellIdentifier = @"TailCell";
	UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:TailCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TailCellIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellEditingStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
	for (int i=0; i<[subviews count]; i++) {
		[[subviews objectAtIndex:i] removeFromSuperview];
	}
    [subviews autorelease];
	NSUInteger row = [indexPath row];
	
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(30 + 25, 3 ,150, 20)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x0e2d4a"];
    Name.font = [UIFont fontWithName:@"Helvetica" size:12];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    Name.text = [NSString stringWithString:[[phoneInfo.arrMyPhoneInfo objectAtIndex:row] ItemName]];
    [cellView addSubview:Name];
    [Name release];
    
    UILabel * Content = [[UILabel alloc] initWithFrame: CGRectMake(30 + 100,3,150, 20)];
    
    Content.textColor = [Mytools colorWithHexString:@"0x3E2854"];
    Content.font = [UIFont fontWithName:@"Helvetica" size:12];
    Content.textAlignment = UITextAlignmentRight;
    Content.backgroundColor = [UIColor clearColor];
    Content.numberOfLines = 0;
    Content.text = [NSString stringWithString:[[phoneInfo.arrMyPhoneInfo objectAtIndex:row] ItemContent]];
    [cellView addSubview:Content];
    [Content release];
    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,23,300 ,2);
    [cellView addSubview:imageNameline];
    [imageNameline release];
    
    NSString * picstr = [NSString stringWithFormat:@"optimize_battery_str%d.png",[[phoneInfo.arrMyPhoneInfo objectAtIndex:row] nid]];
    UIImageView *imagestr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:picstr]];
    imagestr.frame = CGRectMake(30,2,20 ,20);
    [cellView addSubview:imagestr];
    [imagestr release];
    
    [cell.contentView addSubview:cellView];
    // [cell_title release];
    [cellView release];
    cellView = nil;

    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 
//“iFPGA”代表着可编程逻辑阵列，可能是一款开发测试用机型，而“iProd0,1”应当是一款原型机的标志。
-(void)updataMyPhoneInfo
{
    if(self.phoneInfo.arrMyPhoneInfo)
    {
        [self.phoneInfo.arrMyPhoneInfo removeAllObjects];
        [self.phoneInfo.arrMyPhoneInfo release];
    }    
    self.phoneInfo.arrMyPhoneInfo = [[NSMutableArray alloc] init];

    NSString * path = [[NSBundle mainBundle] pathForResource:@"timeList" ofType:@"plist"];
    NSDictionary * pdict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * temp = [pdict objectForKey:[[UIDevice currentDevice] platformString]];
    if(temp)
    {
        [self.phoneInfo addMyPhoneInfo:@"待机时间" Content:[self calculateTime:[[temp objectAtIndex:0] intValue]*60]  InfoID:0];
        [self.phoneInfo addMyPhoneInfo:@"wifi使用时间" Content:[self calculateTime:[[temp objectAtIndex:1] intValue]*60] InfoID:1];      
        [self.phoneInfo addMyPhoneInfo:@"音乐播放时间" Content:[self calculateTime:[[temp objectAtIndex:2] intValue]*60] InfoID:2];
        [self.phoneInfo addMyPhoneInfo:@"视频播放时间" Content:[self calculateTime:[[temp objectAtIndex:3] intValue]*60] InfoID:3];
        [self.phoneInfo addMyPhoneInfo:@"2G通话时间" Content:[self calculateTime:[[temp objectAtIndex:4] intValue]*60] InfoID:4];
        [self.phoneInfo addMyPhoneInfo:@"3G通话时间" Content:[self calculateTime:[[temp objectAtIndex:5] intValue]*60] InfoID:5];
        [self.phoneInfo addMyPhoneInfo:@"3G使用时间" Content:[self calculateTime:[[temp objectAtIndex:6] intValue]*60] InfoID:6];
        [self.phoneInfo addMyPhoneInfo:@"2D游戏时间" Content:[self calculateTime:[[temp objectAtIndex:7] intValue]*60] InfoID:7];
        [self.phoneInfo addMyPhoneInfo:@"3D游戏时间" Content:[self calculateTime:[[temp objectAtIndex:8] intValue]*60] InfoID:8];
        [self.phoneInfo addMyPhoneInfo:@"照片拍摄" Content:[self calculateTime:[[temp objectAtIndex:9] intValue]*60] InfoID:9];
        [self.phoneInfo addMyPhoneInfo:@"视频录制" Content:[self calculateTime:[[temp objectAtIndex:10] intValue]*60] InfoID:10];
        [self.phoneInfo addMyPhoneInfo:@"文章阅读" Content:[self calculateTime:[[temp objectAtIndex:11] intValue]*60] InfoID:11];
        [self.phoneInfo addMyPhoneInfo:@"蓝牙通讯" Content:[self calculateTime:[[temp objectAtIndex:12] intValue]*60] InfoID:12];
        [self.phoneInfo addMyPhoneInfo:@"视频电话" Content:[self calculateTime:[[temp objectAtIndex:13] intValue]*60] InfoID:13];
        [self.phoneInfo addMyPhoneInfo:@"语言备忘录" Content:[self calculateTime:[[temp objectAtIndex:14] intValue]*60] InfoID:14];
        
        for(int i = 0 ;i<15;i++)
        NSLog(@"%d",[[temp objectAtIndex:i] intValue]);
    }
    [pdict release];
}
-(void)Updata
{
    
    LabeLatteryleft.text = [NSString stringWithFormat :@"%d %%",[myBattery MyBatLeft]];
    LabelBatteryState.text = [NSString stringWithFormat :@"%d",[myBattery MyBatteryState]];
//    NSLog(@"Battry Level is :%d and Battery Status is :%d",[myBattery MyBatLeft] ,[myBattery MyBatteryState]);
    
    if(!(UIDeviceBatteryStateCharging == [myBattery MyBatteryState]||UIDeviceBatteryStateFull == [myBattery MyBatteryState]))
    {
        charge1.hidden = YES;
        charge2.hidden = YES;
        charge_full.hidden = YES;
        charge_null.hidden = YES;
    }
    else
    {
        charge1.hidden = NO;
        charge2.hidden = NO;
        charge_full.hidden = NO;
        charge_null.hidden = NO;
    }
    
}
-(void)UpImg
{
    ImgBattery.frame = CGRectMake(57,14,(198 - 10) * [myBattery MyBatLeft]/100 +10,94);
     if(UIDeviceBatteryStateFull == [myBattery MyBatteryState]) 
     {
         charge_full.frame = CGRectMake(281,47,18,28);
     }
    if(UIDeviceBatteryStateCharging == [myBattery MyBatteryState]) 
    {
        static int charging;
        charging =(++charging) %5;
        charge_full.frame = CGRectMake(281,47 -6 -(9*charging / 2) + 28,18,(9*charging / 2) + 6);
    }
}
-(NSString *)calculateTime:(int)num
{
    if(num == 0)
        return nil;
    int ntime =[myBattery MyBatLeft]*num/100;
   return  [NSString stringWithFormat:@"%d小时%d分钟",ntime/60,ntime%60];
}
-(void)flash
{
    [myBattery updataMyBatteryInfo];
    [self Updata];
    [self UpImg];
    [self updataMyPhoneInfo];
    [tableView reloadData];
    [self DrawPage];
}
@end
