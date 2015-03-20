//
//  weatherWeakViewController.h
//  weather
//
//  Created by duangl on 12-2-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPageControl.h"

@interface weatherWeakViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView * scrollView;
    NSMutableArray * subViewController;
    XPageControl * pageControl;

}
@property(nonatomic,retain) XPageControl *pageControl;  

@property(nonatomic,retain) UIScrollView *scrollView;  

@property(nonatomic,retain) NSMutableArray *subViewController;


-(void)addView:(int) index;
-(void)deleteView:(int) index;
-(void)reloadIndex:(int) index;
-(void)refreshLastTimer;

-(void)create;
-(void)remove;
@end
