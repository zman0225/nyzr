//
//  NRFileMover.m
//  nyzr
//
//  Created by Rajiv Thamburaj on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRFileMover.h"
#import "NRRule.h"

@interface NRFileMover ()

@end
@implementation NRFileMover

- (id)init {
    if (self = [super init]) {
        self->inodes_processed = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)processRule:(NRRule *)rule withFile:(NRFile *)file {
    if (rule) {
        NSURL *destinationDirectory = rule.folderURL;
        [NRConstants createDirectory:[destinationDirectory path]];
        NSString *path = [file path];
        NSError *error;
//        NSLog(@"Filename %@", [file name]);
        NSString *dest = [[[destinationDirectory path] stringByAppendingString:[@"/" stringByAppendingString :[file name]]] stringByExpandingTildeInPath];
        
        // get file unique id
        NSNumber *fileID;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSDictionary *fattrs = [manager attributesOfItemAtPath:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] error:&error];
        if (fattrs) {
            fileID = [fattrs objectForKey:NSFileSystemFileNumber];
        }
//        NSLog(@"inode %@", fileID);
        
//        if ([inodes_processed containsObject:fileID]) {
            NSLog(@"Already did this one");
            return false;
        } else {
//            [inodes_processed addObject:fileID];
            NSLog(@"Adding to array");
        }
        
        
        [[NSFileManager defaultManager] moveItemAtPath:[path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:dest error:&error];
        if (error) {
            NSLog(@"moving file %@ to %@ error: %@", file.name, dest, error);
            return false;
        }
        else {
//            NSLog(@"Moving %@ to %@.", [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], dest);
        }
        return true;
    }
    return false;
}

// Returns the directory that the file was moved to (nil if no change was made)
- (void)moveNewFile:(NRFile *)file {
    //    NSString *extension = [file extension];
    //    NSString *domain = [file domain];
    
    NRRule *best = nil;
    for (NRRule *rule in[NRConstants allRules]) {
        if ([rule matchesRule:file]) {
            if (!best) {
                best = rule;
            }
            else if (best.rulePriority < rule.rulePriority) {
                best = rule;
            }
        }
    }
    
    if ([self processRule:best withFile:file]) {
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
            notification.identifier = [NSString stringWithFormat:@"0_|_%@_|_%@", [file name], [[NSUUID UUID] UUIDString]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
        else {
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
            notification.identifier = [NSString stringWithFormat:@"1_|_%@_|_%@_|_%@", [file name], [best folderURL], [[NSUUID UUID] UUIDString]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
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
