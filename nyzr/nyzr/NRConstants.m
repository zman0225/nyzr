//
//  NRConstants.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRConstants.h"

@implementation NRConstants
+ (NSString *)defaultDirectory {
    NSURL *url = [[NSURL URLWithString:NSHomeDirectory()] URLByAppendingPathComponent:@"Downloads"];
    return [url path];
}

@end
