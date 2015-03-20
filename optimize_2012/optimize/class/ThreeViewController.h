//
//  ThreeViewController.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBattery.h"
#import "MyPhoneInfo.h"
@interface ThreeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MyBattery * myBattery;
    MyPhoneInfo * phoneInfo;
    IBOutlet UILabel *LabelBatteryState;
    IBOutlet UILabel *LabeLatteryleft;
    IBOutlet UIImageView *ImgBattery;
    
    IBOutlet UITableView * tableView;
    
    NSTimer * drawtime;
    IBOutlet UIImageView *charge1;
    IBOutlet UIImageView *charge2;
    IBOutlet UIImageView *charge_full;
    IBOutlet UIImageView *charge_null;
}

@property(nonatomic,retain) IBOutlet UIImageView *charge1;
@property(nonatomic,retain) IBOutlet UIImageView *charge2;
@property(nonatomic,retain) IBOutlet UIImageView *charge_null;
@property(nonatomic,retain) IBOutlet UIImageView *charge_full;


@property(nonatomic,retain) NSTimer * drawtime;
@property (retain, nonatomic)   IBOutlet UIImageView *ImgBattery;
@property (retain, nonatomic) IBOutlet UILabel *LabeLatteryleft;
@property (retain, nonatomic) IBOutlet UILabel *LabelBatteryState;
@property (nonatomic,retain) MyPhoneInfo * phoneInfo;
@property (nonatomic,retain) MyBattery * myBattery;
@property(nonatomic,retain) UITableView * tableView;
-(void)DrawPage;
-(void)Updata;
-(void)updataMyPhoneInfo;
-(NSString *)calculateTime:(int)num;
-(void)UpImg;
-(void)flash;
@end
