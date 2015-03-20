//
//  XShare.h
//  zaweather
//
//  Created by 王晨 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XShare : UIViewController<UITextViewDelegate,UIWebViewDelegate>
{
    // Top
    UIImageView* backGround;
    UIButton * leftButton;
    UIButton * rightButton;
    
    // Body
    UILabel * shareToWeibo;
    UIImageView * sharePic;
    UITextView * shareText;
    
    // content
    NSString    *contentText;
    UIImage     *contentImage;
    NSString * contentImageFile;

    // sina
//    NSString * sinaAppKey;
//    NSString * sinaAppSecret;
    NSString * sinaTokeyCode;
    
    // tencent
//    NSString * tencentAppkey;
//    NSString * tencentAppSecret;
    NSString * tencentTokenKey;
    NSString * tenecntTokenSecret;
}
@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, retain) NSString *contentImageFile;

- (id)initWithbackground:(NSString*) bg text:(NSString *)text image:(NSString *)image;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
@end
