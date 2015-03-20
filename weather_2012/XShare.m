//
//  XShare.m
//  zaweather
//
//  Created by 王晨 on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XShare.h"
#import "weatherAppDelegate.h"
#define kSinaWeiBoAppKey @"3591740463"
#define kSinaWeiBoAppSecret @"fe77dc46688f47f92131ea9790a57927"
#define kSinaWeiBoUrl @"https://api.weibo.com/oauth2/authorize?client_id="
#define kTencentWeiBoAppKey @"801096727"
#define kTencentWeiBoSecret @"e6e5f37c6a14bfcf91624ec46af17e9d"
#define kTencentWeiBoUrl @"http://open.t.qq.com/cgi-bin/authorize?"

@interface XShare (Private)

- (void)onCloseButtonTouched:(id)sender;
- (void)onSendButtonTouched:(id)sender;
//- (void)onClearTextButtonTouched:(id)sender;
//- (void)onClearImageButtonTouched:(id)sender;


- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (int)textLength:(NSString *)text;
- (void)calculateTextLength;

- (void)hideAndCleanUp;

@end

@implementation XShare
@synthesize contentText;
@synthesize contentImage;
@synthesize contentImageFile;

- (id)initWithbackground:(NSString*) bg text:(NSString *)text image:(NSString *)image;
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 480)])
    {        
        // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        weatherAppDelegate * app = (weatherAppDelegate *)[[UIApplication sharedApplication] delegate]; 

        // add the background view
        backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        backGround.image = [[UIImage alloc] initWithContentsOfFile:bg];
        
        // add the buttons & labels
		closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeButton setShowsTouchWhenHighlighted:YES];
		[closeButton setFrame:CGRectMake(15, 13, 48, 30)];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
		[closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:closeButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 140, 30)];
        [titleLabel setText:NSLocalizedString(@"新浪微博", nil)];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setCenter:CGPointMake(144, 27)];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
		[titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:titleLabel];
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[sendButton setShowsTouchWhenHighlighted:YES];
		[sendButton setFrame:CGRectMake(288 - 15 - 48, 13, 48, 30)];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[sendButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[sendButton setTitle: NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
		[sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[sendButton addTarget:self action:@selector(onSendButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:sendButton];
        
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 60, 288 - 26, 150)];
		[contentTextView setEditable:YES];
		[contentTextView setDelegate:self];
        [contentTextView setText:text];
		[contentTextView setBackgroundColor:[UIColor clearColor]];
		[contentTextView setFont:[UIFont systemFontOfSize:16]];
 		[panelView addSubview:contentTextView];
        
        wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 190, 30, 30)];
		[wordCountLabel setBackgroundColor:[UIColor clearColor]];
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[wordCountLabel setFont:[UIFont systemFontOfSize:16]];
		[wordCountLabel setTextAlignment:UITextAlignmentCenter];
		[panelView addSubview:wordCountLabel];
        
        clearTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[clearTextButton setShowsTouchWhenHighlighted:YES];
		[clearTextButton setFrame:CGRectMake(240, 191, 30, 30)];
		[clearTextButton setContentMode:UIViewContentModeCenter];
 		[clearTextButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
		[clearTextButton addTarget:self action:@selector(onClearTextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:clearTextButton];
        
        // calculate the text length
        [self calculateTextLength];
        
        self.contentText = contentTextView.text;
        
        // image(if attachted)
        if (image)
        {
			CGSize imageSize = image.size;	
            CGFloat width = imageSize.width;
			CGFloat height = imageSize.height;
			CGRect tframe = CGRectMake(0, 0, 0, 0);
			if (width > height) {
				tframe.size.width = 120;
				tframe.size.height = height * (120 / width);
			}
			else {
				tframe.size.height = 80;
				tframe.size.width = width * (80 / height);
			}
			
			contentImageView = [[UIImageView alloc] initWithFrame:tframe];
			[contentImageView setImage:image];
			[contentImageView setCenter:CGPointMake(144, 260)];
			
			CALayer *layer = [contentImageView layer];
			[layer setBorderColor:[[UIColor whiteColor] CGColor]];
			[layer setBorderWidth:5.0f];
			
			[contentImageView.layer setShadowColor:[UIColor blackColor].CGColor];
            [contentImageView.layer setShadowOffset:CGSizeMake(0, 0)];
            [contentImageView.layer setShadowOpacity:0.5]; 
            [contentImageView.layer setShadowRadius:3.0];
			
			
			[panelView addSubview:contentImageView];
 			
			clearImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[clearImageButton setShowsTouchWhenHighlighted:YES];
			[clearImageButton setFrame:CGRectMake(0, 0, 30, 30)];
			[clearImageButton setContentMode:UIViewContentModeCenter];
			[clearImageButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
			[clearImageButton addTarget:self action:@selector(onClearImageButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			[clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                    contentImageView.center.y - contentImageView.frame.size.height / 2)];
            [panelView addSubview:clearImageButton];
            
            
            self.contentImage = image;
        }
        
    }
    return self;

}
#pragma mark - WBSendView Public Methods

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
		self.alpha = 0;
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
	[self removeFromSuperview];	
}
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
@end
