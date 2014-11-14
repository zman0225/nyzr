//
//  FilenameMatcherRule.m
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "ExtensionMatcherRule.h"

@implementation ExtensionMatcherRule
- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld {
    if( [extension isEqualToString:extensionToMatch] ) {
        return directoryToMoveTo;
    }
    return nil;
}

- (id)initWithExtension:(NSString *)extension {
    self = [super init];
    self->extensionToMatch = extension;
    return self;
}

@end
