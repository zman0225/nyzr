//
//  FilenameMatcherRule.h
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"

@interface ExtensionMatcherRule : Rule {
    NSString *extensionToMatch;
}

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld;

- (id)initWithExtension:(NSString*)extension;

- (void) encodeWithCoder:(NSCoder *)encoder;
- (id) initWithCoder:(NSCoder *)decoder;

@end
