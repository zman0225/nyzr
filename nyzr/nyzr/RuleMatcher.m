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
#import <TMCache.h>
#import "NRRule.h"

@interface RuleMatcher () {
    NSArray *rules;
}

@end

@implementation RuleMatcher

- (id)init {
    self = [super init];
    if (self) {
        rules = [NRConstants allRules];
        //        [self loadRulesFromCache];
    }
    return self;
}

//- (NSString *)matchesRule:(NSString *)extension TLD:(NSString *)tld {
//    for (Rule *rule in rules) {
//        if ([rule matchesRule:extension:tld]) {
//            return [rule matchesRule:extension:tld];
//        }
//    }
//    return nil;
//}
//
//- (void)createAndSetDefaultRules {
//    NSLog(@"Setting default rules");
//    
//    
//    
//    Rule *tmp = [[TLDMatcherRule alloc] initWithTLD:@"google.com"];
//    [tmp setDirectoryToMoveTo:[@"~/Downloads/google/" stringByExpandingTildeInPath]];
//    [rules addObject:tmp];
//    tmp = [[TLDMatcherRule alloc] initWithTLD:@"facebook.com"];
//    [tmp setDirectoryToMoveTo:[@"~/Downloads/facebook/" stringByExpandingTildeInPath]];
//    [rules addObject:tmp];
//    tmp = [[ExtensionMatcherRule alloc] initWithExtension:@"pdf"];
//    [tmp setDirectoryToMoveTo:[@"~/Downloads/pdf/" stringByExpandingTildeInPath]];
//    [rules addObject:tmp];
//    
//    [[TMCache sharedCache] setObject:rules forKey:@"rules" block:nil];
//}
//
//- (void)loadRulesFromCache {
//    [[TMCache sharedCache] objectForKey:@"rules"
//                                  block: ^(TMCache *cache, NSString *key, id object) {
//                                      rules = (NSMutableArray *)object;
//                                      NSLog(@"number of rules: %lu", (unsigned long)[rules count]);
//                                      if ([rules count] == 0) {
//                                          [self createAndSetDefaultRules];
//                                          NSLog(@"number of rules: %lu", (unsigned long)[rules count]);
//                                      }
//                                  }];
//}

@end
