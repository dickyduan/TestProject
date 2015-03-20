//
//  DetailController.m
//  optimize
//
//  Created by 广龙 段 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailController.h"

#import "Mytools.h"

#define kCustomButtonHeight		30.0

#define kViewControllerKey		@"viewController"
#define kTitleKey				@"title"
#define kDetailKey				@"detail text"

@implementation DetailController
@synthesize m_TableView, myNetList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"", @"");
        myNetList  = [[MyNetList alloc]init];
        isDayInfo = false;
    }
    return self;
}

- (void)dealloc
{
	[defaultTintColor release];
    [m_TableView release];
	[super dealloc];
}

- (void)viewDidLoad
{
	// segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"本月流量", @""),
                                   NSLocalizedString(@"今日流量", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 200, kCustomButtonHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [myNetList updataMyNetList];
    
	UISegmentedControl *segmentedControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
	
	// Before we show this view make sure the segmentedControl matches the nav bar style
	if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent || self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
		segmentedControl.tintColor = [UIColor darkGrayColor];
	else
		segmentedControl.tintColor = defaultTintColor;
}

- (IBAction)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	if(segmentedControl.selectedSegmentIndex == 0)
    {
        isDayInfo = false;
    }
    else 
    {
        isDayInfo = true;
    }
    [m_TableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [m_TableView release];
    m_TableView = nil;
    [myNetList release];
    [self setMyNetList:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section.
    if(isDayInfo)
        return [[myNetList m_TodayData] count];
    return [[myNetList m_MonthData] count]; 
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
	
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(25, 10 ,150, 15)];
    Name.textColor = [Mytools colorWithHexString:@"0x090909"];
    Name.font = [UIFont fontWithName:@"Helvetica" size:14];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    if(isDayInfo)
        Name.text = [[myNetList.m_TodayData objectAtIndex:row] m_time];
    else
        Name.text = [[myNetList.m_MonthData objectAtIndex:row] m_time];
    [cellView addSubview:Name];
    [Name release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 12 ,14, 10)];
    imageView.image = [UIImage imageNamed:@"optimize_net_gprs.png"];
    [cellView addSubview:imageView];
    [imageView release];
    
    UILabel * ProcessName = [[UILabel alloc] initWithFrame: CGRectMake(120, 10 ,150, 15)];
    ProcessName.textColor = [Mytools colorWithHexString:@"0x000000"];
    ProcessName.font = [UIFont fontWithName:@"Helvetica" size:14];
    ProcessName.textAlignment = UITextAlignmentLeft;
    ProcessName.backgroundColor = [UIColor clearColor];
    ProcessName.numberOfLines = 0;
    if(isDayInfo)
    {
        NSString *tmp1 = [[myNetList.m_TodayData objectAtIndex:row] m_gprs];
        tmp1 = [tmp1 substringToIndex:tmp1.length-1];
        if([tmp1 floatValue] < 0.01)
            ProcessName.text = @"0K";
        else
            ProcessName.text = [[myNetList.m_TodayData objectAtIndex:row] m_gprs];
    }
    else
    {
        NSString *tmp1 = [[myNetList.m_MonthData objectAtIndex:row] m_gprs];
        tmp1 = [tmp1 substringToIndex:tmp1.length-1];
        if([tmp1 floatValue] < 0.01)
            ProcessName.text = @"0K";
        else
            ProcessName.text = [[myNetList.m_MonthData objectAtIndex:row] m_gprs];
    }
    [cellView addSubview:ProcessName];
    [ProcessName release];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 12 ,14, 10)];
    imageView1.image = [UIImage imageNamed:@"optimize_net_wifi.png"];
    [cellView addSubview:imageView1];
    [imageView1 release];

    
    UILabel * PID = [[UILabel alloc] initWithFrame: CGRectMake(230, 10 ,150, 15)];
    
    PID.textColor = [Mytools colorWithHexString:@"0x000000"];
    PID.font = [UIFont fontWithName:@"Helvetica" size:14];
    PID.textAlignment = UITextAlignmentLeft;
    PID.backgroundColor = [UIColor clearColor];
    PID.numberOfLines = 0;
    if(isDayInfo)
    {
        NSString *tmp1 = [[myNetList.m_TodayData objectAtIndex:row] m_wifi];
        tmp1 = [tmp1 substringToIndex:tmp1.length-1];
        if([tmp1 floatValue] < 0.01)
            PID.text = @"0K";
        else
            PID.text = [[myNetList.m_TodayData objectAtIndex:row] m_wifi];
    }
    else
    {
        NSString *tmp = [[myNetList.m_MonthData objectAtIndex:row] m_wifi];
        tmp = [tmp substringToIndex:tmp.length-1];
        if([tmp floatValue] < 0.01)
            PID.text = @"0K";
        else
            PID.text = [[myNetList.m_MonthData objectAtIndex:row] m_wifi];
    }
    [cellView addSubview:PID];
    [PID release];
    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,33,300 ,2);
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
//    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}

@end
