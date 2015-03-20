//
//  MyPhoneInfo.h
//  optimize
//
//  Created by duangl on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MyPhoneInfoItem : NSObject
{
    NSString * ItemName;
    NSString *ItemContent;
    int nid;
}
@property  int nid;
@property (retain,nonatomic) NSString * ItemName;
@property (retain,nonatomic) NSString *ItemContent;

@end
@interface MyPhoneInfo : NSObject
{
    NSMutableArray * arrMyPhoneInfo;
}

@property (retain,nonatomic) NSMutableArray * arrMyPhoneInfo;
-(void)updataMyPhoneInfo;
-(void)addMyPhoneInfo:(NSString *) name Content:(NSString *) content;
-(void)addMyPhoneInfo:(NSString *) name Content:(NSString *) content InfoID:(int) infoid;

-(NSString *)getDocumentDirectoryPath;
-(NSString *)getCachesDirectoryPath;
-(NSString *)getTemporaryDirectoryPath;
-(NSString *)getHomeDirectory;
-(float)getTotalDiskSpace;
-(float)getFreeDiskSpace;
-(float)getDirectorySpace:(NSString *)directoryName;
-(NSString *) commasForNumber: (long long) num;
- (int) secondsSinceLastReboot;
-(NSString *)getLastRebootTime;
-(NSString *)getSinceLastRebootTime;
-(NSString *)getCarrier;
-(NSTimeInterval)getKerneltaskStartTime;
@end
