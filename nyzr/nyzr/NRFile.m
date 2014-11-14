//
//  NRFile.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRFile.h"
#import "FileHash.h"


@implementation NRFile

- (id)initWithName:(NSString *)name withType:(NSString *)type withPath:(NSString *)path withCreationDate:(NSDate *)creationDate andWithModificationDate:(NSDate *)modDate {
	if (self = [super init]) {
		self.name = name;
		self.type = type;
		self.path = path;
		self.creationDate = creationDate;
		self.modificationDate = modDate;
	}
    
	_hash = [FileHash md5HashOfFileAtPath:self.path];
    NSLog(@"hash is %@",_hash);
	return self;
}

- (NSString *)hash {
	return _hash;
}

@end
