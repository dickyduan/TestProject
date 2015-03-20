//
//  AppDelegate.h
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define MYSYSVER [[[UIDevice currentDevice] systemVersion] floatValue]
#define pAPPDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate] 
#import <UIKit/UIKit.h>
#import "MyProcess.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    MyProcess * myProcess;

}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) MyProcess * myProcess;

@end
