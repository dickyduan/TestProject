//
//  DeviceDiskConsumeStatus.m
//  optimize
//
//  Created by duangl on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeviceDiskConsumeStatus.h"

@implementation DeviceDiskConsumeStatus
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
       self.backgroundColor = [UIColor blueColor];
        // Initialization code.
         m_frame = frame;
        m_totalSpace = [self getTotalDiskSpace];
        m_freeSpace = [self getFreeDiskSpace];
        m_directorySpace = [self getDirectorySpace:nil];
        m_otherSpace = m_totalSpace - m_freeSpace - m_directorySpace;
        NSString * totalSpace = [NSString stringWithFormat:@"%.2fG",m_totalSpace];
        NSString * freeSpace = [NSString stringWithFormat:@"%.2fG",m_freeSpace];
        NSString * directorySpace = [NSString stringWithFormat:@"%.2fG",m_directorySpace];
        NSString * otherSpace = [NSString stringWithFormat:@"%.2fG",m_otherSpace];
        m_deviceData = [[NSArray alloc] initWithObjects:totalSpace,directorySpace,otherSpace,freeSpace,nil];
        m_titles = [[NSArray alloc] initWithObjects:@"容量: ",@"本地影片: ",@"其他程序: ",@"剩余空间: ",nil];
        
        
        NSLog(@"m_totalSpace:%.1fG",[self getTotalDiskSpace]);
        NSLog(@"m_freeSpace:%.1fG",m_freeSpace);
        NSLog(@"m_directorySpace:%.1fG",m_directorySpace);
        NSLog(@"m_otherSpace:%.1fG",m_otherSpace);
        [self initlabel];
        
    }
    return self;    
}

-(void)initlabel
{
    int height = CGRectGetHeight(m_frame)/2;
    int width = CGRectGetWidth(m_frame)/2; //200;
    int offset = 0;
    for (int i = 0; i < [m_titles count]; i++) 
    {
        int row = i / 2;
        int col = i % 2;
        float originX = col * (width + offset);
        float originY = row * (height + offset);
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(originX,originY,width,height)];
         label.backgroundColor = [UIColor lightGrayColor];
        NSString * text = [[m_titles objectAtIndex:i] stringByAppendingFormat:[m_deviceData objectAtIndex:i]];
        label.text = text;
       [self addSubview:label];
        [label release];
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
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %@", [error domain], [error code]); 
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
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %@", [error domain], [error code]); 
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
- (void)dealloc 
{
    [m_deviceData release];
    [m_titles release];
    [super dealloc];
}
@end
