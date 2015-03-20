//
//  SettingController.m
//  optimize
//
//  Created by 广龙 段 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"
#import "MyPhoneInfo.h"
#import "Mytools.h"
#import "BlockTextPromptAlertView.h"
#import "AppDelegate.h"
@interface SettingController ()

@end

@implementation SettingController
@synthesize m_TableView, m_PickerView, button, myNetList,titleName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"流量设置", @"流量设置");
        isPicker = false;
        myNetList = [[MyNetList alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    Do any additional setup after loading the view from its nib.
   
    
    button.userInteractionEnabled = NO;
    self.m_TableView.scrollEnabled = NO;

}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//    if(MYSYSVER<5.0)
//    {
//        [self.titleName removeFromSuperview];
//    }
}

- (void)viewDidUnload
{
    [m_TableView release];
    [self setM_TableView:nil];
    m_TableView = nil;
    [myNetList release];
    myNetList = nil;
    [myInfo release];
    myInfo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    if(MYSYSVER<5.0)
//    {
//    titleName = [[UILabel alloc] initWithFrame: CGRectMake(0, 0 ,320, 44)];
//    titleName.textColor = [Mytools colorWithHexString:@"0xffffff"];
//    titleName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:20];
//    titleName.textAlignment = UITextAlignmentCenter;
//    titleName.backgroundColor = [UIColor clearColor];
//    titleName.numberOfLines = 0;
//    titleName.text = @"流量设置";
//    [self.navigationController.navigationBar insertSubview:titleName atIndex:2];
//    }

    myInfo = [[NSMutableArray alloc]init ];
    [myNetList updataMyNetList];
    
    [super viewDidLoad];
    MyPhoneInfoItem *item = [[MyPhoneInfoItem alloc] init];
    item.ItemName = @"包月流量";
    if(myNetList.m_Month < 0.01)
        item.ItemContent = @"未设置";
    else {
        item.ItemContent = [NSString stringWithFormat:@"%d M", (int)myNetList.m_Month]; 
    }
    [myInfo addObject:item];
    [item release];
    
    MyPhoneInfoItem *item1 = [[MyPhoneInfoItem alloc] init];
    item1.ItemName = @"本月已用流量";
    if(myNetList.m_Used < 0.01)
        item1.ItemContent = @"0 M";
    else {
        item1.ItemContent = [NSString stringWithFormat:@"%0.2f M", myNetList.m_Used]; 
    }
    [myInfo addObject:item1];
    [item1 release];
    
//    MyPhoneInfoItem *item2 = [[MyPhoneInfoItem alloc] init];
//    item2.ItemName = @"月结算日";
//    item2.ItemContent = [NSString stringWithFormat:@"%d 日", myNetList.m_CalDate];
//    [myInfo addObject:item2];
//    [item2 release]; 
    
    MyPhoneInfoItem *item3 = [[MyPhoneInfoItem alloc] init];
    item3.ItemName = @"预警点提示";
    item3.ItemContent = [NSString stringWithFormat:@"%d%%", myNetList.m_Note];;
    [myInfo addObject:item3];
    [item3 release];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [m_PickerView release];
    [m_TableView release];
//    [m_TableView release];
    [myInfo release];
    [content release];
    [myNetList release];
    if(MYSYSVER<5.0)
    {
        [self.titleName release];
    }
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
    return [myInfo count]; 
} 


// Customize the appearance of table view cells. 
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *TailCellIdentifier = @"TailCell";
    
    UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:TailCellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TailCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellEditingStyleNone;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
	for (int i=0; i<[subviews count]; i++) {
		[[subviews objectAtIndex:i] removeFromSuperview];
	}
	[subviews autorelease];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(25, 8 ,150, 20)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x113C5A"];
    Name.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    Name.text = [NSString stringWithString:[[myInfo objectAtIndex:row] ItemName]];
    [cellView addSubview:Name];
    [Name release];
    
    UILabel * Content = [[UILabel alloc] initWithFrame: CGRectMake(295-200, 8 ,200, 20)];
    
    Content.textColor = [Mytools colorWithHexString:@"0x208F8F"];
    Content.font = [UIFont fontWithName:@"Helvetica" size:14];
    Content.textAlignment = UITextAlignmentRight;
    Content.backgroundColor = [UIColor clearColor];
    Content.numberOfLines = 0;
    Content.text = [NSString stringWithString:[[myInfo objectAtIndex:row] ItemContent]];
    if([Content.text isEqualToString:@"未设置"])
        Content.textColor = [Mytools colorWithHexString:@"0xFF0000"];
    [cellView addSubview:Content];
    [Content release];
    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,33,300 ,2);
    [cellView addSubview:imageNameline];
    [imageNameline release];
    [cell.contentView addSubview:cellView];
    
    [cellView release];
    cellView = nil;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  
    if(indexPath.row < 2)
    {
        UITextField *textField;
        NSString *str;
        if(indexPath.row == 0)
            str = @"包月流量（MB）";
        else if(indexPath.row == 1)
            str = @"本月已用流量（MB)";
        BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:str message:@"" textField:&textField block:^(BlockTextPromptAlertView *alert){
            [alert.textField resignFirstResponder];
            return YES;
        }];
        
        [alert setCancelButtonWithTitle:@"取消" block:nil];
        [alert addButtonWithTitle:@"确定" block:^{
            NSScanner* scan = [NSScanner scannerWithString:textField.text];
            float val;
            if(indexPath.row == 0)
            {
                MyPhoneInfoItem *item = [myInfo objectAtIndex:0];
                if([scan scanFloat:&val] && [scan isAtEnd])
                {
                    item.ItemContent = [NSString stringWithFormat:@"%@ M", textField.text];
                    [m_TableView reloadData];
                    myNetList.m_Month = [textField.text floatValue];
                    [myNetList save];
                }
            }
            else 
            {
                MyPhoneInfoItem *item = [myInfo objectAtIndex:1];
                if([scan scanFloat:&val] && [scan isAtEnd])
                {
                    item.ItemContent = [NSString stringWithFormat:@"%@ M", textField.text];
                    [m_TableView reloadData];
                    myNetList.m_Used = [textField.text floatValue];
                    float gprs = 0;
                    for(int i=0; i<myNetList.m_MonthData.count; i++)
                    {
                        gprs += [[[myNetList.m_MonthData objectAtIndex:i] m_gprs] floatValue];
                    }
                    myNetList.m_UserSet = myNetList.m_Used-gprs;
                    [myNetList save];
                }
            }
        }];
        [alert show];
    }
    else 
    {
        if(content)
        {
            [content release];
        }
        if(indexPath.row == 2)
        {
//            content = [[NSArray alloc] initWithObjects:@"1日",@"2日",@"3日",@"4日"
//                   ,@"5日",@"6日",@"7日",@"8日"
//                   ,@"9日",@"10日",@"11日",@"12日",@"13日",@"14日",@"15",@"16日",@"17日",@"18日",@"19日",@"20日",@"21日",@"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日",nil];
//        }
//        else {
            content = [[NSArray alloc] initWithObjects:@"5%", @"10%",@"15%",@"20%",@"25%",@"30%",@"35%",@"40%",@"45%",@"50%",@"55%",@"60%",@"65%",@"70%",@"75%",@"80%",@"85%",@"90%",@"95%",nil];
        }
        m_PickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 150.0, 320.0, 216.0)];
        m_PickerView.delegate = self;
        m_PickerView.showsSelectionIndicator = YES;
        [self.view addSubview:m_PickerView];
        isPicker = true;
        button.userInteractionEnabled = YES;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}


#pragma mark -
#pragma mark 处理方法
// 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [content count];
}
// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [content objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if([content count] == 31)
//    {
//        MyPhoneInfoItem *item = [myInfo objectAtIndex:2];
//        item.ItemContent = [content objectAtIndex:row];
//        [m_TableView reloadData];
//        myNetList.m_CalDate = [[content objectAtIndex:row] intValue];
//        [myNetList save];
//    }
//    else {
        MyPhoneInfoItem *item = [myInfo objectAtIndex:2];
        item.ItemContent = [content objectAtIndex:row];
        [m_TableView reloadData];
        myNetList.m_Note = [[content objectAtIndex:row] intValue];
        [myNetList save];
//    }
}

-(IBAction)cancelPicker:(id)sender
{
    if(isPicker)
    {
        [self.m_PickerView removeFromSuperview];
        button.userInteractionEnabled = NO;
    }
}

@end
