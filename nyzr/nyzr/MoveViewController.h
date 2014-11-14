//
//  MoveViewController.h
//  nyzr
//
//  Created by Alex on 11/14/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MoveController;

@protocol MoveControllerDelegate <NSObject>

@optional

//- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

@interface MoveViewController : NSWindowController <NSWindowDelegate>
{
    __unsafe_unretained id <MoveControllerDelegate> _delegate;
}

@end
