//
//  weatherAddCityViewController.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherCityData.h"
#import "weatherCityListViewController.h"
@interface weatherAddCityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate,CityListDelegate>
{
    IBOutlet UITableView * tableView;
    IBOutlet UIImageView * background;
    IBOutlet UIButton * buttonLeft;
    IBOutlet UIButton * buttonRight;
    weatherCityListViewController * citylist;
    NSMutableArray *dataArray; 
    bool isClick;
    NSArray * sourceData;

}
@property(nonatomic,retain) UITableView * tableView;
@property(nonatomic, retain) NSMutableArray *dataArray; 
@property(nonatomic, retain) NSArray * sourceData;
@property(nonatomic,retain)  UIImageView * background;
@property(nonatomic,retain)  UIButton * buttonLeft;
@property(nonatomic,retain)  UIButton * buttonRight;
@property bool isClick;
@property(nonatomic,retain)  weatherCityListViewController * citylist;

- (void)clickleftButton;
- (void)clickRightButton;
- (void)clickFinishButton;
@end
