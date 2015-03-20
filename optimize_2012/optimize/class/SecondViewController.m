//
//  SecondViewController.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "Mytools.h"
#import "UIDevice-Reachability.h"

#import "UIDevice-Hardware.h"
#import "UIDevice-Capabilities.h"
#import "UIDevice-Orientation.h"
#import <mach/mach_time.h>
#import "AppDelegate.h"

@implementation SecondViewController
@synthesize phoneInfo,tableView,myInfo,keys;
@synthesize drawtime,arrUpdata;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"系统", @"系统");
         self.tabBarItem.image = [UIImage imageNamed:@"optimize_sys.png"];
           phoneInfo  = [[MyPhoneInfo alloc]init];
        keys = [[NSMutableArray alloc] init];
        myInfo = [[NSMutableArray alloc] init];
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
     if ( MYSYSVER < 5.0)
     {
//        UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//        Name.textColor = [Mytools colorWithHexString:@"0xffffff"];
//        Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//        Name.textAlignment = UITextAlignmentCenter;
//        Name.backgroundColor = [UIColor clearColor];
//        Name.numberOfLines = 0;
//        Name.text = @"系统";
//        [self.navigationController.navigationBar insertSubview:Name atIndex:2];
//        [Name release];
    }
    else
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self updataMyPhoneInfo];
    [self DrawPage];
//    arrUpdata = [[NSArray alloc]initWithObjects: [NSIndexPath indexPathForRow:1 inSection:1], [NSIndexPath indexPathForRow:0 inSection:3],[NSIndexPath indexPathForRow:1 inSection:3],[NSIndexPath indexPathForRow:2 inSection:3],[NSIndexPath indexPathForRow:3 inSection:3], nil];
   
}

- (void)viewDidUnload
{
    [arrUpdata release];
    arrUpdata = nil;
    [keys release];
    keys = nil;
    [myInfo release];
    myInfo = nil;
    [tableView release];
    tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     arrUpdata = [[NSArray alloc]initWithObjects: [NSIndexPath indexPathForRow:1 inSection:1],nil];
    [self updataMyPhoneInfo];
    [tableView reloadData];
    
    [self DrawPage];
    self.drawtime = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(flash) userInfo:nil repeats:YES];
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
//    [self.tableView release];
//    self.tableView = nil;
    if(self.arrUpdata)
    {
        [self.arrUpdata release];
    }
    arrUpdata = nil;
    
    if(self.keys)
    {
        [self.keys removeAllObjects];
        [self.keys release];
    }
    keys = nil;
    [self.myInfo removeAllObjects];
    [self.myInfo release];
    myInfo = nil;
   
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)DrawPage
{
    
}
-(void)flash
{
//    [self updataMyPhoneInfo];
    [self updataArrInfo ];
//    [tableView reloadData];

   [tableView reloadRowsAtIndexPaths:arrUpdata withRowAnimation:UITableViewRowAnimationNone];
    [self DrawPage];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
//    NSLog(@"%d",[myInfo count]);
    return [myInfo count]; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
//    return [phoneInfo.arrMyPhoneInfo count];
  
//    NSLog(@"%@",[keys objectAtIndex:section]);
//     NSLog(@"%@",[myInfo objectAtIndex:section]);

    NSArray * nameSection = [[[myInfo objectAtIndex:section] objectForKey: [keys objectAtIndex:section]] arrMyPhoneInfo];
//     NSLog(@"%d ",[nameSection count]);

    return [nameSection count];
} 


// Customize the appearance of table view cells. 
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger  section = [indexPath section];
    NSUInteger row = [indexPath row];
   
	NSString * key = [keys objectAtIndex:section];
     NSArray * nameSection = [[[myInfo objectAtIndex:section] objectForKey: [keys objectAtIndex:section]] arrMyPhoneInfo];
    
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
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(25, 3 ,150, 20)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x0e2d4a"];
    Name.font = [UIFont fontWithName:@"Helvetica" size:12];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    Name.text = [NSString stringWithString:[[nameSection objectAtIndex:row] ItemName]];
    [cellView addSubview:Name];
    [Name release];
    
    UILabel * Content = [[UILabel alloc] initWithFrame: CGRectMake(25 + 90, 3 ,190, 20)];
    
    Content.textColor = [Mytools colorWithHexString:@"0x3E2854"];
    Content.font = [UIFont fontWithName:@"Helvetica" size:12];
    Content.textAlignment = UITextAlignmentRight;
    Content.backgroundColor = [UIColor clearColor];
    Content.numberOfLines = 0;
    Content.text = [NSString stringWithString:[[nameSection objectAtIndex:row] ItemContent]];
    [cellView addSubview:Content];
    [Content release];
    if(row!=[nameSection count]-1)
    {
        UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
        imageNameline.frame = CGRectMake(10,23,300 ,2);
        [cellView addSubview:imageNameline];
        [imageNameline release];
    }
    [cell.contentView addSubview:cellView];
     [cellView release];
    cellView = nil;
   
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 
-(void)updataMyPhoneInfo
{
    if(keys)
    {
        [keys removeAllObjects];
        [keys release];
    }
       
   keys = [[NSMutableArray alloc] init];
    if(myInfo)
    {
        [myInfo removeAllObjects];
        [myInfo release];
    }
    myInfo = [[NSMutableArray alloc]init ];
//    if(self.phoneInfo.arrMyPhoneInfo)
//    {
//        [self.phoneInfo.arrMyPhoneInfo removeAllObjects];
//        [self.phoneInfo.arrMyPhoneInfo release];
//    }    
//    self.phoneInfo.arrMyPhoneInfo = [[NSMutableArray alloc] init];
//    
//    [self.phoneInfo addMyPhoneInfo:@"model" Content:[[UIDevice currentDevice] model]];
//    [self.phoneInfo addMyPhoneInfo:@"UID"  Content:[[UIDevice currentDevice] uniqueIdentifier]];
//    [self.phoneInfo addMyPhoneInfo:@"系统版本"  Content:[[UIDevice currentDevice] systemVersion]];
//    [self.phoneInfo addMyPhoneInfo:@"语言" Content:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
//    [self.phoneInfo addMyPhoneInfo:@"系序列号:" Content:[[UIDevice currentDevice] serialnumber]];
//    [self.phoneInfo addMyPhoneInfo:@"Host Name:" Content:[[UIDevice currentDevice] hostname]];
//    [self.phoneInfo addMyPhoneInfo:@"Local IP Addy:" Content:[[UIDevice currentDevice] localIPAddress]];
//    //    [self addMyPhoneInfo:@"Local WiFI Addy:" Content:[[UIDevice currentDevice] localWiFiIPAddress]];
//    
//    [self.phoneInfo addMyPhoneInfo:@"Platform:" Content:[[UIDevice currentDevice] platform]];
//    [self.phoneInfo addMyPhoneInfo:@"Platform String:" Content:[[UIDevice currentDevice] platformString]];
//    [self.phoneInfo addMyPhoneInfo:@"MAC地址:" Content:[[UIDevice currentDevice] macaddress]];
//    [self.phoneInfo addMyPhoneInfo:@"总线频率:" Content:[self.phoneInfo commasForNumber:[[UIDevice currentDevice] busFrequency]]];
//     [self.phoneInfo addMyPhoneInfo:@"CPU频率:" Content:[self.phoneInfo commasForNumber:[[UIDevice currentDevice] cpuFrequency]]];
//    
//    NSString * totalm ;
//    totalm = [NSString stringWithFormat:@"%d M",[[UIDevice currentDevice] totalMemory]/1024/1024 ];
//    [self.phoneInfo addMyPhoneInfo:@"总共 内存:" Content:totalm];
////    [self.phoneInfo addMyPhoneInfo:@"总共 内存:" Content:CFN([[UIDevice currentDevice] totalMemory])];
//    NSString * userm ;
//    userm = [NSString stringWithFormat:@"%dM",[[UIDevice currentDevice] userMemory] /1024/1024 ];
//    [self.phoneInfo addMyPhoneInfo:@"已用 Memory:" Content:userm];
////    [self.phoneInfo addMyPhoneInfo:@"已用 Memory:" Content:CFN([[UIDevice currentDevice] userMemory])];
//    //    [self addMyPhoneInfo:@"backlightlevel:" Content:[[UIDevice currentDevice] backlightlevel]];
//    
//    
//    NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",[self.phoneInfo getTotalDiskSpace]];
//    NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",[self.phoneInfo getFreeDiskSpace]];
//    NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",[self.phoneInfo getDirectorySpace:nil]];
//    NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",[self.phoneInfo getTotalDiskSpace] - [self.phoneInfo getFreeDiskSpace] - [self.phoneInfo getDirectorySpace:nil]];    
//    [self.phoneInfo addMyPhoneInfo:@"硬盘容量:" Content:totalSpace];
//    [self.phoneInfo addMyPhoneInfo:@"剩余空间:" Content:freeSpace];
//    [self.phoneInfo addMyPhoneInfo:@"本地影片:" Content:directorySpace];
//    [self.phoneInfo addMyPhoneInfo:@"其他程序:" Content:otherSpace];
    
//    NSDictionary *dic = 
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        [deviceInfo addMyPhoneInfo:@"机型" Content:[[UIDevice currentDevice] platformString]];
        [deviceInfo addMyPhoneInfo:@"系统版本"  Content:[[UIDevice currentDevice] systemVersion]];
        [deviceInfo addMyPhoneInfo:@"设备名称:" Content:[[UIDevice currentDevice] hostname]];


//    [deviceInfo addMyPhoneInfo:@"语言" Content:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"设备信息", nil];
    
        [myInfo addObject:dic];
        [dic release];
        [deviceInfo release];
    
        [keys addObject:@"设备信息"];
    }
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        [deviceInfo addMyPhoneInfo:@"上次重启时间" Content:[deviceInfo getLastRebootTime]];
        [deviceInfo addMyPhoneInfo:@"运行时间"  Content:[deviceInfo getSinceLastRebootTime]];

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"系统运行时间", nil];
        [myInfo addObject:dic];
        [keys addObject:@"系统运行时间"];
        [dic release];
        [deviceInfo release];
    }
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"myplist" ofType:@"plist"];
        NSMutableDictionary * pdict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSArray * temp = [pdict objectForKey:[[UIDevice currentDevice] platformString]];
        if(temp)
        {
            [deviceInfo addMyPhoneInfo:@"处理器" Content: [temp objectAtIndex:0]];
            [deviceInfo addMyPhoneInfo:@"尺寸(英寸)" Content:[temp objectAtIndex:1]];
            [deviceInfo addMyPhoneInfo:@"重量" Content:[temp objectAtIndex:2]];
            [deviceInfo addMyPhoneInfo:@"屏幕尺寸" Content:[temp objectAtIndex:3]];
            [deviceInfo addMyPhoneInfo:@"显示器分辨率" Content:[temp objectAtIndex:4]];
            [deviceInfo addMyPhoneInfo:@"像素密度" Content:[temp objectAtIndex:5]];
            [deviceInfo addMyPhoneInfo:@"电池电压" Content:[temp objectAtIndex:6]];
            [deviceInfo addMyPhoneInfo:@"电池容量" Content:[temp objectAtIndex:7]];
            [deviceInfo addMyPhoneInfo:@"WIFI" Content:[temp objectAtIndex:8]];
            [deviceInfo addMyPhoneInfo:@"蓝牙" Content:[temp objectAtIndex:9]];
            [deviceInfo addMyPhoneInfo:@"后置摄像头" Content:[temp objectAtIndex:10]];
            [deviceInfo addMyPhoneInfo:@"前置摄像头" Content:[temp objectAtIndex:11]];
            [deviceInfo addMyPhoneInfo:@"三轴陀螺仪" Content:[temp objectAtIndex:12]];
            [deviceInfo addMyPhoneInfo:@"方向感应器" Content:[temp objectAtIndex:13]];
            [deviceInfo addMyPhoneInfo:@"距离感应器" Content:[temp objectAtIndex:14]];
            [deviceInfo addMyPhoneInfo:@"环境光线感应器" Content:[temp objectAtIndex:15]];

        }
        [pdict release];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"硬件特征", nil];
        [myInfo addObject:dic];
        [keys addObject:@"硬件特征"];
        [dic release];
        [deviceInfo release];
    }
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getTotalDiskSpace]];
        NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getFreeDiskSpace]];
        NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getDirectorySpace:nil]];
        NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getTotalDiskSpace] - [deviceInfo getFreeDiskSpace] - [deviceInfo getDirectorySpace:nil]];    
        [deviceInfo addMyPhoneInfo:@"硬盘容量:" Content:totalSpace];
        [deviceInfo addMyPhoneInfo:@"剩余空间:" Content:freeSpace];
        [deviceInfo addMyPhoneInfo:@"本地影片:" Content:directorySpace];
        [deviceInfo addMyPhoneInfo:@"其他程序:" Content:otherSpace];
      
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"硬盘信息", nil];
        [myInfo addObject:dic];
        [keys addObject:@"硬盘信息"];
        [dic release];
        [deviceInfo release];
    }
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        [deviceInfo addMyPhoneInfo:@"运营商" Content: [deviceInfo getCarrier]];
      //  [deviceInfo addMyPhoneInfo:@"ip地址"  Content:[[UIDevice currentDevice] localIPAddress]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"2G/3G网络信息", nil];
        [myInfo addObject:dic];
        [keys addObject:@"2G/3G网络信息"];
        [dic release];
        [deviceInfo release];
    }
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        [deviceInfo addMyPhoneInfo:@"MAC地址" Content:[[UIDevice currentDevice] macaddress]];
        [deviceInfo addMyPhoneInfo:@"ip地址"  Content:[[UIDevice currentDevice] localIPAddress]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"wifi网络信息", nil];
        [myInfo addObject:dic];
        [keys addObject:@"wifi网络信息"];
        [dic release];
        [deviceInfo release];
    }
//    {
//        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
//        deviceInfo.arrMyPhoneInfo = [[NSMutableArray alloc] init];
//        [deviceInfo addMyPhoneInfo:@"蓝牙地址" Content:[deviceInfo getLastRebootTime]];
//        
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"蓝牙", nil];
//        [myInfo addObject:dic];
//        [keys addObject:@"蓝牙"];
//        [dic release];
//        [deviceInfo release];
//    }


}
-(void) updataArrInfo
{
    {
        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
        deviceInfo.arrMyPhoneInfo = [[[NSMutableArray alloc] init] autorelease];
        [deviceInfo addMyPhoneInfo:@"上次重启时间" Content:[deviceInfo getLastRebootTime]];
        [deviceInfo addMyPhoneInfo:@"运行时间"  Content:[deviceInfo getSinceLastRebootTime]];
        NSMutableDictionary *dic =[self.myInfo objectAtIndex:1];
        [dic setValue:deviceInfo forKey:@"系统运行时间"];

//        dic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"系统运行时间", nil];
        
//       [self.myInfo objectAtIndex:1]  = [[NSDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"系统运行时间", nil];
//        [[self.myInfo objectAtIndex:1] setObject:deviceInfo forKey:@"系统运行时间"];
//        [dic release];
        [deviceInfo release];
    }
//    {
//        
//        MyPhoneInfo * deviceInfo =  [[MyPhoneInfo alloc]init];
//        deviceInfo.arrMyPhoneInfo = [[NSMutableArray alloc] init];
//        NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getTotalDiskSpace]];
//        NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getFreeDiskSpace]];
//        NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getDirectorySpace:nil]];
//        NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",[deviceInfo getTotalDiskSpace] - [deviceInfo getFreeDiskSpace] - [deviceInfo getDirectorySpace:nil]];    
//        [deviceInfo addMyPhoneInfo:@"硬盘容量:" Content:totalSpace];
//        [deviceInfo addMyPhoneInfo:@"剩余空间:" Content:freeSpace];
//        [deviceInfo addMyPhoneInfo:@"本地影片:" Content:directorySpace];
//        [deviceInfo addMyPhoneInfo:@"其他程序:" Content:otherSpace];  
////          [[self.myInfo objectAtIndex:3] setObject:deviceInfo forKey:@"硬盘信息"];
//         NSMutableDictionary *dic =[self.myInfo objectAtIndex:3]; 
//        [dic setValue:deviceInfo forKey:@"硬盘信息"];
////           dic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceInfo,@"硬盘信息", nil];
//         [deviceInfo release];
//    
//    }

}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//
//}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIImageView * imaview;
    imaview = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"optimize_tiao.png"] ]autorelease];
    NSString *temp = [NSString  stringWithFormat:@"optimize_sys_%d.png",section];
      UIImageView * imaview2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:temp]];
    imaview2.frame = CGRectMake(21,3,imaview2.frame.size.width,imaview2.frame.size.height);
    [imaview addSubview:imaview2];
    [imaview2 release];
    return imaview;
}
@end
