//
//  AppDelegate.m
//  optimize
//
//  Created by duangl on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize tabBarController = _tabBarController;
@synthesize myProcess;
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    
    UIViewController *viewController3 = [[[ThreeViewController alloc] initWithNibName:@"ThreeViewController" bundle:nil] autorelease];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    
    UIViewController *viewController4 = [[[FourViewController alloc] initWithNibName:@"FourViewController" bundle:nil] autorelease];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    
    UIViewController *viewController5 = [[[FiveViewController alloc] initWithNibName:@"FiveViewController" bundle:nil] autorelease];
    UINavigationController *nav5 = [[UINavigationController alloc] initWithRootViewController:viewController5];
    if(MYSYSVER >=5.0)
            self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    else
    {
//        UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
////        [[nav1 navigationBar] insertSubview:image1 atIndex:1];
//        
//        UIImageView *image2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
//        [[nav2 navigationBar] insertSubview:image2 atIndex:1];
//        UIImageView *image3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
//        [[nav3 navigationBar] insertSubview:image3 atIndex:1];
//        UIImageView *image4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
//        [[nav4 navigationBar] insertSubview:image4 atIndex:1];
//        UIImageView *image5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topBar.png"]];
//         [[nav5 navigationBar] insertSubview:image5 atIndex:1];
//        [image1 release];
//        [image2 release];
//        [image3 release];
//        [image4 release];
//        [image5 release];
    }

    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar.png"]];
    img.frame = CGRectMake(0, 0,self.tabBarController.tabBar.frame.size.width,                                             self.tabBarController.tabBar.frame.size.height);
    img.contentMode = UIViewContentModeScaleToFill;
    [[[self tabBarController] tabBar] insertSubview:img atIndex:1];
    [img release];
    
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: nav3,nav4,nav5,nav1, nav2,nil];
 self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    self.myProcess  = [[MyProcess alloc]init];
     [self.myProcess updataMyProcess];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
