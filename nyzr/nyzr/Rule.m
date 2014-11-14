//
//  Rule.m
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "Rule.h"

@implementation Rule

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld {
    NSLog(@"rule incorrectly implemented");
    return nil;
}
- (void)setDirectoryToMoveTo:(NSString*)dir {
    directoryToMoveTo = dir;
}

@end
