//
//  FourViewController.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FourViewController.h"
#import "Mytools.h"
#import "UIDevice-Hardware.h"
#import "AppDelegate.h"
#import "myNumberImg.h"
@implementation myMemory
@synthesize Name,fProportion,fValue;

- (id)init {
    self = [super init];
    if (self) {
        self.Name = nil;
        self.fValue = 0.0;
        self.fProportion = 0.0;
    }
    return self;
}
- (void)dealloc {
    
    [ self.Name release];
    self.Name = nil;
    self.fValue = 0.0;
    self.fProportion = 0.0;

    [super dealloc];
}

@end
@implementation FourViewController
@synthesize tableView,arrMemory,allMemory,freeMemory,Imgtiao0,Imgtiao1,Imgtiao2,Imgtiao3,Imgtiao4,drawtime;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"内存", @"内存");
        self.arrMemory  = [[NSMutableArray alloc] init];
        self.tabBarItem.image = [UIImage imageNamed:@"optimize_memory.png"];
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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    if(MYSYSVER <5.0)
     {
//        UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//        Name.textColor = [Mytools colorWithHexString:@"0xffffff"];
//        Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//        Name.textAlignment = UITextAlignmentCenter;
//        Name.backgroundColor = [UIColor clearColor];
//        Name.numberOfLines = 0;
//        Name.text = @"内存";
//        [self.navigationController.navigationBar insertSubview:Name atIndex:2];
//        [Name release];
//        [self initArrMemory];
//        [self Updata];
//        [self UpImg];
     }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    // Do any additional setup after loading the view from its nib.
    [self initArrMemory];
    [self Updata];
    [self UpImg];
    
}

- (void)viewDidUnload
{
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
    return [self.arrMemory count]; 
} 


// Customize the appearance of table view cells. 
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
	
     UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    NSString * pic  = [NSString stringWithFormat:@"optimize_memory_light%d",row];
//    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pic ofType:@"png"]]
    UIImageView *imagestr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pic]];
    imagestr.frame = CGRectMake(10,5,17 ,16);
    [cellView addSubview:imagestr];
    [imagestr release];

    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(30, 5 ,150, 15)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x0e2d4a"];
    Name.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    //    Name.text = [NSString stringWithFormat:@"名称:"];
    Name.text = [[self.arrMemory objectAtIndex:row] Name];
    [cellView addSubview:Name];
    [Name release];

    
    
    UILabel * labelfValue = [[UILabel alloc] initWithFrame: CGRectMake(115, 5,70, 15)];
    
    labelfValue.textColor = [Mytools colorWithHexString:@"0x177a78"];
    labelfValue.font = [UIFont fontWithName:@"Helvetica" size:12];
    labelfValue.textAlignment = UITextAlignmentRight;
    labelfValue.backgroundColor = [UIColor clearColor];
    labelfValue.numberOfLines = 0;
    labelfValue.text = [NSString stringWithFormat:@"%0.1f M",[[self.arrMemory objectAtIndex:row] fValue]];
    [cellView addSubview:labelfValue];
    [labelfValue release];
    
    
    UILabel * labelfProportion = [[UILabel alloc] initWithFrame: CGRectMake(260, 5 ,50, 15)];
    
    labelfProportion.textColor = [Mytools colorWithHexString:@"0x3E2854"];
    labelfProportion.font = [UIFont fontWithName:@"Helvetica" size:12];
    labelfProportion.textAlignment = UITextAlignmentRight;
    labelfProportion.backgroundColor = [UIColor clearColor];
    labelfProportion.numberOfLines = 0;
    labelfProportion.text = [NSString stringWithFormat:@"%0.1f %%",[[self.arrMemory objectAtIndex:row] fProportion]];
    [cellView addSubview:labelfProportion];
    [labelfProportion release];
    

    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,23,300 ,2);
    [cellView addSubview:imageNameline];
    [imageNameline release];
    
    [cell.contentView addSubview:cellView];
 
    [cellView release];
    cellView = nil;
//    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{  
//    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
//}
-(void)Updata
{
//    allMemory.text = [NSString stringWithFormat:@"%d",[[UIDevice currentDevice] totalMemory]/1024/1024 ];
////    freeMemory.text = [NSString stringWithFormat:@"%d",([[UIDevice currentDevice] totalMemory]/1024/1024 ) - ([[UIDevice currentDevice] userMemory] /1024/1024 )];
//    freeMemory.text = [NSString stringWithFormat:@"%1.0f", [[arrMemory objectAtIndex:4] fValue]];
    {
        for (UIView* a in self.allMemory.subviews ) {
            [a removeFromSuperview];
        }
        UIView * temp = [myNumberImg pasteNumberImg:@"optimize_memory_number" number:[[UIDevice currentDevice] totalMemory]/1024/1024 is_percent:NO];
        self.allMemory.frame = CGRectMake(self.allMemory.frame.origin.x, self.allMemory.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        [self.allMemory addSubview:temp];
         [temp release];
    }
    {
        for (UIView* a in self.freeMemory.subviews ) {
            [a removeFromSuperview];
        }
        UIView * temp = [myNumberImg pasteNumberImg:@"optimize_memory_number" number:[[arrMemory objectAtIndex:4] fValue] is_percent:NO];
        self.freeMemory.frame = CGRectMake(20 +(120-temp.frame.size.width)/2, self.freeMemory.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        [self.freeMemory addSubview:temp];
         [temp release];
    }
    NSLog(@"---%f",[[arrMemory objectAtIndex:4] fValue]);
   
}
-(void)UpImg
{
    float prop0,prop1,prop2,prop3;
    prop0 = [[arrMemory objectAtIndex:0] fProportion];
    prop1 = prop0 + [[arrMemory objectAtIndex:1] fProportion];
    prop2 = prop1 + [[arrMemory objectAtIndex:2] fProportion];
    prop3 = prop2 + [[arrMemory objectAtIndex:3] fProportion];

    Imgtiao0.frame = CGRectMake(6,8,(295 -8) * prop0/100 +8,43);
    Imgtiao1.frame = CGRectMake(6,8,(295 -8) * prop1/100 + 8,43);
    Imgtiao2.frame = CGRectMake(6,8,(295 -8) * prop2/100 + 8 ,43);
    Imgtiao3.frame = CGRectMake(6,8,(295 -8) * prop3/100 + 8,43);
   
}
-(void)DrawPage
{

}
#include <mach/mach.h> 
BOOL memoryInfo(vm_statistics_data_t *vmStats) { 
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT; 
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount); 
    
    return kernReturn == KERN_SUCCESS; 
} 
-(void) initArrMemory
{
    vm_statistics_data_t vmStats; 
    if (memoryInfo(&vmStats)) { 
//        NSLog(@"\nfree: %u\nactive: %u\ninactive: %u\nwire: %u\nzero", 
//              vmStats.free_count * vm_page_size/1024/1024,       
//              vmStats.active_count * vm_page_size/1024/1024,             
//              vmStats.inactive_count * vm_page_size/1024/1024,  
//              vmStats.wire_count * vm_page_size/1024/1024);       
        
        if(self.arrMemory)
        {
            [self.arrMemory removeAllObjects];
            [self.arrMemory release];
        }
        self.arrMemory = [[NSMutableArray alloc] init];
        {
            myMemory * temp = [[myMemory alloc]init];
            temp.Name = [NSString stringWithString:@"内联"];
            temp.fValue = 1.0*vmStats.wire_count * vm_page_size/1024/1024;
            temp.fProportion = temp.fValue/([[UIDevice currentDevice] totalMemory]/1024/1024)*100;
            [arrMemory addObject:temp];
            [temp release];
        }
        {
            myMemory * temp = [[myMemory alloc]init];
            temp.Name = [NSString stringWithString:@"不活动"];
            temp.fValue = 1.0*vmStats.active_count * vm_page_size/1024/1024;
            temp.fProportion = (1.0*vmStats.active_count * vm_page_size/1024/1024)/([[UIDevice currentDevice] totalMemory]/1024/1024)*100;
            [arrMemory addObject:temp];
            [temp release];
        }
        {
            myMemory * temp = [[myMemory alloc]init];
            temp.Name = [NSString stringWithString:@"活动"];
            temp.fValue = 1.0*vmStats.inactive_count * vm_page_size/1024/1024;
            temp.fProportion = (1.0*vmStats.inactive_count * vm_page_size/1024/1024)/([[UIDevice currentDevice] totalMemory]/1024/1024)*100;
            [arrMemory addObject:temp];
            [temp release];
        }
        {
            myMemory * temp = [[myMemory alloc]init];
            temp.Name = [NSString stringWithString:@"系统(图形)"];
            temp.fValue =([[UIDevice currentDevice] totalMemory]/1024/1024-vmStats.free_count * vm_page_size/1024/1024-       
                          vmStats.active_count * vm_page_size/1024/1024-             
                          vmStats.inactive_count * vm_page_size/1024/1024-  
                          vmStats.wire_count * vm_page_size/1024/1024);
            temp.fProportion = (1.0*temp.fValue)/([[UIDevice currentDevice] totalMemory]/1024/1024)*100;
            [arrMemory addObject:temp];
            [temp release];
        }
        {
            myMemory * temp = [[myMemory alloc]init];
            temp.Name = [NSString stringWithString:@"空闲"];
            temp.fValue = 1.0*vmStats.free_count * vm_page_size/1024/1024;
            temp.fProportion = temp.fValue/([[UIDevice currentDevice] totalMemory]/1024/1024)*100;
            [arrMemory addObject:temp];
            [temp release];
        }
    }
}
-(void)flash
{
    [self initArrMemory];
    [self Updata];
    [self UpImg];
    [tableView reloadData];
    [self DrawPage];
}

@end
