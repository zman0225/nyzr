//
//  RuleMatcher.m
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "RuleMatcher.h"
#import "Rule.h"
#import "TLDMatcherRule.h"
#import "ExtensionMatcherRule.h"

@implementation RuleMatcher

- (id)init {
    self = [super init];
    self->rules = [[NSMutableArray alloc] init];
    [self loadRulesFromFile];
    return self;
}

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld {
    for (Rule *rule in rules) {
        
        if ([rule matchesRule:extension :tld]) {
            return [rule matchesRule:extension :tld];
        }
    }
    return @"no match";
}

- (void)loadRulesFromFile {
    Rule *tmp = [[TLDMatcherRule alloc] initWithTLD:@"google.com"];
    [tmp setDirectoryToMoveTo:@"~/Downloads/google"];
    [self->rules addObject:tmp];
    tmp = [[TLDMatcherRule alloc] initWithTLD:@"facebook.com"];
    [tmp setDirectoryToMoveTo:@"~/Downloads/facebook"];
    [self->rules addObject:tmp];
    tmp = [[ExtensionMatcherRule alloc] initWithExtension:@"pdf"];
    [tmp setDirectoryToMoveTo:@"~/Downloads/pdf"];
    [self->rules addObject:tmp];
}

@end
