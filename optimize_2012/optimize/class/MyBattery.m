//
//  MyBattery.m
//  optimize
//
//  Created by duangl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyBattery.h"

@implementation MyBattery
@synthesize MyBatLeft,MyBatteryState;
- (id)init {
    self = [super init];
    if (self) {
        MyBatLeft = 0.0;
        MyBatteryState = 0;
    }
    return self;
}
-(void)updataMyBatteryInfo
{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES]; 
    
     MyBatLeft = [myDevice batteryLevel]*100 + 0.5; 
    MyBatteryState =[myDevice batteryState];
//    int batinfo=(MyBatLeft*100);    
    NSLog(@"Battry Level is :%0.4f and Battery Status is :%d",[myDevice batteryLevel],MyBatteryState);
}
@end
