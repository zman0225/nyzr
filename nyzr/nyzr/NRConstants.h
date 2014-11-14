//
//  NRConstants.h
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRConstants : NSObject
+ (NSString *)defaultDirectory;
+ (NSString *)monitoredDirectory;
+ (void)setMonitoredDirectory:(NSURL *)path;

extern NSString *const kNRRules;
extern NSString *const kNRDirectoryMonitored;

@end
