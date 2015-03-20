//
//  XTabBarController.m
//  weather
//
//  Created by duangl on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XTabBarController.h"
#import <QuartzCore/QuartzCore.h>
@implementation XTabBarController


-(void)tabBar:(UITabBar*)atabBar didSelectItem:(UITabBarItem*)item
{
	CATransition* animation = [CATransition animation];
	[animation setDuration:0.5f];
	[animation setType:kCATransitionFade];
	[animation setSubtype:kCATransitionFromRight];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[[self.view layer]addAnimation:animation forKey:@"switchView"];
}
@end
