//
//  NRRule.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/14/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRRule.h"

@implementation NRRule


- (id)initWithFilter:(NSString *)filter folderName:(NSString *)folderName {
    if (self = [super init]) {
        self.filter = filter;
        NSURL *temp = [NSURL URLWithString:filter];
        if (![temp isFileURL]) {
            self.rulePriority = 1;
            self.ruleType = NRTLD;
        }
        else {
            self.rulePriority = 0;
            self.ruleType = NRFileExtension;
        }
        
        BOOL isValid = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:folderName isDirectory:&isValid]) {
            self.folderURL = [NSURL URLWithString:folderName];
        }
        else {
            self.folderURL = [[NRConstants rootDirectoryURL] URLByAppendingPathComponent:folderName];
        }
    }
    NSLog(@"initialized filter:%@-%@-%lu-%lu", self.filter, self.folderURL, self.rulePriority, self.ruleType);
    return self;
}

- (BOOL)matchesRule:(NRFile *)file {
    if ([file.extension isEqualToString:self.filter]) {
        return YES;
    }
    
    NSString *domain = [file domain];
    
    NSLog(@"%@ vs %@", domain, self.filter);
    if ([domain isEqualToString:self.filter]) {
        NSLog(@"asdfghjkl");
    }
    if (domain && self.ruleType == NRTLD && [domain isEqualToString:[self.filter stringByReplacingOccurrencesOfString:@"http://" withString:@""]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - NSCODING
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.filter = [decoder decodeObjectForKey:@"filter"];
    self.folderURL = [decoder decodeObjectForKey:@"folderURL"];
    self.rulePriority = [decoder decodeIntegerForKey:@"rulePriority"];
    self.ruleType = [decoder decodeIntegerForKey:@"type"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.filter forKey:@"filter"];
    [encoder encodeObject:self.folderURL forKey:@"folderURL"];
    [encoder encodeInteger:self.rulePriority forKey:@"rulePriority"];
    [encoder encodeInteger:self.ruleType forKey:@"type"];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[NRRule alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setFilter:[self.filter copyWithZone:zone]];
        [copy setFolderURL:[self.folderURL copyWithZone:zone]];
        // Set primitives
        [copy setRulePriority:self.rulePriority];
        [copy setRuleType:self.ruleType];
    }
    
    return copy;
}

- (NSUInteger)hash {
    return [self.filter hash];
}

@end
