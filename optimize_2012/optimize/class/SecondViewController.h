//
//  SecondViewController.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhoneInfo.h"
@interface SecondViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
//    MyPhoneInfo * phoneInfo;
////    NSDictionary * MyPhoneInfo;
//    NSMutableArray  *myInfo;
//    IBOutlet UITableView * tableView;
//    NSMutableArray *keys;
//     NSTimer * drawtime;
//    NSArray * arrUpdata;
}
@property (nonatomic,retain) NSArray * arrUpdata;
@property (nonatomic,retain) NSTimer * drawtime;
@property (nonatomic,retain)    NSMutableArray * myInfo;
@property (nonatomic,retain)   NSMutableArray *keys;
@property (nonatomic,retain) MyPhoneInfo * phoneInfo;
@property(nonatomic,retain)IBOutlet UITableView * tableView;
-(void)DrawPage;
-(void)updataMyPhoneInfo;
-(void)updataArrInfo;
-(void)flash;
@end
