//
//  NRConstants.h
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRConstants : NSObject
+ (NSString *)defaultDownloadDirectory;
+ (NSString *)monitoredDirectory;
+ (void)setMonitoredDirectory:(NSURL *)path;
+ (void)createDirectory:(NSString *)dir;
+ (NSURL *)monitoredDirectoryURL;
+ (NSArray *)allRules;

+ (NSString *)rootDirectory;
+ (NSURL *)rootDirectoryURL;
+ (void)setRootDirectory:(NSURL *)path;

extern NSString *const kNRRules;
extern NSString *const kNRDirectoryMonitored;
typedef NS_ENUM (NSInteger, NRFilterType) {
    NRFileExtension, NRTLD
};
@end
