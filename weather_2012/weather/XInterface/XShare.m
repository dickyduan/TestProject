//
//  XShare.m
//  zaweather
//
//  Created by duangl on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XShare.h"
#import "weatherAppDelegate.h"
#import "QWeiboSyncApi.h"
#import "NSURL+QAdditions.h"
#import "NSObject+SBJson.h"
#import <QuartzCore/QuartzCore.h>
#define kSinaWeiBoAppKey @"735605087"
#define kSinaWeiBoAppSecret @"cbb52c534d76582ea555b44a9eea24ae"
#define kSinaWeiBoUrl @"https://api.weibo.com/oauth2/authorize?client_id="
#define ktencentWeiBoAppKey @"801113719"
#define ktencentWeiBoSecret @"ed9862b92cfac46c5ed7a41898d161f8"
#define ktencentWeiBoUrl @"http://open.t.qq.com/cgi-bin/authorize?"

#define kWBAuthorizeURL     @"https://api.weibo.com/oauth2/authorize"
#define kWBAccessTokenURL   @"https://api.weibo.com/oauth2/access_token"
#define kWBUploadURL        @"statuses/upload.json"
#define kWBSDKAPIDomain     @"https://api.weibo.com/2/"

// sina
NSString * sinaTokeyCode = nil;
NSString * sinaUserName = nil;
NSString * sinaTime = nil;
NSDate * sinaDate = nil;
// tencent
NSString * tencentTokenKey = nil;
NSString * tencentTokenSecret = nil;
NSString * tencentVerify = nil;
NSString * tencentUserName = nil;

@implementation XShare
@synthesize contentText;
@synthesize contentImage;
@synthesize contentImageFile;
@synthesize  backGround;
@synthesize  leftButton;
@synthesize  rightButton;
@synthesize  delegate;
@synthesize  shareToWeibo;
@synthesize  sharePic;
@synthesize  shareText;
@synthesize  type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self view] = [self view2];
        webview = nil;
        weiboRequest = nil;
        [self load];
    }
    
    return self;
}

- (void)setWithbackground:(NSString*) bg buttonNormal:(NSString*) btnN buttonHighly:(NSString*) btnH text:(NSString *)text image:(UIImage *)image
{
    
    backGround.image = GetImage(bg);
    [leftButton setBackgroundImage:[UIImage imageNamed:btnN] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:btnN] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:btnH] forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:btnH] forState:UIControlStateHighlighted];
    shareText.text = text;
    
//    [shareText.layer setCornerRadius:10];
    sharePic.image = image;
//    [image release];
//    [sharePic.layer setCornerRadius:10];
   
    [shareText becomeFirstResponder];
    [shareText setSelectedRange:NSMakeRange(0, 0)];
    switch (type) {
        case 1:
        {
            shareToWeibo.text = @"分享至新浪微博";
            //UIWebView
        }
            break;
        case 2:
        {
            shareToWeibo.text = @"分享至腾讯微博";
        }
            break;
        default:
            break;
    }
}


#pragma mark - WBSendView Public Methods
- (void)viewWillAppear:(BOOL)animated
{
    
}// Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated
{
    
}// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
    
}// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated
{
    
}// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidLoad
{
    [[self delegate] viewInited:self];
}

- (void)viewDidUnload
{
    [backGround.image release]; backGround.image = nil;
    [sharePic.image release]; sharePic.image = nil;

}
- (IBAction)hide:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)webViewOK
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    [app.HUD show:YES];
}
-(void)webViewCancel
{
    [webview removeFromSuperview];
    webview = nil;
    [shareText becomeFirstResponder];
    
}
- (IBAction)sendWeibo:(id)sender
{    
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [shareText resignFirstResponder];
    if(type ==1)
    {
        if(sinaUserName)
        {
            
            UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"分享至新浪微博" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"使用%@账号分享",sinaUserName],@"使用其他账号分享",nil];
            [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            [sheet showFromRect:app.tabBarController.view.bounds inView:app.tabBarController.view animated:YES];
            [sheet release];
        }
        else
        {
            [self sendWeiboWithoutUser];
        }
    }
    else if(type ==2)
    {
        if(tencentUserName)
        {
            UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"分享至腾讯微博" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"使用%@账号分享",tencentUserName],@"使用其他账号分享",nil];
            [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            [sheet showFromRect:app.tabBarController.view.bounds inView:app.tabBarController.view animated:YES];
            [sheet release];
        }
        else 
        {
            [self sendWeiboWithoutUser];
        }
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
    if (buttonIndex == actionSheet.cancelButtonIndex) 
    { return; }
    
    switch (buttonIndex) 
    { 
        case 0: { 
            weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
            [[app HUD] show:NO];
            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(sendWeiboWithUser) userInfo:nil repeats:NO];
//            [self sendWeiboWithUser];
            break; 
        } 
        case 1: { 
            [self sendWeiboWithoutUser];
            break; 
        } 
    } 
}
- (void)sendWeiboWithUser
{

    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    if(type == 1 )
    {
        NSLog(@"%d <> %d",abs([[NSDate date] timeIntervalSinceDate:sinaDate]),[sinaTime intValue]);
        if(abs([[NSDate date] timeIntervalSinceDate:sinaDate]) > [sinaTime intValue])
        {
            [self sendWeiboWithoutUser];
        }
        else
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
            [params setObject:shareText.text forKey:@"status"];
            [params setObject:sharePic.image forKey:@"pic"];
            [params setObject:sinaTokeyCode forKey:@"access_token"];
            
            NSMutableDictionary *header = [NSMutableDictionary dictionaryWithCapacity:1];
            [header setObject:sinaTokeyCode forKey:@"access_token"];
            
//            [weiboRequest disconnect];
            weiboRequest = [WBRequest requestWithURL:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, kWBUploadURL]
                                          httpMethod:@"POST"
                                              params:params
                                        postDataType:kWBRequestPostDataTypeMultipart
                                    httpHeaderFields:header 
                                            delegate:self];
            [weiboRequest connect];

        }
    }
    else if(type == 2)
    {
        QWeiboSyncApi * api = [[QWeiboSyncApi alloc] init];

        NSString * res = [api publishMsgWithConsumerKey:ktencentWeiBoAppKey consumerSecret:ktencentWeiBoSecret accessTokenKey:tencentTokenKey accessTokenSecret:tencentTokenSecret content:shareText.text imageFile:sharePic.image resultType:RESULTTYPE_JSON];
        
        [api release];
        [[app HUD] hide:YES];
        [shareText becomeFirstResponder];
        //    sinaTokeyCode = nil;
        
        if([[[res JSONValue] objectForKey:@"msg"] isEqual:@"ok"])
        {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                               message:@"微博发送成功！" 
                                                              delegate:self
                                                     cancelButtonTitle:@"确定" 
                                                     otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        else
        {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                               message:@"微博发送失败！" 
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定" 
                                                     otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
}
- (void)sendWeiboWithoutUser
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)]; 
    //    webview.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0);
    UINavigationBar * bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem * item = [[UINavigationItem alloc] initWithTitle:@"微博分享"];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(webViewCancel)];
    [bar pushNavigationItem:item animated:NO];
    [item setLeftBarButtonItem:left];
    [webview addSubview:bar];
    [left release];
    [item release];
    [bar release];
    
    [webview setDelegate:self];
    [webview setHidden:YES];
    [app.HUD show:YES];
    [self.view addSubview:webview];
    
    if (type ==1 )   //sina
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:kSinaWeiBoAppKey, @"client_id",
                                @"code", @"response_type",
                                @"http://", @"redirect_uri", 
                                @"wap2.0", @"display", nil];
        NSString *urlString = [WBRequest serializeURL:@"https://api.weibo.com/oauth2/authorize"
                                               params:params
                                           httpMethod:@"GET"];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [webview loadRequest:request];
        
    }
    else if (type ==2)  //tencent
    {
        QWeiboSyncApi * api = [[QWeiboSyncApi alloc] init];
        
        NSString * resStr = [api getRequestTokenWithConsumerKey:ktencentWeiBoAppKey consumerSecret:ktencentWeiBoSecret];
        
        NSDictionary *params = [NSURL parseURLQueryString:resStr];
        tencentTokenKey = [[params objectForKey:@"oauth_token"] retain];
        tencentTokenSecret = [[params objectForKey:@"oauth_token_secret"] retain];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ktencentWeiBoUrl, resStr]]];
        [api release];
        [webview loadRequest:request];
    }
    
    [webview release];
}
- (void) lazytencent
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    
    static int i = 0;
    if(i == 0) 
    {
        i=1;
        [app.HUD show:YES];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lazytencent) userInfo:nil repeats:NO];
        return;
    }

    QWeiboSyncApi *api = [[QWeiboSyncApi alloc] init];
    NSString *retString = [api getAccessTokenWithConsumerKey:ktencentWeiBoAppKey 
                                              consumerSecret:ktencentWeiBoSecret 
                                             requestTokenKey:tencentTokenKey 
                                          requestTokenSecret:tencentTokenSecret
                                                      verify:tencentVerify];
    NSDictionary *params = [NSURL parseURLQueryString:retString];
    tencentTokenKey = [[params objectForKey:@"oauth_token"] retain];
    tencentTokenSecret = [[params objectForKey:@"oauth_token_secret"] retain];
    [self save];
    tencentVerify = nil;
    NSString * res = [api publishMsgWithConsumerKey:ktencentWeiBoAppKey consumerSecret:ktencentWeiBoSecret accessTokenKey:tencentTokenKey accessTokenSecret:tencentTokenSecret content:shareText.text imageFile:sharePic.image resultType:RESULTTYPE_JSON];
    
    [api release];
    [[app HUD] hide:YES];
    [shareText becomeFirstResponder];
//    sinaTokeyCode = nil;

    if([[[res JSONValue] objectForKey:@"msg"] isEqual:@"ok"])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"微博发送成功！" 
                                                          delegate:self
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"微博发送失败！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }

}
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    if(type == 1)
    {
        NSString * login = [webview stringByEvaluatingJavaScriptFromString:@"document.authZForm.userId.value"];
        NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
        if (range.location != NSNotFound)
        {
            [aWebView removeFromSuperview];
            webview = nil;
            
            NSString * tokencode = [request.URL.absoluteString substringFromIndex:range.location + range.length];
            
            if(![tokencode isEqual:@"21330"])
            {
                sinaUserName = [login retain];
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(webViewOK) userInfo:nil repeats:NO];
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:kSinaWeiBoAppKey, @"client_id",
                                    kSinaWeiBoAppSecret, @"client_secret",
                                    @"authorization_code", @"grant_type",
                                    @"http://", @"redirect_uri",
                                    tokencode, @"code", nil];
//                [weiboRequest disconnect];
                weiboRequest = [WBRequest requestWithURL:kWBAccessTokenURL
                                                  httpMethod:@"POST"
                                                      params:params
                                                postDataType:kWBRequestPostDataTypeNormal
                                            httpHeaderFields:nil 
                                                    delegate:self];
                [weiboRequest connect];
                
            }
            else
            {
                [self webViewCancel];
            }
        }
    }
    else if(type ==2)
    {

        NSRange range = [request.URL.absoluteString rangeOfString:@"oauth_verifier="];
        NSString * login = [webview stringByEvaluatingJavaScriptFromString:@"document.loginform.u.value"];
        if([login length]>0)
            tencentUserName = [login retain];

        if (range.location != NSNotFound)
        {
            [aWebView removeFromSuperview];
            webview = nil;
            
            tencentVerify  = [[request.URL.absoluteString substringFromIndex:range.location + range.length] retain];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lazytencent) userInfo:nil repeats:NO];
            
        }
    }  
    return YES;
}
- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [[app HUD] hide:YES];
    [shareText becomeFirstResponder];
//    sinaTokeyCode = nil;

    if([request.url isEqual:kWBAccessTokenURL])
    {

        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"微博验证失败！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"微博发送失败！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }

}

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result
{
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

    if([request.url isEqual:kWBAccessTokenURL])
    {
        BOOL success = NO;
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)result;
            
            NSString *token = [dict objectForKey:@"access_token"];
            NSString *userID = [dict objectForKey:@"uid"];
            NSString *seconds = [dict objectForKey:@"expires_in"];
            success = token && userID;
            
            if (success)
            {
                sinaTokeyCode = [token retain];
                sinaTime = [seconds retain];
                sinaDate = [[NSDate date] retain];
                [self save];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
                [params setObject:shareText.text forKey:@"status"];
                [params setObject:sharePic.image forKey:@"pic"];
                [params setObject:sinaTokeyCode forKey:@"access_token"];

                NSMutableDictionary *header = [NSMutableDictionary dictionaryWithCapacity:1];
                [header setObject:sinaTokeyCode forKey:@"access_token"];

                [weiboRequest disconnect];
                weiboRequest = [WBRequest requestWithURL:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, kWBUploadURL]
                                              httpMethod:@"POST"
                                                  params:params
                                            postDataType:kWBRequestPostDataTypeMultipart
                                        httpHeaderFields:header 
                                                delegate:self];
                [weiboRequest connect];
            }
        }
    }
    else
    {
        [[app HUD] hide:YES];
        [shareText becomeFirstResponder];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"微博发送成功！" 
                                                          delegate:self
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(tencentVerify)
        return;
    weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 
    [app.HUD hide:YES];
    [webView setHidden:NO];
}
- (void)load
{    
    id dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"xshare"];
    if (dict == nil )
    {
        [self save];
        return;
    }
    sinaTokeyCode = [[dict objectForKey:@"sinaTokeyCode"] retain];
    sinaUserName = [[dict objectForKey:@"sinaUserName"] retain];
    sinaTime = [[dict objectForKey:@"sinaTime"] retain];
    sinaDate = [[dict objectForKey:@"sinaDate"] retain];
    tencentTokenKey = [[dict objectForKey:@"tencentTokenKey"] retain];
    tencentTokenSecret = [[dict objectForKey:@"tencentTokenSecret"] retain];
//    tencentVerify = [[dict objectForKey:@"tencentVerify"] retain];
    tencentUserName = [[dict objectForKey:@"tencentUserName"] retain];
}
- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:sinaTokeyCode forKey:@"sinaTokeyCode"];
    [dict setValue:sinaUserName forKey:@"sinaUserName"];
    [dict setValue:sinaTime forKey:@"sinaTime"];
    [dict setValue:sinaDate forKey:@"sinaDate"];
    [dict setValue:tencentTokenKey forKey:@"tencentTokenKey"];
    [dict setValue:tencentTokenSecret forKey:@"tencentTokenSecret"];
//    [dict setValue:tencentVerify forKey:@"tencentVerify"];
    [dict setValue:tencentUserName forKey:@"tencentUserName"];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"xshare"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
- (void)show:(BOOL)animated
{
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    
    if (animated)
    {
//        [panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
//        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
//        [panelView setAlpha:0.5];
//        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [self allAnimationsStopped];
    }
	
//	[self addObservers];
    
}

- (void)hide:(BOOL)animated
{    
	if (animated)
    {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		[UIView commitAnimations];
	} else {
		
		[self hideAndCleanUp];
	}
}

#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
//    [panelView setAlpha:0.8];
//	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
//    [panelView setAlpha:1.0];
//	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
//    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
//	[self removeFromSuperview];	
}
 */
#pragma mark Text Length

- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}
/*
- (void)calculateTextLength
{
    if (contentTextView.text.length > 0) 
	{ 
		[sendButton setEnabled:YES];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else 
	{
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	
	int wordcount = [self textLength:contentTextView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
    {
		[wordCountLabel setTextColor:[UIColor redColor]];
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
	else
    {
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[sendButton setEnabled:YES];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	[wordCountLabel setText:[NSString stringWithFormat:@"%i",count]];
}
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self hide:nil];
}

@end
