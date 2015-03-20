//
//  MyBattery.h
//  optimize
//
//  Created by duangl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBattery : NSObject
{
    int MyBatLeft ; 
    int MyBatteryState;

}
@property  int MyBatLeft; 
@property int MyBatteryState;
-(void)updataMyBatteryInfo;

@end
