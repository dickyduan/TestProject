//
//  DeviceDiskConsumeStatus.h
//  optimize
//
//  Created by duangl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDiskConsumeStatus : UIView
{
    CGRect m_frame;
    float m_totalSpace;
    float m_freeSpace;
    float m_directorySpace;
    float m_otherSpace;
    NSArray * m_deviceData;
    NSArray * m_titles;
    
}
-(NSString *)getDocumentDirectoryPath;
-(NSString *)getCachesDirectoryPath;
-(NSString *)getTemporaryDirectoryPath;
-(NSString *)getHomeDirectory;
-(float)getTotalDiskSpace;
-(float)getFreeDiskSpace;
-(float)getDirectorySpace:(NSString *)directoryName;
-(void)initlabel;
@end
