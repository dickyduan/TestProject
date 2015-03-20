//
//  XImageView.m
//  zaweather
//
//  Created by duangl on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XImageView.h"
#import <QuartzCore/CALayer.h>

@implementation XImageView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    [super initWithCoder:aDecoder];
    rotae = 0;
    step = 0;
    timer = nil;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    return self;
}


- (void) rotating
{
    rotae+=step;
    if(rotae >= 360*3) 
        rotae = 0;
    
    if(rotae <=360)
        [self setTransform:CGAffineTransformMakeRotation(  rotae*M_PI/180)];
}

- (void)startRotatingWithSpeed:(float) aSpeed WithStep:(int) aStep
{
    step = aStep;
    if(!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1/aSpeed target:self selector:@selector(rotating) userInfo:nil repeats:YES] ;
    }

}

- (void)stopRotating
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}


@end
