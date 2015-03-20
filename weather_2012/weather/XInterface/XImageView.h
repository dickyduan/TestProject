//
//  XImageView.h
//  zaweather
//
//  Created by duangl on 12-2-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XImageView : UIImageView
{
    NSTimer * timer;
    int rotae;
    int step;
}

- (void)startRotatingWithSpeed:(float) aSpeed WithStep:(int) aStep;
- (void)stopRotating;
@end
