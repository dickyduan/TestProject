//
//  MyPhoneInfo.m
//  optimize
//
//  Created by duangl on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyPhoneInfo.h"
#import "UIDevice-Reachability.h"

#import "UIDevice-Hardware.h"
#import "UIDevice-Capabilities.h"
#import "UIDevice-Orientation.h"
#import <mach/mach_time.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


#import "MyDevice.h"
#import "AppDelegate.h"
//#import <mach/clock.h>

#define CFN(X) [self commasForNumber:X]

//#import "Reachability.h"
@implementation MyPhoneInfoItem
@synthesize ItemName,ItemContent,nid;
- (id)init {
    self = [super init];
    if (self) {
        ItemName = nil;
        ItemContent = nil;
    }
    return self;
}
- (void)dealloc 
{
    [ItemName release];
    [ItemContent release];
    ItemName = nil;
    ItemContent = nil;
    [super dealloc];
}
@end


@implementation MyPhoneInfo
@synthesize  arrMyPhoneInfo;
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)dealloc {

    [super dealloc];
}
-(void)updataMyPhoneInfo
{
//    if(arrMyPhoneInfo)
//    {
//        [arrMyPhoneInfo removeAllObjects];
//        [arrMyPhoneInfo release];
//    }    
//    arrMyPhoneInfo = [[NSMutableArray alloc] init];
//   
//    [self addMyPhoneInfo:@"model" Content:[[UIDevice currentDevice] model]];

//    [self addMyPhoneInfo:@"系统版本"  Content:[[UIDevice currentDevice] systemVersion]];
//    [self addMyPhoneInfo:@"语言" Content:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];

//    [self addMyPhoneInfo:@"Host Name:" Content:[[UIDevice currentDevice] hostname]];
//    [self addMyPhoneInfo:@"Local IP Addy:" Content:[[UIDevice currentDevice] localIPAddress]];
////    [self addMyPhoneInfo:@"Local WiFI Addy:" Content:[[UIDevice currentDevice] localWiFiIPAddress]];
//    
//    [self addMyPhoneInfo:@"Platform:" Content:[[UIDevice currentDevice] platform]];
//    [self addMyPhoneInfo:@"Platform String:" Content:[[UIDevice currentDevice] platformString]];
//    [self addMyPhoneInfo:@"MAC地址:" Content:[[UIDevice currentDevice] macaddress]];
//    [self addMyPhoneInfo:@"总线频率:" Content:CFN([[UIDevice currentDevice] busFrequency])];
//    [self addMyPhoneInfo:@"CPU 频率:" Content:CFN([[UIDevice currentDevice] cpuFrequency])];
//    NSString * totalm ;
//    totalm = [NSString stringWithFormat:@"%d M",[[UIDevice currentDevice] totalMemory]/1024/1024 ];
//    [self addMyPhoneInfo:@"总共 内存:" Content:totalm];
//    [self addMyPhoneInfo:@"总共 内存:" Content:CFN([[UIDevice currentDevice] totalMemory])];
//     NSString * userm ;
//     userm = [NSString stringWithFormat:@"%dM",[[UIDevice currentDevice] userMemory] /1024/1024 ];
//    [self addMyPhoneInfo:@"已用 Memory:" Content:userm];
//     [self addMyPhoneInfo:@"已用 Memory:" Content:CFN([[UIDevice currentDevice] userMemory])];
////    [self addMyPhoneInfo:@"backlightlevel:" Content:[[UIDevice currentDevice] backlightlevel]];
//    
//    
//    NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",[self getTotalDiskSpace]];
//    NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",[self getFreeDiskSpace]];
//    NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",[self getDirectorySpace:nil]];
//    NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",[self getTotalDiskSpace] - [self getFreeDiskSpace] - [self getDirectorySpace:nil]];
//
//    
//    [self addMyPhoneInfo:@"硬盘容量:" Content:totalSpace];
//    [self addMyPhoneInfo:@"剩余空间:" Content:freeSpace];
//    [self addMyPhoneInfo:@"本地影片:" Content:directorySpace];
//    [self addMyPhoneInfo:@"其他程序:" Content:otherSpace];
//    [[UIDevice currentDevice] scanCapabilities];
    
}
-(void)addMyPhoneInfo:(NSString *) name Content:(NSString *) content
{
    if(content&& [content compare:@""] != NSOrderedSame)
    {
        MyPhoneInfoItem * temp = [[MyPhoneInfoItem alloc] init];
        temp.ItemName = [[NSString alloc] initWithString:name];
        temp.ItemContent = [[NSString alloc] initWithString:content];   
        [arrMyPhoneInfo addObject:temp];
        [temp release];
    }
}
-(void)addMyPhoneInfo:(NSString *) name Content:(NSString *) content InfoID:(int) infoid
{
     if(content&& [content compare:@""] != NSOrderedSame)
    {
        MyPhoneInfoItem * temp = [[MyPhoneInfoItem alloc] init];
        temp.ItemName = [[NSString alloc] initWithString:name];
        temp.ItemContent = [[NSString alloc] initWithString:content];  
        temp.nid= infoid;
        [arrMyPhoneInfo addObject:temp];
        [temp release];
    }
}
-(float)getDirectorySpace:(NSString *)directoryName
{
    // if this dirctory in homedirctory then
    NSString * dirName = @"/zing1230";
    NSString * dirPath = [[self getHomeDirectory] stringByAppendingFormat:dirName];
    NSArray * fileNames = [[NSFileManager defaultManager] directoryContentsAtPath:dirPath]; 
    int count = [fileNames count];
    float totalFileSize = 0;
    for (int i = 0; i < count; i ++) {
        NSString * fileName = [fileNames objectAtIndex:i];
        NSString * filePath = [dirPath stringByAppendingFormat:@"/%@",fileName];
        NSDictionary * infoDic = [[NSFileManager defaultManager] fileAttributesAtPath:filePath traverseLink:YES];  
        NSNumber * fileSizeInBytes = [infoDic objectForKey: NSFileSize];
        float size = [fileSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        totalFileSize += size;
    }
    return totalFileSize;
    
}
- (float)getTotalDiskSpace
{
    float totalSpace;
    NSError * error;
    NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[self getHomeDirectory] error: &error];  
    if (infoDic) {  
        NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        return totalSpace;
    } else {  
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]); 
        return 0;
    } 
}
- (float)getFreeDiskSpace
{
    float totalFreeSpace;
    NSError * error;
    NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[self getHomeDirectory] error: &error];  
    if (infoDic) {  
        NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemFreeSize];
        totalFreeSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        return totalFreeSpace;
    } else {  
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]); 
        return 0;
    } 
    
}
- (NSString *)getDocumentDirectoryPath
{
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    return [path lastObject];
}
- (NSString *)getCachesDirectoryPath
{
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [path lastObject];
    
}

-(NSString *)getTemporaryDirectoryPath
{
    NSString * tmpPath = NSTemporaryDirectory();
    return tmpPath;
}
-(NSString *)getHomeDirectory
{
    NSString * homePath = NSHomeDirectory();
    return homePath;
}
- (NSString *) commasForNumber: (long long) num
{
	if (num < 1000) return [NSString stringWithFormat:@"%lld", num];
	return	[[self commasForNumber:num/1000] stringByAppendingFormat:@",%03lld", (num % 1000)];
}
- (int) secondsSinceLastReboot{
    const int64_t kOneMillion = 1;//1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    return (int)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom)/1000000000.0f);
}
-(NSString *)getLastRebootTime
{
//    NSLog(@"secondsSinceLastReboot == %d",[self secondsSinceLastReboot]);
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self getKerneltaskStartTime]];

    
//
//   NSDate * lastRebootTime = [[NSDate date] addTimeInterval:-[self getKerneltaskStartTime]];
//    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
//    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//       [formater setTimeZone:timeZone];
//    
//    [formater setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//     NSLog(@"%@",[formater stringFromDate:[NSDate date]]);

    return  [formater stringFromDate:date];
}
-(NSString *)getSinceLastRebootTime
{
//    NSDate * lastRebootTime = [[NSDate date] addTimeInterval: -[self secondsSinceLastReboot]];
// 
//    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//    
//    NSLog(@"%@",[formater stringFromDate:lastRebootTime]);
//    return  [formater stringFromDate:lastRebootTime];
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self getKerneltaskStartTime]];
//    NSDate *nowdate = [NSData data];
//    NSLog(@"%f",[nowdate timeIntervalSinceDate: date]);
//    NSTimeInterval tempTime = [[NSData data] timeIntervalSinceDate: date];


   // int tempTime  = [[NSDate data] timeIntervalSince1970];// -[self getKerneltaskStartTime];
    
    int tempTime= time(NULL)  - [self getKerneltaskStartTime];
    
    int day = tempTime/86400;
    int hour = (tempTime - (day*86400)) /3600;
    int minute = (tempTime - (day*86400) - hour*3600)/60;
//    int second = (tempTime - (day*86400) - hour*3600 - minute*60);
    
    NSString * lastTime = [NSString stringWithFormat:@"%d天%d小时%d分",day,hour,minute] ;

    return lastTime;
}

-(NSTimeInterval )getKerneltaskStartTime
{
      AppDelegate * app = pAPPDelegate;
    NSArray * processes = app.myProcess.arrMyProcess;//[[UIDevice currentDevice] runningProcesses];
     for(MyProcessData * dict in processes)
     {
        NSString * temp =  dict.strProcessName;
         NSString * temp1 = dict.strProcessID; //[NSString stringWithFormat:@"%@",[dict objectForKey:@"ProcessID"]];
        
        if([temp  compare:@"kernel_task"] == NSOrderedSame || [temp1  compare:@"0"] == NSOrderedSame)
        {
            NSTimeInterval lastTime;
            lastTime = [dict.strProcessLastTime doubleValue];
            return lastTime;
        }
     }
    return 0;

}
-(NSString *)getCarrier
{
//    NSString *imsi = CTSIMSupportCopyMobileSubscriberIdentity();
//    if (imsi == nil || [imsi isEqualToString:@"SIM Not Inserted"] ) {
//            return @"Unknown";
//        }
//       else {
//           if ([[imsi substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"460"]) {
//              NSInteger MNC = [[imsi substringWithRange:NSMakeRange(3, 2)] intValue];
//               switch (MNC) {
//                   case 00:
//                    case 02:
//                    case 07:
//                        return @"移动 China Mobile";//移动
//                       break;
//                    case 01:
//                    case 06:    
//                        return @" 联通 China Unicom";//联通
//                        break;
//                    case 03:
//                    case 05:    
//                        return @"电信 China Telecom";//电信
//                      break;
//                    case 20:
//                       return @"铁通 China Tietong";//铁通
//                       break;
//                    default:
//                      break;
//                }
//             }
//        }
//        return @"Unknown";
    NSString * carrierName = nil;

    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        CTTelephonyNetworkInfo* netInfo=[[CTTelephonyNetworkInfo alloc] init];
        if(netInfo!=nil){
            CTCarrier* carrier=netInfo.subscriberCellularProvider;
            if(carrier!=nil){
                carrierName =[carrier carrierName];
       
            }
        }
        [netInfo release];
    }

    if (!carrierName ) {
        carrierName = @"其他";
    }
  
    return carrierName;
}
@end