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

- (void) userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    NSLog(@"Notification activated, identifier is %@", [notification identifier]);
    NSArray *info = [[notification identifier] componentsSeparatedByString: @"_|_"];
    // If file wasn't moved
    NSError *error;

    if ([info[0] isEqualToString:@"0"]) {
        NSLog(@"Opening interface to move file %@", info[1]);
        NSArray *urls = [Panel directoryPicker];
        if (urls&&urls.count>0) {
            NSString *source = [[NSString stringWithFormat:@"~/Downloads/%@", info[1]] stringByExpandingTildeInPath];

            NSURL *url = urls[0];
            url = [url URLByAppendingPathComponent:info[1]];
            [[NSFileManager defaultManager] moveItemAtPath:[source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:[[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] error:&error];
            NSLog(@"Moving %@ to %@", source, [[url path] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);

        }
//        MoveViewController *wc = [[MoveViewController alloc] init];
//        [[wc window] makeKeyAndOrderFront:wc];
        
    } else {
        NSString *source = [NSString stringWithFormat:@"%@/%@", info[2], info[1]];

        NSString *dest = [[NSString stringWithFormat:@"~/Downloads/%@", info[1]] stringByExpandingTildeInPath];
        NSLog(@"Undoing move of %@ to %@", info[1], info[2]);
        NSLog(@"Moving %@ to %@", source, dest);
        [[NSFileManager defaultManager] moveItemAtPath:[source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toPath:dest error:&error];
    }
    if (error) {
        NSLog(@"ERROR: %@",error);
    }
    [center removeDeliveredNotification: notification];
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
