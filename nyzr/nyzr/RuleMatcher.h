//
//  RuleMatcher.h
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuleMatcher : NSObject

- (NSString *)matchesRule:(NSString *)extension TLD:(NSString *)tld;
- (void)createAndSetDefaultRules;

@end
