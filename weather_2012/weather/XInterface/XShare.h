//
//  XShare.h
//  zaweather
//
//  Created by duangl on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRequest.h"

@class XShare;
@protocol XShareDelegate <NSObject>

-(void) viewInited:(XShare*) share;

@end

@interface XShare : UIViewController<UITextViewDelegate,UIWebViewDelegate,WBRequestDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    // Top
    IBOutlet UIImageView* backGround;
    IBOutlet UIButton * leftButton;
    IBOutlet UIButton * rightButton;
    
    // Body
    IBOutlet UILabel * shareToWeibo;
    IBOutlet UIImageView * sharePic;
    IBOutlet UITextView * shareText;
    
    // content
    NSString    *contentText;
    UIImage     *contentImage;
    NSString * contentImageFile;
   
    UIWebView * webview;
    WBRequest * weiboRequest;
    int type;
    id<XShareDelegate> delegate;
}
@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, retain) NSString *contentImageFile;
@property (nonatomic, retain) id<XShareDelegate> delegate;

// Top
@property (nonatomic, retain) UIImageView* backGround;
@property (nonatomic, retain) UIButton * leftButton;
@property (nonatomic, retain) UIButton * rightButton;

// Body
@property (nonatomic, retain) UILabel * shareToWeibo;
@property (nonatomic, retain) UIImageView * sharePic;
@property (nonatomic, retain) UITextView * shareText;
@property int type;
- (void)setWithbackground:(NSString*) bg buttonNormal:(NSString*) btnN buttonHighly:(NSString*) btnH text:(NSString *)text image:(UIImage *)image;
- (IBAction)hide:(id)sender;
- (IBAction)sendWeibo:(id)sender;
- (void)sendWeiboWithUser;
- (void)sendWeiboWithoutUser;
- (void)load;
- (void)save;
@end


