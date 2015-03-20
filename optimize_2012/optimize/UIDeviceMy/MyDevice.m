//
//  MyDevice.m
//  youhua
//
//  Created by duangl on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyDevice.h"
#import <sys/sysctl.h>
#import <stdlib.h>

@implementation UIDevice (ProcessesAdditimy)



- (NSArray *)runningProcesses {
    
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
  
    do {
        
        size += size / 10;
        //void    *realloc(void *, size_t);                
        //newprocess = (kinfo_proc *)realloc(process, size);
        newprocess = realloc(process, size);        
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            if (nprocess){
                NSMutableArray * array = [[NSMutableArray alloc] init];
               for (int i = nprocess - 1; i >= 0; i--)
               {
                   NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                   NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                
                   NSString * proc_CPU = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_estcpu];
                     NSString * processPriority = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_priority];
//                   p_pctcpu
                   
                   double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                   NSString *  proctime = [[NSString alloc] initWithFormat:@"%ld", process[i].kp_proc.p_un.__p_starttime.tv_sec];
                   NSLog(@"%@",proctime);

//                   NSString * proc_useTiem = [[NSString alloc] initWithFormat:@"%f",t];
                   
                   
                   NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
                        [formater setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
                   NSDate *date = [NSDate dateWithTimeIntervalSince1970:process[i].kp_proc.p_un.__p_starttime.tv_sec ];
//                  NSLog(@"%@",[formater stringFromDate:date]);
//                    NSLog(@"%@",[[NSString alloc] initWithFormat:@"%u", process[i].kp_proc.p_pctcpu] );
                  
                   NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName,proc_CPU,[formater stringFromDate:date],processPriority,proctime,nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", @"ProcessCPU",@"ProcessUseTime",@"processPriority",@"ProcessLastTime",nil]];
                                       [processID release];
                                      [processName release];
                    [array addObject:dict];
                                     [dict release];
                }
                
                free(process);
                return [array autorelease];
            }
        }
    }
    
    
      return nil;
}




@end
