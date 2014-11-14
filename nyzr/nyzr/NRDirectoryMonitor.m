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
#import "NRFile.h"


@interface NRDirectoryMonitor () {
	NSArray *paths;
	CFRunLoopRef loopRef;
	NSArray *filenames;
	CDEvents *mainEvent;
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
			_default = [[NRDirectoryMonitor alloc] initWithDirectory:DEFAULT_DIRECTORY];
		}
	}
	return _default;
}

- (id)initWithDirectory:(NSString *)folderPath {
	if (self = [super init]) {
		[self setDirectory:[NSURL URLWithString:folderPath]];
	}
    
	return self;
}

- (void)setDirectory:(NSURL *)folderPath {
	{
		paths = @[folderPath];
		mainEvent   = [[CDEvents alloc] initWithURLs:paths block:
		               ^(CDEvents *watcher, CDEvent *event) {
                           NSLog(
                                 @"URLWatcher: %@\nEvent: %@",
                                 watcher,
                                 event
                                 );
                           [self directoryChanged:[event.URL path]];
                       }];
	}
}

- (void)directoryChanged:(NSString *)dir {
	NSError *error = nil;
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
	for (NSString *filename in contents) {
		NSString *currentPath = [[[NSURL URLWithString:dir] URLByAppendingPathComponent:filename] path];
        
		BOOL isValid = NO;
        
		isValid = [filename characterAtIndex:0] != '.' && [filename characterAtIndex:0] != '$' && [[NSFileManager defaultManager] fileExistsAtPath:currentPath isDirectory:&isValid] && !isValid;
		if (isValid) {
			NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:dir error:&error];
			NRFile *file = [[NRFile alloc] initWithName:filename withType:fileInfo.fileType withPath:currentPath withCreationDate:fileInfo.fileCreationDate andWithModificationDate:fileInfo.fileModificationDate];
		}
	}
}

@end
