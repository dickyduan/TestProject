//
//  FirstViewController.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Mytools.h"
#import "myNumberImg.h"
@implementation FirstViewController
@synthesize percent;
@synthesize ImgNeihe;
@synthesize ImgDiaodu;
@synthesize ImgIdle;
@synthesize ImgUser;
@synthesize fIdle,fUser,fNeihe,fDiaodu,fullpercent,userpercent,Neihepercent,Diaopercent;

@synthesize cpuInfo, prevCpuInfo;
@synthesize   numCpuInfo, numPrevCpuInfo;
@synthesize   numCPUs;
@synthesize drawtime;
@synthesize  CPUUsageLock;

@synthesize tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"进程", @"进程");  
         self.tabBarItem.image = [UIImage imageNamed:@"optimize_progress.png"];
       
     
        

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
//    UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBar.png"]];
    
     if ( MYSYSVER < 5.0)
    {
//        UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//        Name.textColor = [Mytools colorWithHexString:@"0xffffff"];
//        Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//        Name.textAlignment = UITextAlignmentCenter;
//        Name.backgroundColor = [UIColor clearColor];
//        Name.numberOfLines = 0;
//        Name.text = @"进程";
//        [self.navigationController.navigationBar insertSubview:Name atIndex:2];
//        [Name release];
      }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
//    NSLog(@"%@",self.navigationController.navigationBar.subviews);
//     self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topBar.png"]];
//    [myProcess updataMyProcess];
    [self DrawPage];
  
    
//    UIImage * temp =   [UIImage imageNamed:@"optimize_cpu_number1.png"];
//    CGRect rect=CGRectMake(0, 0,44, 52);
//    CGImageRef imageRef=CGImageCreateWithImageInRect([temp CGImage],rect);
//    UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
//    UIImageView*_imageView=[[UIImageView alloc] initWithImage:temp];
//    _imageView.frame=CGRectMake(50,100,temp.size.width,temp.size.height);
//    [self.view addSubview:_imageView];

}

- (void)viewDidUnload
{

    [ImgIdle release];
    ImgIdle = nil;
    [self setImgIdle:nil];
    [ImgUser release];
    ImgUser = nil;
    [self setImgUser:nil];
    [ImgDiaodu release];
    ImgDiaodu = nil;
    [self setImgDiaodu:nil];
    [ImgNeihe release];
    ImgNeihe = nil;
    [self setImgNeihe:nil];
    [percent release];
    percent = nil;
    [self setPercent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     AppDelegate * app = pAPPDelegate;
    [app.myProcess updataMyProcess];
    [tableView reloadData];
    [self updateInfo];
    [self Updata];
    [self UpImg];
    self.drawtime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flash) userInfo:nil repeats:YES];
     [tableView reloadData];
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
//    UIImage *targetImage =[UIImage imageNamed:@"optimize_cpu_number.png"];           
//    UIGraphicsBeginImageContext(CGSizeMake(75, 25));            
//    [targetImage drawInRect: CGRectMake(0, 0, 75, 25)];            
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();   //这里就是我们想要的图片了             
//    UIGraphicsEndImageContext();
    
//     UIImageView * TEMP = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_number.png"]];
//    
//    CGImageRef imageRef =  TEMP.image.CGImage;
//    CGRect rect = CGRectMake(100.0, 0.0, 220.0, 26.0);
//   CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
//    UIImage *imageRect = [[UIImage alloc] initWithCGImage: imageRefRect];
//    TEMP.image = imageRect;

    
//    UIImageView * TEMP = [[UIImageView alloc]initWithImage:image];
//   TEMP.frame = CGRectMake(50,50,100 ,100);
//    [self.view addSubview:TEMP  ];
    
  
    
}
-(void)flash
{
    [self updateInfo];
    [self Updata];
    [self UpImg];
   
}
//更新cpu使用率-->方法2



- (void)updateInfo 
{
    natural_t numCPUsU = 0U;
    
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUs, &cpuInfo, &numCpuInfo);
    if(err == KERN_SUCCESS) 
    {
        double daData = 0;
        [CPUUsageLock lock];
        for(unsigned i = 0U; i < numCPUs; ++i) 
        {
            float inUse, total;
            if(prevCpuInfo) 
            {
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } 
            else 
            {
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            daData = daData + inUse/total;
            //NSLog(@"Core: %u Usage: %f",i,inUse / total);
        }
        //这就是计算！
        daData = daData/numCPUs;
        
        //        [NSString stringWithFormat:@"%f%%",[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100];
//        NSLog(@"%@",[NSString stringWithFormat:@"%.0f%%",[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100]);
        
#pragma mark CPU结果显示在UIProgressView
        if((int)(self.fUser) == (int)(daData*100))
        {
            NSLog(@"------equest");
            return;
        }
        self.fUser = daData * 100;
        self.fIdle = 100.0 - daData * 100;
//        self.percent.text = [NSString stringWithFormat:@"%.0f%%",[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100];
        
        {
            for (UIView* a in self.percent.subviews ) {
                [a removeFromSuperview];
            }
            UIView * temp = [myNumberImg pasteNumberImg:@"optimize_cpu_number1" number:[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100 is_percent:YES];
            self.percent.frame = CGRectMake(self.percent.frame.origin.x, self.percent.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            [self.percent addSubview:temp];
            [temp release];
        }
        
        {
            for (UIView* a in self.userpercent.subviews ) {
                [a removeFromSuperview];
            }
            UIView * temp = [myNumberImg pasteNumberImg:@"optimize_cpu_number2" number:[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100 is_percent:YES];
            self.userpercent.frame = CGRectMake(self.userpercent.frame.origin.x, self.userpercent.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            [self.userpercent addSubview:temp];
             [temp release];
        }
        
        {
            for (UIView* a in self.fullpercent.subviews ) {
                [a removeFromSuperview];
            }
            UIView * temp = [myNumberImg pasteNumberImg:@"optimize_cpu_number2" number:100.0-[[NSString stringWithFormat:@"%.2f",daData] doubleValue] * 100 is_percent:YES];
            self.fullpercent.frame = CGRectMake(self.fullpercent.frame.origin.x, self.fullpercent.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            [self.fullpercent addSubview:temp];
             [temp release];
        }
        {
            for (UIView* a in self.Neihepercent.subviews ) {
                [a removeFromSuperview];
            }
            UIView * temp = [myNumberImg pasteNumberImg:@"optimize_cpu_number2" number:0 is_percent:YES];
            self.Neihepercent.frame = CGRectMake(self.Neihepercent.frame.origin.x, self.Neihepercent.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            [self.Neihepercent addSubview:temp];
             [temp release];
        }
        {
            for (UIView* a in self.Diaopercent.subviews ) {
                [a removeFromSuperview];
            }
            UIView * temp = [myNumberImg pasteNumberImg:@"optimize_cpu_number2" number:0 is_percent:YES];
            self.Diaopercent.frame = CGRectMake(self.Diaopercent.frame.origin.x, self.Diaopercent.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
            [self.Diaopercent addSubview:temp];
             [temp release];
        }  
        
        
        [CPUUsageLock unlock];
        
        if(prevCpuInfo) 
        {
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCpuInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);
        }
        
        prevCpuInfo = cpuInfo;
        numPrevCpuInfo = numCpuInfo;
        
        cpuInfo = NULL;
        numCpuInfo = 0U;
    } 
    else 
    {
        //NSLog(@"Error!");
        //        [timer invalidate];
        return;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section.
    AppDelegate * app = pAPPDelegate;
    NSLog(@"%d",[app.myProcess.arrMyProcess count]);
    return [app.myProcess.arrMyProcess count]; 
} 


// Customize the appearance of table view cells. 
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * app = pAPPDelegate;
    static NSString *TailCellIdentifier = @"TailCell";
	UITableViewCell *cell = nil;

//    cell.backgroundColor = [UIColor clearColor];
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
 
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(25, 7 ,150, 15)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x0b2949"];
    Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
//    Name.text = [NSString stringWithFormat:@"名称:"];
     Name.text = @"名称:";
    [cellView addSubview:Name];
    [Name release];
    
    UILabel * ProcessName = [[UILabel alloc] initWithFrame: CGRectMake(25 + 30, 7 ,150, 15)];
    
    ProcessName.textColor = [Mytools colorWithHexString:@"0x289f14"];
    ProcessName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    ProcessName.textAlignment = UITextAlignmentLeft;
    ProcessName.backgroundColor = [UIColor clearColor];
    ProcessName.numberOfLines = 0;
    ProcessName.text = [NSString stringWithString:[[app.myProcess.arrMyProcess objectAtIndex:row] strProcessName]];
    [cellView addSubview:ProcessName];
    [ProcessName release];
    
    
    UILabel * PID = [[UILabel alloc] initWithFrame: CGRectMake(240, 7 ,150, 15)];
    
    PID.textColor = [Mytools colorWithHexString:@"0x0b2949"];
    PID.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    PID.textAlignment = UITextAlignmentLeft;
    PID.backgroundColor = [UIColor clearColor];
    PID.numberOfLines = 0;
    PID.text = @"PID:";
    [cellView addSubview:PID];
    [PID release];
    
    UILabel * ProcessID = [[UILabel alloc] initWithFrame: CGRectMake(240 + 30, 7 ,150, 15)];
    
    ProcessID.textColor = [Mytools colorWithHexString:@"0x177a78"];
    ProcessID.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    ProcessID.textAlignment = UITextAlignmentLeft;
    ProcessID.backgroundColor = [UIColor clearColor];
    ProcessID.numberOfLines = 0;
    ProcessID.text = [NSString stringWithString:[[app.myProcess.arrMyProcess objectAtIndex:row] strProcessID]];
    [cellView addSubview:ProcessID];
    [ProcessID release];
    
     UILabel * start = [[UILabel alloc] initWithFrame: CGRectMake(25, 7  + 20 ,150, 15)];
    start.textColor = [Mytools colorWithHexString:@"0x0b2949"];
    start.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    start.textAlignment = UITextAlignmentLeft;
    start.backgroundColor = [UIColor clearColor];
    start.numberOfLines = 0;
    //    Name.text = [NSString stringWithFormat:@"名称:"];
    start.text = @"启动:";
    [cellView addSubview:start];
    [start release];
    
    UILabel * ProcessUseTime = [[UILabel alloc] initWithFrame: CGRectMake(25 + 30, 7 + 20 ,150, 15)];
    
    ProcessUseTime.textColor = [Mytools colorWithHexString:@"0x3b2829"];
    ProcessUseTime.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    ProcessUseTime.textAlignment = UITextAlignmentLeft;
    ProcessUseTime.backgroundColor = [UIColor clearColor];
    ProcessUseTime.numberOfLines = 0;
    ProcessUseTime.text = [NSString stringWithString:[[app.myProcess.arrMyProcess objectAtIndex:row] strProcessUseTime]];
    [cellView addSubview:ProcessUseTime];
    [ProcessUseTime release];
    
    UILabel * Priority = [[UILabel alloc] initWithFrame: CGRectMake(240, 7  + 20 ,150, 15)];
    Priority.textColor = [Mytools colorWithHexString:@"0x0b2949"];
    Priority.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    Priority.textAlignment = UITextAlignmentLeft;
    Priority.backgroundColor = [UIColor clearColor];
    Priority.numberOfLines = 0;
    //    Name.text = [NSString stringWithFormat:@"名称:"];
    Priority.text = @"优先级:";
    [cellView addSubview:Priority];
    [Priority release];
    
    UILabel * processPriority = [[UILabel alloc] initWithFrame: CGRectMake(240 + 45, 7 + 20 ,150, 15)];
    
    processPriority.textColor = [Mytools colorWithHexString:@"0x442860"];
    processPriority.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
    processPriority.textAlignment = UITextAlignmentLeft;
    processPriority.backgroundColor = [UIColor clearColor];
    processPriority.numberOfLines = 0;
    processPriority.text = [NSString stringWithString:[[app.myProcess.arrMyProcess objectAtIndex:row] strprocessPriority]];
    [cellView addSubview:processPriority];
    [processPriority release];
    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,48,300 ,2);
    [cellView addSubview:imageNameline];
    [imageNameline release];
    
    [cell.contentView addSubview:cellView];
    // [cell_title release];
    [cellView release];
    cellView = nil;
    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

- (void)dealloc {

    [ImgIdle release];
    [ImgIdle release];
    [ImgUser release];
    [ImgUser release];
    [ImgDiaodu release];
    [ImgDiaodu release];
    [ImgNeihe release];
    [ImgNeihe release];
    [percent release];
    [percent release];
    [super dealloc];
}
-(void)Updata
{
//    self.fIdle = 50.0;
//    self.fUser = 15.8;
      self.fDiaodu = 0.0;
    self.fNeihe = 0;
 

}
-(void)UpImg
{
   ImgIdle.frame = CGRectMake(ImgIdle.frame.origin.x ,2 + 5+ 92*(100.0-fIdle)/100,ImgIdle.frame.size.width,92*fIdle/100 +10);
    ImgUser.frame = CGRectMake(ImgUser.frame.origin.x,2 +5+ 92*(100.0-fUser)/100,ImgUser.frame.size.width,92*fUser/100 +10);
    ImgDiaodu.frame = CGRectMake(ImgDiaodu.frame.origin.x,2 + (100.0-fDiaodu),ImgDiaodu.frame.size.width,107-(100.0-fDiaodu));
    ImgNeihe.frame = CGRectMake(ImgNeihe.frame.origin.x,2 + (100.0-fNeihe),ImgNeihe.frame.size.width,107-(100.0-fNeihe));

 

}
@end
