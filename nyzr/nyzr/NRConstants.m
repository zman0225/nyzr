//
//  NRConstants.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRConstants.h"
#import <TMCache.h>

@implementation NRConstants
NSString *const kNRRules = @"rulesDictionary";
NSString *const kNRDirectoryMonitored = @"directoryMonitored";

+ (NSString *)defaultDirectory {
    NSURL *url = [[NSURL URLWithString:NSHomeDirectory()] URLByAppendingPathComponent:@"Downloads"];
    return [url path];
}

+ (NSString *)monitoredDirectory {
    NSString *directory = [[TMCache sharedCache] objectForKey:kNRDirectoryMonitored];
    if (!directory) {
        directory = [NRConstants defaultDirectory];
        [[TMCache sharedCache] setObject:directory forKey:kNRDirectoryMonitored];
    }
    else {
        BOOL isValid = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isValid]) {
            if (!isValid) {
                directory = [NRConstants defaultDirectory];
            }
        }
        else {
            directory = [NRConstants defaultDirectory];
        }
    }
    return directory;
}

+ (void)setMonitoredDirectory:(NSURL *)path {
    [[TMCache sharedCache] setObject:[path path] forKey:kNRDirectoryMonitored];
}

@end
