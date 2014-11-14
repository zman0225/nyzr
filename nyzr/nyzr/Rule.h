//
//  Rule.h
//  nyzr
//
//  Created by Alex on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rule : NSObject {
    NSString *directoryToMoveTo;
}

- (NSString*)matchesRule:(NSString*)extension :(NSString*)tld;
- (void)setDirectoryToMoveTo:(NSString*)dir;
@end
