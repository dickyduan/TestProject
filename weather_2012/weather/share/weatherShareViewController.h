//
//  weatherShareViewController.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weatherHelpViewController.h"

#import "XShare.h"
/*
@protocol weatherShareDelegate <NSObject>

-(NSString*) getQWeiboAppKey;
-(NSString*) getQWeiboAppSecret;
-(NSString*) getQWeiboTokenKey;
-(NSString*) getQWeiboTokenSecret;

-(void) setQweiboTokenKey:(NSString *) string;
-(void) setQweiboTokenSecret:(NSString *) string;

@end
*/
@interface weatherShareViewController : UIViewController<XShareDelegate>
{
    IBOutlet UIImageView * background;
    weatherHelpViewController * helpWeather;

}

-(IBAction)sinaWeibo:(id)sender;
-(IBAction)tencentWeibo:(id)sender;
-(IBAction)goTOhelp:(id)sender;
@property (nonatomic,retain) UIImageView * background;
@property (nonatomic,retain) weatherHelpViewController * helpWeather;
@property (nonatomic,retain) NSString * QWeiboTokenAppKey;
@property (nonatomic,retain) NSString * QWeiboTokenSecret;
@end

