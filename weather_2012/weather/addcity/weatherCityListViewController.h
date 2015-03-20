//
//  weatherCityListViewController.h
//  zaweather
//
//  Created by duangl on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityListDelegate <NSObject>
-(void) AddCityWithIndex1:(int) index1 WithIndex2:(int) index2;
-(void) ReloadList;
@end

@interface weatherCityListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    id<CityListDelegate> delegate;
    IBOutlet UIButton * leftBtn;
    IBOutlet UIButton * rightBtn;

    IBOutlet UIImageView * background;
    IBOutlet UITableView * table;
    NSMutableArray * indexArray;
    int selectNum;
    NSMutableDictionary * selectedDict;
}
@property(nonatomic,retain) id<CityListDelegate> delegate;
@property(nonatomic,retain) UIButton * leftBtn;
@property(nonatomic,retain) UIButton * rightBtn;

@property(nonatomic,retain) UIImageView * background;
@property(nonatomic,retain) UITableView * table;
@property(nonatomic,retain) NSMutableArray * indexArray;
@property(nonatomic,retain) NSMutableDictionary * selectedDict;


-(IBAction) ClickLeft:(id) sender;
-(IBAction) ClickRight:(id) sender;

-(void) otherData;

@end
