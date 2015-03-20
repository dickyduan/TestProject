//
//  FiveViewController.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "MyNetData.h"

@interface FiveViewController : UIViewController<CustomSegmentedControlDelegate>
{
    IBOutlet UILabel *m_UsedLabel;
    IBOutlet UILabel *m_UnusedLabel;
    IBOutlet UILabel *m_UnsetLabel;
    IBOutlet UILabel *m_MonthLabel;
    IBOutlet UILabel *m_MLabel;
    IBOutlet UILabel *m_MonthRateLabel;
    IBOutlet UIButton *m_MsgBtn;
    IBOutlet UIButton *m_RecordBtn;
    IBOutlet UIImageView *imageView;
    NSArray *segmentControlTitles;
    MyNetList *myNetList;
    
    bool isNote;
}

@property (retain, nonatomic) IBOutlet UILabel *m_UsedLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_UnusedLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_UnsetLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_MonthLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_MLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_MonthRateLabel;
@property (retain, nonatomic) IBOutlet UIButton *m_MsgBtn;
@property (retain, nonatomic) IBOutlet UIButton *m_RecordBtn;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) MyNetList *myNetList;

-(IBAction)sendMsg:(id)sender;
-(IBAction)seeDetail:(id)sender;

@end
