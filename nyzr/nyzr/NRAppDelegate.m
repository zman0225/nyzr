//
//  NRAppDelegate.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRAppDelegate.h"
#import "NRDirectoryMonitor.h"
#import <TMCache.h>
#import "MoveViewController.h"
#import "Panel.h"
#import "NRFile.h"
#import "NRRule.h"


@implementation NRAppDelegate

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;

#pragma mark -

- (void)dealloc {
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kContextActivePanel) {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    // Install icon into the menu bar
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    self.menubarController = [[MenubarController alloc] init];
    [NRConstants rootDirectory];
    [NRConstants monitoredDirectory];
    [NRDirectoryMonitor defaultMonitor];
    //    [[TMCache sharedCache] removeAllObjects];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

- (void)learningConfirmation:(NSString *)filename domain:(NSString *)domain andExtension:(NSString *)extension {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Extension"];
    [alert addButtonWithTitle:@"Domain"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Make a new filter?"];
    NSString *info = [NSString stringWithFormat:@"Would you like to automatically make a filter for %@?\nDomain:%@\nExtension:%@", filename, domain, extension];
    [alert setInformativeText:info];
    [alert setAlertStyle:NSWarningAlertStyle];
    NSModalResponse result = [alert runModal];
    NSLog(@"result %lu", result);
    
    NSMutableArray *dict = [[NRConstants allRules] mutableCopy];
    NRRule *rule;
    
    
    if (result == 1000) {
        NSLog(@"New rule by ext: %@", extension);
        rule = [[NRRule alloc] initWithFilter:extension folderName:filename];
        [dict addObject:rule];
        
        [[TMCache sharedCache] setObject:[[NSSet setWithArray:dict] allObjects] forKey:kNRRules];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rulesEdited" object:nil];
    }
    else if (result == 1001) {
        NSLog(@"New rule by domain: %@", domain);
        
        rule = [[NRRule alloc] initWithFilter:domain folderName:[filename stringByDeletingLastPathComponent]];
        [dict addObject:rule];
        
        [[TMCache sharedCache] setObject:[[NSSet setWithArray:dict] allObjects] forKey:kNRRules];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rulesEdited" object:nil];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    NSLog(@"Notification activated, identifier is %@", [notification identifier]);
    NSArray *info = [[notification identifier] componentsSeparatedByString:@"_|_"];
    // If file wasn't moved
    NSError *error;
    
    if ([info[0] isEqualToString:@"0"]) {
        NSLog(@"Opening interface to move file %@", info[1]);
        NSArray *urls = [Panel directoryPicker];
        if (urls && urls.count > 0) {
            NSString *source = [[NSString stringWithFormat:@"~/Downloads/%@", info[1]] stringByExpandingTildeInPath];
            
            NSURL *url = urls[0];
            url = [url URLByAppendingPathComponent:info[1]];
            [[NSFileManager defaultManager] moveItemAtPath:[source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:[[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] error:&error];
            NSLog(@"Moving %@ to %@", source, [[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            NRFile *file = [NRFile fileWithFilePath:[url path]];
            [self learningConfirmation:file.name domain:[file domain] andExtension:file.extension];
        }
        //        MoveViewController *wc = [[MoveViewController alloc] init];
        //        [[wc window] makeKeyAndOrderFront:wc];
    }
    else {
        NSString *source = [NSString stringWithFormat:@"%@/%@", info[2], info[1]];
        
        NSString *dest = [[NSString stringWithFormat:@"~/Downloads/%@", info[1]] stringByExpandingTildeInPath];
        NSLog(@"Undoing move of %@ to %@", info[1], info[2]);
        NSLog(@"Moving %@ to %@", source, dest);
        [[NSFileManager defaultManager] moveItemAtPath:[source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:dest error:&error];
    }
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    [center removeDeliveredNotification:notification];
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender {
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}

#pragma mark - Public accessors

- (PanelController *)panelController {
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller {
    return self.menubarController.statusItemView;
}

@end
