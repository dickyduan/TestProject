
//
//  MyNetData.m
//  optimize
//
//  Created by 广龙 段 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyNetData.h"
#import "MyDevice.h"
#import "AppDelegate.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

@implementation MyNetData
@synthesize m_time, m_gprs, m_wifi;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        m_gprs = nil;
        m_time = nil;
        m_wifi = nil;
    }
    return self;
}

- (void)dealloc 
{
    [m_time release];
    [m_gprs release];
    [m_wifi release];
    m_time = nil;
    m_gprs = nil;
    m_wifi = nil;
    [super dealloc];
}
@end


@implementation MyNetList
@synthesize m_MonthData, m_TodayData, m_Used, m_Above, m_Month, m_Note, m_CalDate, m_UserSet;
@synthesize m_FirstGprs, m_FirstWifi, lastStartTime, m_UsedWifi;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        m_Month = 0;
        m_Note = 90;
        m_CalDate = 1;
        m_Above = 0;
        m_Used = 0;
        m_UserSet = 0;
        m_MonthData = nil;
        m_TodayData = nil;
        m_UsedWifi = 0;
        m_FirstGprs = 0;
        m_FirstWifi = 0;
    }
    return self;
}

- (void)dealloc 
{
    [m_MonthData release];
    [m_TodayData release];
    m_MonthData = nil;
    m_TodayData = nil;
    [super dealloc];
}

- (void) updataMyNetList
{
    if(m_MonthData)
    {
        [m_MonthData removeAllObjects];
        [m_MonthData release];
    }
    if(m_TodayData)
    {
        [m_TodayData removeAllObjects];
        [m_TodayData release];
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    int day = [[formatter stringFromDate:[NSDate date]] intValue];
    [formatter setDateFormat:@"MM"];
    int month = [[formatter stringFromDate:[NSDate date]] intValue];
    m_MonthData = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:@"netInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool isExist = [fileManager fileExistsAtPath:filepath];
    
    NSMutableArray *tempMonth = [[NSMutableArray alloc] initWithCapacity:0];
    
    MyNetList *myList = [[MyNetList alloc] init];
    [myList load];
    int fileMonth = month;
    if([myList.m_MonthData count] > 0)
        fileMonth =[[[[myList.m_MonthData objectAtIndex:0] m_time] substringToIndex:3] intValue];
    if(fileMonth != month)
    {
        [self deleteFile];
        [myList release];
        myList = [[MyNetList alloc] init];
        [myList load];
        myList.m_FirstGprs = [[self getGPRSBytes] floatValue];
        myList.m_FirstWifi = [[self getWifiBytes] floatValue];
    }
    if(!isExist)
    {
        m_FirstGprs = [[self getGPRSBytes] floatValue];
        m_FirstWifi = [[self getWifiBytes] floatValue];
        [self saveStartTime];
    }
    else
    {
        m_Month = myList.m_Month;
        m_Note = myList.m_Note;
        m_CalDate = myList.m_CalDate;
        [self loadStartTime];
        if(((int)[self getKerneltaskStartTime]) == lastStartTime)
        {
            m_FirstGprs = myList.m_FirstGprs;
            m_FirstWifi = myList.m_FirstWifi;
        }
        else 
        {
            m_FirstGprs = 0;
            m_FirstWifi = 0;
            [self saveStartTime];
        }
    }
    m_UserSet = myList.m_UserSet;
    
    if(day >= [myList.m_MonthData count])
    {
        for(int i=0; i<myList.m_MonthData.count; i++)
        {
            NSLog(@"%@", [[myList.m_MonthData objectAtIndex:i] m_wifi]);
        }
        float MonthGprs = 0, MonthWifi = 0;
        if(day > [myList.m_MonthData count])
        {
            for(int i=0; i<myList.m_MonthData.count; i++)
            {
                MonthGprs += [[[myList.m_MonthData objectAtIndex:i] m_gprs] floatValue];
                MonthWifi += [[[myList.m_MonthData objectAtIndex:i] m_wifi] floatValue];
            }
        }
        else 
        {
            for(int i=1; i<myList.m_MonthData.count; i++)
            {
                MonthGprs += [[[myList.m_MonthData objectAtIndex:i] m_gprs] floatValue];
                MonthWifi += [[[myList.m_MonthData objectAtIndex:i] m_wifi] floatValue];
            }
        }

        MyNetData *dayTemp = [[MyNetData alloc] init];
        [formatter setDateFormat:@"MM"];
        dayTemp.m_time = [formatter stringFromDate:[NSDate date]];
        if(day<10)
            dayTemp.m_time = [dayTemp.m_time stringByAppendingFormat:@"-0%d", day];
        else 
            dayTemp.m_time = [dayTemp.m_time stringByAppendingFormat:@"-%d", day];
        
        NSLog(@"%@", [self getWifiBytes]);
        
        if(day == [myList.m_MonthData count] && 
           ((int)[self getKerneltaskStartTime]) != lastStartTime)
        {
            dayTemp.m_gprs = [[myList.m_MonthData objectAtIndex:0] m_gprs];
            dayTemp.m_wifi = [[myList.m_MonthData objectAtIndex:0] m_wifi];
        }
        else
        {
            dayTemp.m_gprs = [NSString stringWithFormat:@"%0.2fM",[[self getGPRSBytes] floatValue]-MonthGprs - m_FirstGprs];
            dayTemp.m_wifi = [NSString stringWithFormat:@"%0.2fM",[[self getWifiBytes] floatValue]-MonthWifi - m_FirstWifi];
        }
        [tempMonth addObject:dayTemp];
        [dayTemp release];
        
        for(int i=[myList.m_MonthData count]+1;i<day; i++)
        {
            MyNetData *temp = [[MyNetData alloc] init];
            [formatter setDateFormat:@"MM"];
            temp.m_time = [formatter stringFromDate:[NSDate date]];
            if(i<10)
                temp.m_time = [temp.m_time stringByAppendingFormat:@"-0%d", i];
            else 
                temp.m_time = [temp.m_time stringByAppendingFormat:@"-%d", i];
            temp.m_gprs = @"0.00M";
            temp.m_wifi = @"0.00M";
            [tempMonth addObject:temp];
            [temp release];
        }
    }
    
    if(day > myList.m_MonthData.count)
    {
        for(int i=myList.m_MonthData.count; i>0; i--)
        {
            [tempMonth addObject:[myList.m_MonthData objectAtIndex:i-1]];
        }
    }
    else 
    {
        for(int i=myList.m_MonthData.count; i>1; i--)
        {
            [tempMonth addObject:[myList.m_MonthData objectAtIndex:i-1]];
        }
    }
        
    float gprs = 0, wifi = 0;
    for(int i=0; i<[tempMonth count]; i++)
    {
        gprs += [[[tempMonth objectAtIndex:i] m_gprs] floatValue];
        wifi += [[[tempMonth objectAtIndex:i] m_wifi] floatValue];
    }
    gprs += m_UserSet;
    m_UsedWifi = wifi;
    m_Used = gprs;
    m_Above = m_Month - m_Used;
    
    for(int i=[tempMonth count]; i>0; i--)
    {
        for(int j=[tempMonth count]; j>0; j--)
        {
            NSString *str = [[tempMonth objectAtIndex:j-1] m_time];
            str = [str substringFromIndex:3];
            int num = [str intValue];
            if(i == num)
            {
                [m_MonthData addObject:[tempMonth objectAtIndex:j-1]];
            }
        }
    }
    [tempMonth release];
    
    m_TodayData = [[NSMutableArray alloc] initWithCapacity:0];
    [formatter setDateFormat:@"HH"];
    int hour = [[formatter stringFromDate:[NSDate date]] intValue];
    NSMutableArray *tempDay = [[NSMutableArray alloc] initWithCapacity:0];
 
    int fileDay = day;
    if([myList.m_MonthData count] > 0)
        fileDay =[[[[myList.m_MonthData objectAtIndex:0] m_time] substringFromIndex:3] intValue];
    if(fileDay != day)
    {
        [self deleteDay];
        [myList release];
        myList = [[MyNetList alloc] init];
        [myList load];
    }
    
    float dayGprs = 0;
    float dayWifi = 0;
    
    if(hour+1 >= [myList.m_TodayData count])
    {
        if(hour+1 > [myList.m_TodayData count])
        {
            for(int i=0; i<myList.m_TodayData.count; i++)
            {
                dayGprs += [[[myList.m_TodayData objectAtIndex:i] m_gprs] floatValue];
                dayWifi += [[[myList.m_TodayData objectAtIndex:i] m_wifi] floatValue];
            }
        }
        else 
        {
            for(int i=1; i<myList.m_TodayData.count; i++)
            {
                dayGprs += [[[myList.m_TodayData objectAtIndex:i] m_gprs] floatValue];
                dayWifi += [[[myList.m_TodayData objectAtIndex:i] m_wifi] floatValue];
            }
        }
        MyNetData *temp = [[MyNetData alloc] init];
        temp.m_time = @"";
        if(hour<10)
            temp.m_time = [temp.m_time stringByAppendingFormat:@"0%d:00", hour];
        else 
            temp.m_time = [temp.m_time stringByAppendingFormat:@"%d:00", hour];
        
        if([myList.m_MonthData count] >0)
        {
            temp.m_gprs = [NSString stringWithFormat:@"%0.2fM", [[[myList.m_MonthData objectAtIndex:0] m_gprs] floatValue] - dayGprs];
            temp.m_wifi = [NSString stringWithFormat:@"%0.2fM", [[[myList.m_MonthData objectAtIndex:0] m_wifi] floatValue] - dayWifi];
        }
        else 
        {
            temp.m_gprs = [NSString stringWithFormat:@"%0.2fM", [[self getGPRSBytes] floatValue] - dayGprs - m_FirstGprs];
            temp.m_wifi = [NSString stringWithFormat:@"%0.2fM", [[self getWifiBytes] floatValue] - dayWifi - m_FirstWifi];
        }
        
        if(hour+1 == [myList.m_TodayData count] && 
           ((int)[self getKerneltaskStartTime]) != lastStartTime)
        {
            temp.m_gprs = [[myList.m_MonthData objectAtIndex:0] m_gprs];
            temp.m_wifi = [[myList.m_MonthData objectAtIndex:0] m_wifi];
        }
        
        [tempDay addObject:temp];
        [temp release];
        
        for(int i=[myList.m_TodayData count];i<hour; i++)
        {
            MyNetData *temp = [[MyNetData alloc] init];
            [formatter setDateFormat:@"MM"];
            temp.m_time = @"";
            if(i<10)
                temp.m_time = [temp.m_time stringByAppendingFormat:@"0%d:00", i];
            else 
                temp.m_time = [temp.m_time stringByAppendingFormat:@"%d:00", i];
            temp.m_gprs = @"0.00M";
            temp.m_wifi = @"0.00M";
            [tempDay addObject:temp];
            [temp release];
        }
    }

    if(hour >= myList.m_TodayData.count)
    {
        for(int i=myList.m_TodayData.count; i>0; i--)
        {
            [tempDay addObject:[myList.m_TodayData objectAtIndex:i-1]];
        }
    }
    else 
    {
        for(int i=myList.m_TodayData.count; i>1; i--)
        {
            [tempDay addObject:[myList.m_TodayData objectAtIndex:i-1]];
        }
    }    

    for(int i=[tempDay count]; i>0; i--)
    {
        for(int j=[tempDay count]; j>0; j--)
        {
            NSString *str = [[tempDay objectAtIndex:j-1] m_time];
            str = [str substringToIndex:2];
            int num = [str intValue];
            if(i-1 == num)
            {
                [m_TodayData addObject:[tempDay objectAtIndex:j-1]];
            }
        }
    }
    
    [tempDay release];
    [self save];
}

- (void) save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"netInfo.plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableArray *arrayMonth = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arrayDay = [NSMutableArray arrayWithCapacity:0];
    
    for(int i=0; i<[m_MonthData count]; i++)
    {
        MyNetData *temp = [m_MonthData objectAtIndex:i];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
        [tempDict setValue:[temp m_time] forKey:@"m_time"];
        [tempDict setValue:[temp m_gprs] forKey:@"m_gprs"];
        [tempDict setValue:[temp m_wifi] forKey:@"m_wifi"];
        [arrayMonth addObject:tempDict];
        [tempDict release];
    }
    [dict setValue:arrayMonth forKey:@"month_data"];
    
    for(int i=0; i<[m_TodayData count]; i++)
    {
        MyNetData *temp = [m_TodayData objectAtIndex:i];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
        [tempDict setValue:[temp m_time] forKey:@"m_time"];
        [tempDict setValue:[temp m_gprs] forKey:@"m_gprs"];
        [tempDict setValue:[temp m_wifi] forKey:@"m_wifi"];
        [arrayDay addObject:tempDict];
        [tempDict release];
    }
    [dict setValue:arrayDay forKey:@"today_data"];
    [dict setValue:[NSNumber numberWithFloat:m_Used] forKey:@"m_Used"];
    [dict setValue:[NSNumber numberWithFloat:m_Month] forKey:@"m_Month"];
    [dict setValue:[NSNumber numberWithFloat:m_Above] forKey:@"m_Above"];
    [dict setValue:[NSNumber numberWithFloat:m_CalDate] forKey:@"m_CalDate"];
    [dict setValue:[NSNumber numberWithFloat:m_Note] forKey:@"m_Note"];
    [dict setValue:[NSNumber numberWithFloat:m_UserSet] forKey:@"m_UserSet"];
    [dict setValue:[NSNumber numberWithFloat:m_FirstGprs] forKey:@"m_FirstGprs"];
    [dict setValue:[NSNumber numberWithFloat:m_FirstWifi] forKey:@"m_FirstWifi"];
    [dict setValue:[NSNumber numberWithFloat:m_UsedWifi] forKey:@"m_UsedWifi"];
    [dict writeToFile:path atomically:YES]; 
    [dict release];
}

- (void) load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"netInfo.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *monthArray = [dict objectForKey:@"month_data"];
    NSArray *todayArray = [dict objectForKey:@"today_data"];
    m_Above = [[dict objectForKey:@"m_Above"] floatValue];
    m_Used = [[dict objectForKey:@"m_Used"] floatValue];
    m_Month = [[dict objectForKey:@"m_Month"] floatValue];
    m_CalDate = [[dict objectForKey:@"m_CalDate"] intValue];
    m_Note = [[dict objectForKey:@"m_Note"] intValue];
    m_UserSet = [[dict objectForKey:@"m_UserSet"] floatValue];
    m_FirstGprs = [[dict objectForKey:@"m_FirstGprs"] floatValue];
    m_FirstWifi = [[dict objectForKey:@"m_FirstWifi"] floatValue];
    m_UsedWifi = [[dict objectForKey:@"m_UsedWifi"] floatValue];
    m_MonthData = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<[monthArray count]; i++)
    {
        MyNetData *temp = [[MyNetData alloc] init];
        NSMutableDictionary *dit = [monthArray objectAtIndex:i];
        temp.m_time = [dit objectForKey:@"m_time"];
        temp.m_gprs = [dit objectForKey:@"m_gprs"];
        temp.m_wifi = [dit objectForKey:@"m_wifi"];
        [m_MonthData addObject:temp];
        [temp release];
    }
    
    m_TodayData = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<[todayArray count]; i++)
    {
        MyNetData *temp = [[MyNetData alloc] init];
        NSMutableDictionary *dit = [todayArray objectAtIndex:i];
        temp.m_time = [dit objectForKey:@"m_time"];
        temp.m_gprs = [dit objectForKey:@"m_gprs"];
        temp.m_wifi = [dit objectForKey:@"m_wifi"];
        [m_TodayData addObject:temp];
        [temp release];
    }
}

- (void) saveStartTime
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"lastStartTime.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dict setValue:[NSNumber numberWithInt:[self getKerneltaskStartTime]] forKey:@"startTime"];
    [dict writeToFile:path atomically:YES]; 
    [dict release];
}

- (void) loadStartTime
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"lastStartTime.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    lastStartTime = [[dict objectForKey:@"startTime"] intValue];
}

- (void) deleteFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"netInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

- (void) deleteDay
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documemtPath = [paths objectAtIndex:0];
    NSString *path = [documemtPath stringByAppendingPathComponent:@"netInfo.plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSMutableArray *arrayMonth = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arrayDay = [NSMutableArray arrayWithCapacity:0];
    
    for(int i=0; i<[m_MonthData count]; i++)
    {
        MyNetData *temp = [m_MonthData objectAtIndex:i];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
        [tempDict setValue:[temp m_time] forKey:@"m_time"];
        [tempDict setValue:[temp m_gprs] forKey:@"m_gprs"];
        [tempDict setValue:[temp m_wifi] forKey:@"m_wifi"];
        [arrayMonth addObject:tempDict];
        [tempDict release];
    }
    [dict setValue:arrayMonth forKey:@"month_data"];
    
    [dict setValue:[NSNumber numberWithFloat:m_Used] forKey:@"m_Used"];
    [dict setValue:[NSNumber numberWithFloat:m_Month] forKey:@"m_Month"];
    [dict setValue:[NSNumber numberWithFloat:m_Above] forKey:@"m_Above"];
    [dict setValue:[NSNumber numberWithFloat:m_CalDate] forKey:@"m_CalDate"];
    [dict setValue:[NSNumber numberWithFloat:m_Note] forKey:@"m_Note"];
    [dict setValue:[NSNumber numberWithFloat:m_UserSet] forKey:@"m_UserSet"];
    [dict writeToFile:path atomically:YES]; 
    [dict release];
}

-(NSString *) getGPRSBytes 
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return @"0.00M";
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) 
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        if (!strncmp(ifa->ifa_name, "pdp_ip", 2)) 
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    NSString *str =  [NSString stringWithFormat:@"%0.2fM", 1.0*(iBytes+oBytes)/1024/1024]; 
    freeifaddrs(ifa_list);
    return str;
}

-(NSString *) getWifiBytes 
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return @"0.00K";
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) 
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        if (!strncmp(ifa->ifa_name, "en", 2)) 
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    NSString *str =  [NSString stringWithFormat:@"%0.2fM", 1.0*(iBytes+oBytes)/1024/1024]; 
    freeifaddrs(ifa_list);
    return str;
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

-(int) GetDaysOfMonth:(int)year:(int)Month
{
	int s=0;
	switch(Month)
    {
		case 0: s=31; break;
	    case 1: s=31; break;
	    case 2: s=28; break;
	    case 3: s=31; break;
	    case 4: s=30; break;
	    case 5: s=31; break;
	    case 6: s=30; break;
	    case 7: s=31; break;
	    case 8: s=31; break;
	    case 9: s=30; break;
	    case 10: s=31; break;
	    case 11: s=30; break;
	    case 12: s=31; break;
    }
    if(Month==2 && (year%4==0 && year%100!=0 || year%400==0))
        s=29;
    return s;
}
@end
