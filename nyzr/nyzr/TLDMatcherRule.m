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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:TLDToMatch forKey:@"tld"];
    [encoder encodeObject:directoryToMoveTo forKey:@"directoryToMoveTo"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    NSString *tld = [decoder decodeObjectForKey:@"tld"];
    directoryToMoveTo = [decoder decodeObjectForKey:@"directoryToMoveTo"];
    self = [self initWithTLD:tld];
    [self setDirectoryToMoveTo:directoryToMoveTo];
    return self;
}


@end
