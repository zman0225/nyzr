//
//  RuleMatcher.h
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuleMatcher : NSObject <NSCoding> {
    NSMutableArray *rules;
}

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld;
- (void) encodeWithCoder: (NSCoder*)coder;

@end
	