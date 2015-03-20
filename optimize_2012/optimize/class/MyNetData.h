//
//  MyNetData.h
//  optimize
//
//  Created by 广龙 段 on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNetData : NSObject
{
    NSString *m_time;
    NSString *m_gprs;
    NSString *m_wifi;
}

@property (retain, nonatomic) NSString *m_time;
@property (retain, nonatomic) NSString *m_gprs;
@property (retain, nonatomic) NSString *m_wifi;
@end

@interface MyNetList : NSObject
{
    float m_Used;           //已用流量
    float m_Month;          //包月流量
    float m_Above;          //超额流量
    float m_UserSet;        //用户设置量
    int m_CalDate;          //结算日
    int m_Note;             //预警点提示
    float m_FirstGprs;      //第一次使用前gprs
    float m_FirstWifi;      //第一次使用前wifi
    float m_UsedWifi;
    
    int lastStartTime;
    
    NSMutableArray * m_MonthData;
    NSMutableArray * m_TodayData;
}
@property (retain,nonatomic)  NSMutableArray * m_MonthData;
@property (retain,nonatomic)  NSMutableArray * m_TodayData;
@property (nonatomic) float m_Used;
@property (nonatomic) float m_Month;
@property (nonatomic) float m_Above;
@property (nonatomic) int m_CalDate;
@property (nonatomic) int m_Note;
@property (nonatomic) float m_UserSet;
@property (nonatomic) float m_FirstGprs;
@property (nonatomic) float m_FirstWifi;
@property (nonatomic)  int lastStartTime;
@property (nonatomic) float m_UsedWifi;


- (void) updataMyNetList;
- (void) save;
- (void) load;
- (void) saveStartTime;
- (void) loadStartTime;
- (void) deleteFile;
- (void) deleteDay;
-(NSString *) getGPRSBytes ;
-(NSString *) getWifiBytes ;
-(int) GetDaysOfMonth:(int)year:(int)Month;
-(NSTimeInterval )getKerneltaskStartTime;

@end
