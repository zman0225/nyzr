//
//  NRDirectoryMonitor.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRDirectoryMonitor.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CDEvents/CDEvents.h>
#import "NRDirectory.h"

@interface NRDirectoryMonitor () {
    NSArray *paths;
    CDEvents *mainEvent;
    NSMutableDictionary *directories;
}

@end

@implementation NRDirectoryMonitor


+ (id)defaultMonitor {
    static NRDirectoryMonitor *_default = nil;
    if (_default != nil) {
        return _default;
    }
    
    @synchronized([NRDirectoryMonitor class])
    {
        // The synchronized instruction will make sure,
        // that only one thread will access this point at a time.
        if (_default == nil) {
            _default = [[NRDirectoryMonitor alloc] initWithDirectory:[NRConstants monitoredDirectory]];
        }
    }
    return _default;
}

- (id)initWithDirectory:(NSString *)folderPath {
    if (self = [super init]) {
        [self setDirectory:[NSURL URLWithString:folderPath]];
        directories = [NSMutableDictionary new];
        NRDirectory *directory = [directories objectForKey:folderPath];
        if (!directory) {
            NRDirectory *directory = [[NRDirectory alloc] initWithDirectory:folderPath];
            directories[folderPath] = directory;
        }
    }
    
    return self;
}

- (void)setDirectory:(NSURL *)folderPath {
    {
        paths = @[folderPath];
        mainEvent   = [[CDEvents alloc] initWithURLs:paths block:
                       ^(CDEvents *watcher, CDEvent *event) {
                           NSLog(@"EVENT!");
                           
                           NSString *key = [folderPath path];
                           NRDirectory *directory = [directories objectForKey:key];
                           if (directory) {
                               [directory directoryChanged];
                           }
                       }                                  onRunLoop:[NSRunLoop currentRunLoop] sinceEventIdentifier:kCDEventsSinceEventNow notificationLantency:(NSTimeInterval)0.3 ignoreEventsFromSubDirs:CD_EVENTS_DEFAULT_IGNORE_EVENT_FROM_SUB_DIRS excludeURLs:nil streamCreationFlags:kCDEventsDefaultEventStreamFlags];
    }
}

@end
