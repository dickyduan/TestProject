//
//  XPageControl.h
//  zaweather
//
//  Created by duangl on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPageControl : UIPageControl
{
    // 表示正常与高亮状态的图片
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
    NSInteger pageNumber;  //总页数
    NSInteger roundWithPageNum; //每个点的页数
}
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

-(int) roundNum;
@end
