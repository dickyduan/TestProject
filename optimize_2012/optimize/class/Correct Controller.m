//
//  Correct Controller.m
//  optimize
//
//  Created by 广龙 段 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Correct Controller.h"

#import "BlockTextPromptAlertView.h"
#import "MyPhoneInfo.h"
#import "Mytools.h"

@interface Correct_Controller ()

@end

@implementation Correct_Controller
@synthesize m_TableView, m_TableView1, m_PickerView, button, myNetList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.title = NSLocalizedString(@"免费信息校正流量", @"免费信息校正流量");
        isPicker = false;
        myNetList = [[MyNetList alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"yidong_code" ofType:@"plist"];
        yidong = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSString *p = [[NSBundle mainBundle] pathForResource:@"liantong_code" ofType:@"plist"];
        liantong = [[NSMutableArray alloc] initWithContentsOfFile:p];
        NSString *pth = [[NSBundle mainBundle] pathForResource:@"dianxin_code" ofType:@"plist"];
        dianxin = [[NSMutableArray alloc] initWithContentsOfFile:pth];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    button.userInteractionEnabled = NO;
    
    myInfo = [[NSMutableArray alloc]init ];
    
    [super viewDidLoad];
    MyPhoneInfoItem *item = [[MyPhoneInfoItem alloc] init];
    item.ItemName = @"归属地";
    item.ItemContent = @"北京";
    [myInfo addObject:item];
    [item release];
    
    MyPhoneInfoItem *item1 = [[MyPhoneInfoItem alloc] init];
    item1.ItemName = @"运营商";
    item1.ItemContent = @"中国移动-全球通";
    [myInfo addObject:item1];
    [item1 release];

    [[self m_TableView] setScrollEnabled:NO];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [myNetList release];
    [self setMyNetList:nil];
    [myInfo release];
    myInfo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [myNetList updataMyNetList];
    
    myInfo1 = [[NSMutableArray alloc]init ];
    MyPhoneInfoItem *item2 = [[MyPhoneInfoItem alloc] init];
    item2.ItemName = @"本月已用流量";
    if(myNetList.m_Used < 0.01)
        item2.ItemContent = @"0M";
    else {
        item2.ItemContent = [NSString stringWithFormat:@"%d M", (int)myNetList.m_Used]; 
    }
    [myInfo1 addObject:item2];
    [item2 release];
    [[self m_TableView1] setScrollEnabled:NO];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [m_TableView release];
    [m_TableView1 release];
    [myInfo release];
    [myNetList release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    // Return the number of sections. 
    return 1; 
} 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    // Return the number of rows in the section. 
    if([tableView isEqual:m_TableView1])
        return [myInfo1 count];
    else
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
	}
	
	NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
	for (int i=0; i<[subviews count]; i++) {
		[[subviews objectAtIndex:i] removeFromSuperview];
	}
	[subviews autorelease];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    
    UILabel * Name = [[UILabel alloc] initWithFrame: CGRectMake(25, 11 ,150, 20)];
    
    Name.textColor = [Mytools colorWithHexString:@"0x113C5A"];
    Name.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    Name.textAlignment = UITextAlignmentLeft;
    Name.backgroundColor = [UIColor clearColor];
    Name.numberOfLines = 0;
    if([tableView isEqual:m_TableView1])
        Name.text = [NSString stringWithString:[[myInfo1 objectAtIndex:row] ItemName]];
    else
        Name.text = [NSString stringWithString:[[myInfo objectAtIndex:row] ItemName]];
    [cellView addSubview:Name];
    [Name release];
    
    UILabel * Content = [[UILabel alloc] initWithFrame: CGRectMake(295-200, 11 ,200, 20)];
    
    Content.textColor = [Mytools colorWithHexString:@"0x208F8F"];
    Content.font = [UIFont fontWithName:@"Helvetica" size:14];
    Content.textAlignment = UITextAlignmentRight;
    Content.backgroundColor = [UIColor clearColor];
    Content.numberOfLines = 0;
    if([tableView isEqual:m_TableView1])
        Content.text = [NSString stringWithString:[[myInfo1 objectAtIndex:row] ItemContent]];
    else
        Content.text = [NSString stringWithString:[[myInfo objectAtIndex:row] ItemContent]];
    [cellView addSubview:Content];
    [Content release];
    
    UIImageView *imageNameline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"optimize_cpu_line.png"]];
    imageNameline.frame = CGRectMake(10,43,300 ,2);
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
    if([tableView isEqual:m_TableView1])
    {
        UITextField *textField;
        NSString *str = @"本月已用流量（MB）";

        BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:str message:@"" textField:&textField block:^(BlockTextPromptAlertView *alert){
            [alert.textField resignFirstResponder];
            return YES;
        }];
        
        [alert setCancelButtonWithTitle:@"取消" block:nil];
        [alert addButtonWithTitle:@"确定" block:^{
            MyPhoneInfoItem *item = [myInfo1 objectAtIndex:0];
            NSScanner* scan = [NSScanner scannerWithString:textField.text];
            float val;
            if([scan scanFloat:&val] && [scan isAtEnd])
            {
                item.ItemContent = [NSString stringWithFormat:@"%@ M", textField.text];
                [m_TableView1 reloadData];
                myNetList.m_Used = [textField.text floatValue];
                float gprs = 0;
                for(int i=0; i<myNetList.m_MonthData.count; i++)
                {
                    gprs += [[[myNetList.m_MonthData objectAtIndex:i] m_gprs] floatValue];
                }
                myNetList.m_UserSet = myNetList.m_Used-gprs;
                [myNetList save];
            }

        }];
        [alert show];
    }
    else
    {
        if(content)
            [content release];
        if(indexPath.row == 0)
        {
            content = [[NSArray alloc] initWithObjects:@"北京",@"上海",@"天津",@"重庆"
                   ,@"安徽",@"福建",@"甘肃",@"广东"
                   ,@"广西",@"贵州",@"海南",@"河北",@"河南",@"黑龙江",@"湖北",@"湖南",@"吉林",@"江苏",@"江西",@"辽宁",@"内蒙古",@"宁夏",@"青海",@"山东",@"山西",@"陕西",@"四川",@"西藏",@"新疆",@"云南",@"浙江",nil];
        }
        else 
        {
            content = [[NSArray alloc] initWithObjects:@"中国移动-全球通",@"中国移动-动感地带",@"中国移动-神州行",@"中国联通-联通3G",@"中国联通-联通2G",@"中国电信",nil];
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
    if([content count] != 6)
    {
        MyPhoneInfoItem *item = [myInfo objectAtIndex:0];
        item.ItemContent = [content objectAtIndex:row];
        [m_TableView reloadData];
    }
    else {
        MyPhoneInfoItem *item = [myInfo objectAtIndex:1];
        item.ItemContent = [content objectAtIndex:row];
        [m_TableView reloadData];
    }

}

-(IBAction)cancelPicker:(id)sender
{
    if(isPicker)
    {
        [self.m_PickerView removeFromSuperview];
        button.userInteractionEnabled = NO;
    }
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;   
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }   
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)sendMsg:(id)sender
{
    MyPhoneInfoItem *itemAddress = [myInfo objectAtIndex:0];
    NSString *address = [itemAddress ItemContent];
    MyPhoneInfoItem *itemType = [myInfo objectAtIndex:1];
    NSString *type = [itemType ItemContent];
    
    NSString *toNum = @"";
    NSString *text = @"";
    
    for(int i=0; i<31; i++)
    {
        NSDictionary *dictYidong = [yidong objectAtIndex:i];
        NSDictionary *dictDianxin = [dianxin objectAtIndex:i];
        NSDictionary *dictLiantong = [liantong objectAtIndex:i];
        
        if([type isEqualToString:@"中国移动-全球通"] && [address isEqualToString:[dictYidong objectForKey:@"ProvinceName"]])
        {
            text = [dictYidong objectForKey:@"QQT_Code"];
            toNum = @"10086";
        }
        if([type isEqualToString:@"中国移动-神州行"] && [address isEqualToString:[dictYidong objectForKey:@"ProvinceName"]])
        {
            text = [dictYidong objectForKey:@"SZX_Code"];
            toNum = @"10086";
        }if([type isEqualToString:@"中国移动-动感地带"] && [address isEqualToString:[dictYidong objectForKey:@"ProvinceName"]])
        {
            text = [dictYidong objectForKey:@"DGDD_Code"];
            toNum = @"10086";
        }if([type isEqualToString:@"中国电信"] && [address isEqualToString:[dictDianxin objectForKey:@"ProvinceName"]])
        {
            text = [dictDianxin objectForKey:@"Query_Code"];
            toNum = @"10001";
        }if([type isEqualToString:@"中国联通-联通3G"] && [address isEqualToString:[dictLiantong objectForKey:@"ProvinceName"]])
        {
            text = [dictLiantong objectForKey:@"3G_Code"];
            toNum = @"10010";
        }if([type isEqualToString:@"中国联通-联通2G"] && [address isEqualToString:[dictLiantong objectForKey:@"ProvinceName"]])
        {
            text = [dictLiantong objectForKey:@"2G_Code"];
            toNum = @"10010";
        }
    }
    if ([text isEqualToString:@"暂不支持"]) {
        NSString *msg = [NSString stringWithFormat:@"%@暂不支持%@流量查询！", address, type];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else {
        [self sendSMS:text recipientList:[NSArray arrayWithObjects:toNum, nil]];
    }
}

@end
