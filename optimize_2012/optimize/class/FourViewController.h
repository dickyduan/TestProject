//
//  FourViewController.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myMemory : NSObject
{
    NSString * Name;
    float   fValue;
    float fProportion;
}
@property(nonatomic,retain) NSString * Name;
@property float   fValue;
@property  float fProportion;
@end



@interface FourViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
  IBOutlet UITableView * tableView;
    NSMutableArray * arrMemory;
    IBOutlet UIImageView *allMemory;
    IBOutlet UIImageView *freeMemory;
    
     IBOutlet UIImageView *Imgtiao0;
     IBOutlet UIImageView *Imgtiao1;
     IBOutlet UIImageView *Imgtiao2;
     IBOutlet UIImageView *Imgtiao3;
     IBOutlet UIImageView *Imgtiao4;
        NSTimer * drawtime;
}
@property(nonatomic,retain) NSTimer * drawtime;

@property(nonatomic,retain) IBOutlet UIImageView *Imgtiao0;
@property(nonatomic,retain) IBOutlet UIImageView *Imgtiao1;
@property(nonatomic,retain) IBOutlet UIImageView *Imgtiao2;
@property(nonatomic,retain) IBOutlet UIImageView *Imgtiao3;
@property(nonatomic,retain) IBOutlet UIImageView *Imgtiao4;
@property(nonatomic,retain)IBOutlet UIImageView *allMemory;
@property(nonatomic,retain)  IBOutlet UIImageView *freeMemory;
@property(nonatomic,retain) UITableView * tableView;
@property(nonatomic,retain) NSMutableArray * arrMemory;
-(void)initArrMemory;
-(void)Updata;
-(void)UpImg;
-(void)DrawPage;

@end
