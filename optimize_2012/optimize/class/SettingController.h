//
//  SettingController.h
//  optimize
//
//  Created by 广龙 段 on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetData.h"

@interface SettingController : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate>
{
    IBOutlet UITableView *m_TableView;
    IBOutlet UIButton *button;
    UIPickerView *m_PickerView;
    NSMutableArray  *myInfo;
    NSArray *content;
    bool isPicker;
    MyNetList *myNetList;
    
    UILabel * titleName ;
}
@property (retain, nonatomic) UILabel * titleName; 
@property (retain, nonatomic) IBOutlet UITableView *m_TableView;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) UIPickerView *m_PickerView;
@property (retain, nonatomic) MyNetList *myNetList;

-(IBAction)cancelPicker:(id)sender;

@end
