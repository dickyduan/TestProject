//
//  Correct Controller.h
//  optimize
//
//  Created by 广龙 段 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetData.h"
#import <MessageUI/MFMessageComposeViewController.h>


@interface Correct_Controller : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDelegate, MFMessageComposeViewControllerDelegate>
{
    UITableView *m_TableView;
    NSMutableArray  *myInfo;
    
    UITableView *m_TableView1;
    NSMutableArray  *myInfo1;
    
    UIPickerView *m_PickerView;
    NSArray *content;
    bool isPicker;
    MyNetList *myNetList;
    
    NSArray *yidong;
    NSArray *liantong;
    NSArray *dianxin;
}

@property(retain, nonatomic) IBOutlet UITableView *m_TableView;
@property(retain, nonatomic) IBOutlet UITableView *m_TableView1;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) UIPickerView *m_PickerView;
@property (retain, nonatomic) MyNetList *myNetList;

-(IBAction)cancelPicker:(id)sender;
-(IBAction)sendMsg:(id)sender;
@end
