//
//  TLDMatcherRule.m
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "TLDMatcherRule.h"

@implementation TLDMatcherRule
- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld {
    if( [tld isEqualToString:TLDToMatch] ) {
        return directoryToMoveTo;
    }
    return nil;
}

- (id)initWithTLD:(NSString*)tld {
    self = [super init];
    self->TLDToMatch = tld;
    return self;
}

@end
