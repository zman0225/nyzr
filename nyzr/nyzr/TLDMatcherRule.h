//
//  TLDMatcherRule.h
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"

@interface TLDMatcherRule : Rule {
    NSString *TLDToMatch;
}

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld;

- (id)initWithTLD:(NSString*)tld;

@end
