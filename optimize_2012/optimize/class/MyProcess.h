//
//  MyProcess.h
//  optimize
//
//  Created by duangl on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyProcessData : NSObject
{
    NSString * strProcessName;
    NSString * strProcessID;
    NSString * strProcessCPU;
    NSString * strProcessUseTime;
    NSString * strprocessPriority;
    NSString * strProcessLastTime;

}
@property (retain,nonatomic)     NSString * strProcessLastTime;
@property (retain,nonatomic)  NSString * strProcessName;
@property (retain,nonatomic)  NSString * strProcessID;
@property (retain,nonatomic)  NSString * strProcessCPU;
@property (retain,nonatomic)  NSString * strProcessUseTime;
@property (retain,nonatomic)  NSString * strprocessPriority;
@end


@interface MyProcess : NSObject
{
    NSMutableArray * arrMyProcess;

}
@property (retain,nonatomic)  NSMutableArray * arrMyProcess;
-(void) updataMyProcess;
@end
