//
//  MyProcess.m
//  optimize
//
//  Created by duangl on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyProcess.h"
#import "MyDevice.h"
@implementation MyProcessData
@synthesize strProcessName,strProcessCPU,strProcessUseTime,strProcessID,strprocessPriority,strProcessLastTime;
- (id)init {
    self = [super init];
    if (self) {
        strProcessName = nil;
        strProcessID = nil;
    }
    return self;
}
- (void)dealloc {

   [strProcessName release];
    [strProcessID release];
    strProcessName = nil;
    strProcessID = nil;
    [super dealloc];
}


@end

@implementation MyProcess
@synthesize arrMyProcess;

- (id)init {
    self = [super init];
    if (self) {
        self.arrMyProcess = nil;
    }
    return self;
}
-(void)updataMyProcess
{
    if(arrMyProcess)
    {
        [self.arrMyProcess removeAllObjects];
        [self.arrMyProcess release];
    }    
    self.arrMyProcess = [[NSMutableArray alloc] init];
     NSArray * processes = [[UIDevice currentDevice] runningProcesses];
    for(NSDictionary * dict in processes)
    {
        MyProcessData * tempData = [[MyProcessData alloc] init];
        tempData.strProcessID = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"ProcessID"]];
        tempData.strProcessName = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"ProcessName"]];
         tempData.strProcessCPU = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"ProcessCPU"]];
         tempData.strProcessUseTime = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"ProcessUseTime"]];
         tempData.strprocessPriority= [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"processPriority"]];
          tempData.strProcessLastTime =  [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"ProcessLastTime"]];
        

        [arrMyProcess addObject:tempData];
        [tempData release];
    }
//    for (MyProcessData * tempData in arrMyProcess)
//    {
//        NSLog(@"%@ - %@", tempData.strProcessID, tempData.strProcessName);
//         NSLog(@"%@ ***  %@", tempData.strProcessCPU, tempData.strProcessUseTime);
//    } 
}
@end
