//
//  DetailController.h
//  optimize
//
//  Created by 广龙 段 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetData.h"

@interface DetailController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UIColor *defaultTintColor;
    IBOutlet UITableView *m_TableView;
    MyNetList *myNetList;
    bool isDayInfo;
}
@property (retain, nonatomic) IBOutlet UITableView *m_TableView;
@property (retain, nonatomic) MyNetList *myNetList;

@end
