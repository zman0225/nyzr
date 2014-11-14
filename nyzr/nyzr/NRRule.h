//
//  NRRule.h
//  nyzr
//
//  Created by Ziyuan Liu on 11/14/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRFile.h"

@interface NRRule : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSURL *folderURL;
@property (nonatomic) NSInteger ruleType;
@property (nonatomic) NSUInteger rulePriority;
@property (nonatomic, strong) NSString *domain;
- (id)initWithFilter:(NSString *)filter folderName:(NSString *)folderName;
- (BOOL)matchesRule:(NRFile *)file;
@end
