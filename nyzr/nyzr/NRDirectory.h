//
//  NRDirectory.h
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRDirectory : NSObject
- (id)initWithDirectory:(NSString *)dir;
- (void)directoryChanged;
@end
