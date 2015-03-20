//
//  ADEngineView.h
//  ADEngine
//
//  Created by LI LEI on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiamondADView : UIView {
    
    UIViewController *parentVC;
}

@property (retain, nonatomic) UIViewController *parentVC;

- (id)requestAdOfSize:(CGSize)size bundleID:(NSString *)bundleID;

@end
