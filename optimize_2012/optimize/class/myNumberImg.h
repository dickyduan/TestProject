//
//  myNumberImg.h
//  optimize
//
//  Created by duangl on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

@interface myNumberImg : UIImage

+(UIImage*)makeNumberImg:(NSString *)imgName  number:(int)n_number is_percent:(BOOL)isP;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
+(UIView*)pasteNumberImg:(NSString *)imgName number:(int)n_number is_percent:(BOOL)isP;

@end

@interface UIImage (scale)
    
-(UIImage*)scaleToSize:(CGSize)size;

@end