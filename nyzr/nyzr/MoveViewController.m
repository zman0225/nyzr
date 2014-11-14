//
//  MoveViewController.m
//  nyzr
//
//  Created by Alex on 11/14/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "MoveViewController.h"

@implementation MoveViewController

- (id)initWithDelegate:(id <MoveControllerDelegate> )delegate {
    self = [super initWithWindowNibName:@"MoveAndMaybeAddRule"];
    if (self != nil) {
        _delegate = delegate;
    }
    return self;
}

@end
