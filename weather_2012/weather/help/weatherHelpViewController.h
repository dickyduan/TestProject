//
//  weatherHelpViewController.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weatherHelpViewController : UIViewController
{
    IBOutlet UIImageView * background;
    IBOutlet UITextView * text;
    IBOutlet UIButton * closed;
}
@property (nonatomic,retain) UITextView * text;
@property (nonatomic,retain) UIImageView * background;
@property (nonatomic,retain) UIButton * closed;

-(IBAction)Closed:(id)sender;
- (void)viewWillAppear:(BOOL)animated;
@end

