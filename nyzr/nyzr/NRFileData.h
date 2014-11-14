//
//  NRFileData.h
//  nyzr
//
//  Created by Rajiv Thamburaj on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRFileData : NSObject

@property (nonatomic, strong) NSString *filePath;

- (id)initWithFilePath:(NSString *)filePath;
- (NSString *)domain;
- (NSString *)extension;
- (NSDictionary *)metaData;

@end
