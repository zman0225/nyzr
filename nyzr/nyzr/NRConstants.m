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
NSString *const kNRDirectoryRoot = @"directoryRoot";

+ (NSString *)defaultDownloadDirectory {
    NSURL *url = [[NSURL URLWithString:NSHomeDirectory()] URLByAppendingPathComponent:@"Downloads"];
    return [url path];
}

+ (NSString *)monitoredDirectory {
    NSString *directory = [[TMCache sharedCache] objectForKey:kNRDirectoryMonitored];
    if (!directory) {
        directory = [NRConstants defaultDownloadDirectory];
        [[TMCache sharedCache] setObject:directory forKey:kNRDirectoryMonitored];
    }
    else {
        BOOL isValid = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isValid]) {
            if (!isValid) {
                directory = [NRConstants defaultDownloadDirectory];
            }
        }
        else {
            directory = [NRConstants defaultDownloadDirectory];
        }
    }
    //    NSLog(@"monitor is %@", directory);
    
    return directory;
}

+ (NSURL *)monitoredDirectoryURL {
    return [NSURL URLWithString:[NRConstants monitoredDirectory]];
}

+ (void)setMonitoredDirectory:(NSURL *)path {
    [[TMCache sharedCache] setObject:[path path] forKey:kNRDirectoryMonitored];
}

+ (NSString *)rootDirectory {
    NSString *directory = [[TMCache sharedCache] objectForKey:kNRDirectoryRoot];
    if (!directory) {
        directory = NSHomeDirectory();
        [[TMCache sharedCache] setObject:directory forKey:kNRDirectoryRoot];
    }
    else {
        BOOL isValid = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isValid]) {
            if (!isValid) {
                directory = NSHomeDirectory();
            }
        }
        else {
            directory = NSHomeDirectory();
        }
    }
    //    NSLog(@"root is %@", directory);
    
    return directory;
}

+ (NSURL *)rootDirectoryURL {
    return [NSURL URLWithString:[NRConstants rootDirectory]];
}

+ (void)setRootDirectory:(NSURL *)path {
    [[TMCache sharedCache] setObject:[path path] forKey:kNRDirectoryRoot];
}

+ (void)createDirectory:(NSString *)dir {
    NSURL *homeURL = [NSURL fileURLWithPath:dir];
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[homeURL path] isDirectory:&isDir]) {
        if (!isDir) {
            return;
        }
        NSLog(@"%@ already exists", homeURL);
    }
    else {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtURL:homeURL withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"error %@ %@", error, homeURL);
        }
        else {
            NSLog(@"Creating directory %@", homeURL);
        }
    }
}

+ (NSArray *)allRules {
    NSArray *retval = [[TMCache sharedCache] objectForKey:kNRRules];
    if (!retval) {
        retval = @[];
        [[TMCache sharedCache] setObject:retval forKey:kNRRules];
    }
    return retval;
}

@end
