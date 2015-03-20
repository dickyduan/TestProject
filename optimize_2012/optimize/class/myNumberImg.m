//
//  myNumberImg.m
//  optimize
//
//  Created by duangl on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "myNumberImg.h"

@implementation myNumberImg
+(UIImage*)makeNumberImg:(NSString *)imgName number:(int)n_number is_percent:(BOOL)isP
{
    if (![imgName hasSuffix:@".png"]) {
		NSLog(@"illegal image format!");
		return nil;
	}
    UIImage * image = [UIImage imageNamed:imgName];
    int retina = isRetina?2:1;
    
    int nbit = 0;
    int ntemp = n_number;
    while (ntemp!=0)
    {
        ntemp = ntemp/10;
        nbit ++;
    }
    if(n_number ==0)
    {
        nbit =1;
    }
    int everywide;
    int everyheigh = image.size.height;
    if(isP)
    {
        everywide = image.size.width/11;
    }
    else
    {
        everywide = image.size.width/10;
    }
    int bittemp = nbit;
    int tempNum = n_number;
    everywide = everywide*retina;
    everyheigh = everyheigh*retina;
    
    CGRect rect=CGRectMake((tempNum%10) * everywide,0, everywide,everyheigh);
//       CGRect rect=CGRectMake(7 * everywide,0, everywide,everyheigh);
    CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
    UIImage* img=[UIImage imageWithCGImage:imageRef];
    tempNum = tempNum/10;
    bittemp--;
    while (bittemp>=1) 
    {
       CGRect rect=CGRectMake((tempNum%10) * everywide,0, everywide,everyheigh);
        CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
        UIImage* elementImage1=[UIImage imageWithCGImage:imageRef];
        NSLog(@"%f  %f",img.size.width,img.size.height);
        img = [self addImage:elementImage1 toImage:img];
//       [img initWithImage: [self addImage:elementImage1 toImage:img]];
        bittemp--;
        tempNum = tempNum/10;
    }
    if(isP)
    {
        CGRect rect=CGRectMake(10 * everywide,0, everywide,everyheigh);
        CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
        UIImage* elementImage1=[UIImage imageWithCGImage:imageRef];
        img = [self addImage:img toImage:elementImage1];

    }
//    return  isRetina?[img scaleToSize:CGSizeMake(img.size.width/2, img.size.height/2)]:img;
    return img;
    
}
+(UIView*)pasteNumberImg:(NSString *)imgName number:(int)n_number is_percent:(BOOL)isP
{
    
    NSString *numberStr = [NSString stringWithFormat:@"%@_%d.png",imgName,0];
    UIImage * image = [UIImage imageNamed:numberStr];
    
    int nbit = 0;
    int ntemp = n_number;
    while (ntemp!=0)
    {
        ntemp = ntemp/10;
        nbit ++;
    }
    if(n_number ==0)
    {
        nbit =1;
    }
    int everywide = image.size.width;
    int everyheigh = image.size.height;
    
    int bittemp = nbit;
    int tempNum = n_number;
    int allwidth = isP?everywide*(nbit+1):everywide* nbit;
    int drawX = allwidth - everywide;
    UIView * View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, allwidth, everyheigh) ] ;  
    
    if(isP)
    {
        NSString *tempNumberStr = [NSString stringWithFormat:@"%@_%d.png",imgName,10];
        UIImage* img= [UIImage imageNamed:tempNumberStr];
        UIImageView * newimg= [[UIImageView alloc] initWithImage:img];
        newimg.frame = CGRectMake(drawX, 0, everywide, everyheigh);
        [View addSubview:newimg];
        [newimg release];
        
        drawX -= everywide;
    }
    
    NSString *FirstNumberStr = [NSString stringWithFormat:@"%@_%d.png",imgName,tempNum%10];
    UIImage* img= [UIImage imageNamed:FirstNumberStr];
    UIImageView * FirstView = [[UIImageView alloc] initWithImage:img];
    FirstView.frame = CGRectMake(drawX, 0, everywide, everyheigh);
    [View addSubview:FirstView];
    [FirstView release];
    drawX -= everywide;
    tempNum = tempNum/10;
    bittemp--;
    while (bittemp>=1) 
    {
        NSString *tempNumberStr = [NSString stringWithFormat:@"%@_%d.png",imgName,tempNum%10];
        UIImage* newimg= [UIImage imageNamed:tempNumberStr];
        UIImageView * newView = [[UIImageView alloc] initWithImage:newimg];
        newView.frame = CGRectMake(drawX, 0, everywide, everyheigh);
        [View addSubview:newView];
        [newView release];
        bittemp--;
        tempNum = tempNum/10;
        drawX -= everywide;
    }
    
    return  View;
}
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
{  
    CGSize size =    image2.size;
    size.width += image1.size.width;
    
    UIGraphicsBeginImageContext(size);  
    
    // Draw image1  
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];  
    // Draw image2  
    [image2 drawInRect:CGRectMake(image1.size.width, 0, image2.size.width, image2.size.height)];  
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    
    UIGraphicsEndImageContext();  
    
    return resultingImage;  
} 
@end
@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
	// 创建一个bitmap的context
	// 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContext(size);
	
	// 绘制改变大小的图片
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// 从当前context中创建一个改变大小后的图片
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	
	// 返回新的改变大小后的图片
	return scaledImage;
}

@end