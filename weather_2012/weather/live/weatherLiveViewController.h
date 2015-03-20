//
//  weatherLiveViewController.h
//  weather
//
//  Created by duangl on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPageControl.h"

@interface weatherLiveViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView * scrollView;
    NSMutableArray * subViewController;
    XPageControl * pageControl;

}
@property(nonatomic,retain) UIScrollView *scrollView;  
@property(nonatomic,retain) XPageControl *pageControl;  

@property(nonatomic,retain) NSMutableArray *subViewController;  

-(void)deleteView:(int) index;
-(void)addView:(int) index;
-(void)reloadIndex:(int) index;
-(void)refreshLastTimer;
@end
