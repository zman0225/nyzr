//
//  NRFileMover.m
//  nyzr
//
//  Created by Rajiv Thamburaj on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRFileMover.h"
#import "NRRule.h"

@interface NRFileMover () {
    NSArray *rules;
}

@end
@implementation NRFileMover

- (id)init {
    if (self = [super init]) {
        rules = [NRConstants allRules];
    }
    
    return self;
}

- (void)processRule:(NRRule *)rule withFile:(NRFile *)file {
    if (rule) {
        NSURL *destinationDirectory = rule.folderURL;
        [NRConstants createDirectory:[destinationDirectory path]];
        NSString *path = [file path];
        NSError *error;
        NSLog(@"Filename %@", [file name]);
        NSString *dest = [[[destinationDirectory path] stringByAppendingString:[@"/" stringByAppendingString :[file name]]] stringByExpandingTildeInPath];
        [[NSFileManager defaultManager] moveItemAtPath:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:dest error:&error];
        if (error) {
            NSLog(@"moving file %@ to %@ error: %@", file.name, dest, error);
        }
        else {
            NSLog(@"Moving %@ to %@.", [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], dest);
        }
    }
}

// Returns the directory that the file was moved to (nil if no change was made)
- (void)moveNewFile:(NRFile *)file {
//    NSString *extension = [file extension];
//    NSString *domain = [file domain];
    
    NRRule *best = nil;
    for (NRRule *rule in rules) {
        if ([rule matchesRule:file]) {
            if (!best) {
                best = rule;
            }
            else if (best.rulePriority < rule.rulePriority) {
                best = rule;
            }
        }
    }
    
    [self processRule:best withFile:file];
    //    [NRConstants createDirectory:destinationDirectory];
    //    if (!destinationDirectory) {
    //        //        NSLog(@"No rules matched");
    //
    if (!best) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"New File Downloaded";
        if ([file domain]) {
            notification.informativeText = [NSString stringWithFormat:@"%@ from %@", [file name], [file domain]];
        }
        else {
            notification.informativeText = [NSString stringWithFormat:@"%@", [file name]];
        }
        notification.soundName = NSUserNotificationDefaultSoundName;
        notification.hasActionButton = YES;
        notification.actionButtonTitle = @"Move";
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    } else {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Downloaded File Moved";
        if ([file domain]) {
            notification.informativeText = [NSString stringWithFormat:@"%@ moved to %@", [file name], [best folderURL]];
        }
        else {
            notification.informativeText = [NSString stringWithFormat:@"%@", [file name]];
        }
        notification.soundName = NSUserNotificationDefaultSoundName;
        notification.hasActionButton = YES;
        notification.actionButtonTitle = @"Undo";
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
    //
    //        return nil;
    //    }
    //
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    NSError *error;
    //
    //
    //    NSString *path = [file path];
    //    //    NSURL *sourceURL = [NSURL fileURLWithPath:path];
    //    //sourceURL = [sourceURL URLByDeletingLastPathComponent];
    //
    //    //    NSURL *destinationURL = [NSURL fileURLWithPath:[destinationDirectory stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    //    NSLog(@"Moving %@ to %@.", sourceURL, destinationURL);
    //    NSLog(@"Filename %@", [file name]);
    //    NSString *dest = [[destinationDirectory stringByAppendingString:[@"/" stringByAppendingString :[file name]]] stringByExpandingTildeInPath];
    //    NSLog(@"Moving %@ to %@.", [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], dest);
    //    [fileManager moveItemAtPath:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:dest error:&error];
    //
    //    //    [fileManager moveItemAtURL:sourceURL toURL:destinationURL error:&error];
    //
    //    NSLog(@"Error: %@", [error localizedDescription]);
    //
    //    if (!error) {
    //        NSUserNotification *notification = [[NSUserNotification alloc] init];
    //        notification.title = @"Downloaded File Moved";
    //        notification.informativeText = [NSString stringWithFormat:@"%@ moved to %@", [file name], destinationDirectory];
    //        notification.soundName = NSUserNotificationDefaultSoundName;
    //
    //        notification.hasActionButton = YES;
    //        notification.actionButtonTitle = @"Undo";
    //        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    //    }
    //
    //    return destinationDirectory;
}

@end
