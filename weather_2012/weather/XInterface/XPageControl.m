//
//  XPageControl.m
//  zaweather
//
//  Created by duangl on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XPageControl.h"

@interface XPageControl (private)  //声明一个私有方法，该方法不允许对象直接使用
- (void)updateDots;
@end

@implementation XPageControl
@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;
//@synthesize currentPage;

// 设置正常状态点按钮的图片
- (void)setImagePageStateNormal : (UIImage *)image
{
    imagePageStateNormal = [image retain];
}

// 设置高亮状态点按钮的图片
- (void)setImagePageStateHighlighed : (UIImage *)image
{
    imagePageStateHighlighted = [image retain];
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    
}

// 更新显示所有的点按钮
- (void)updateDots
{
    if(imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for(NSInteger i =0; i<[subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];
            if(self.currentPage == i)
            {
                dot.image = imagePageStateHighlighted;
            }
            else
            {
                dot.image = imagePageStateNormal;
            }
 
        }
    }
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page/roundWithPageNum];
    
    [self updateDots];
}
//-(NSInteger) numberOfPages
//{
//    return pageNumber;
//}
//-(int) roundNum
//{
//    return self.numberOfPages;
//}
-(void) setNumberOfPages:(NSInteger)page
{
    pageNumber = page;
    roundWithPageNum = page%6!=0?page/6+1:page/6;
    
    [super setNumberOfPages:page%roundWithPageNum!=0?page/roundWithPageNum+1:page/roundWithPageNum];    
    [self updateDots];
}
- (void)dealloc
{
    [imagePageStateNormal release], imagePageStateNormal = nil;
    [imagePageStateHighlighted release], imagePageStateHighlighted = nil;
    [super dealloc];
}

@end
