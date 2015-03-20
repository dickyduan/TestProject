//
//  FirstViewController.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import  "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "MyProcess.h"
#import <sys/sysctl.h>
#import <sys/types.h>
#import <mach/mach.h>
#import <mach/processor_info.h>
#import <mach/mach_host.h>

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
//    MyProcess * myProcess;
    IBOutlet UITableView * tableView;
    IBOutlet UIImageView *ImgIdle;
    
    IBOutlet UIImageView *ImgUser;

    IBOutlet UIImageView *ImgNeihe;
    IBOutlet UIImageView *ImgDiaodu;
    
//    IBOutlet UILabel *percent;
    IBOutlet UIImageView *userpercent;
    IBOutlet UIImageView *fullpercent;
    IBOutlet UIImageView *Neihepercent;
    IBOutlet UIImageView *Diaopercent;
    
     IBOutlet UIImageView *percent;
    
        float fIdle;
     float fUser;
     float fNeihe;
     float fDiaodu;
    
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
    unsigned numCPUs;
    NSTimer *drawtime;
    NSLock *CPUUsageLock;
    
}
@property processor_info_array_t cpuInfo, prevCpuInfo;
@property  mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
@property  unsigned numCPUs;
@property (retain, nonatomic) NSTimer *drawtime;
@property (retain, nonatomic) NSLock *CPUUsageLock;


@property (retain, nonatomic) IBOutlet UIImageView *percent;

@property (retain, nonatomic) IBOutlet UIImageView *userpercent;
@property (retain, nonatomic) IBOutlet UIImageView *fullpercent;
@property (retain, nonatomic) IBOutlet UIImageView *Neihepercent;
@property (retain, nonatomic) IBOutlet UIImageView *Diaopercent;
@property  float fIdle;
@property  float fUser;
@property  float fNeihe;
@property  float fDiaodu;
@property (retain, nonatomic) IBOutlet UIImageView *ImgNeihe;
@property (retain, nonatomic) IBOutlet UIImageView *ImgDiaodu;
@property (retain, nonatomic) IBOutlet UIImageView *ImgIdle;
@property (retain, nonatomic) IBOutlet UIImageView *ImgUser;

//@property (nonatomic,retain)  MyProcess * myProcess;
@property(nonatomic,retain) UITableView * tableView;
-(void)Updata;
-(void)UpImg;
-(void)DrawPage;
-(void) updateInfo;
@end
