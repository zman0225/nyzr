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

- (NSString *)domain
{
    NSString *domainKey = @"kMDItemWhereFroms";
    
    // Make sure the file exists
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath: self.path])
        return nil;
    
    // Get the metadata and make sure it contains the "where from" key
    NSDictionary *metaData = [self metaData];
    
    if (![metaData objectForKey:domainKey])
        return nil;
    
    NSArray *domains = [metaData valueForKey:domainKey];
    NSURL *url;
    
    // Get the URL from which the file was downloaded, if it's available
    if ([[domains objectAtIndex:1] length] > 2)
        url = [NSURL URLWithString:[domains objectAtIndex:1]];
    
    // If it's not available, get the URL of the actual file
    else
        url = [NSURL URLWithString:[domains objectAtIndex:0]];
    
    // Get the host from the URL (remove scheme/port/etc.)
    NSString *host = [url host];
    
    //Remove "www." (if it's at the beginning of the domain)
    NSString *prefix = [host substringToIndex:4];
    NSString *domain;
    
    if ([prefix isEqualToString:@"www."])
        domain = [host substringFromIndex:4];
    else
        domain = host;
    
    return domain;
}

- (NSString *)extension
{
    // Make sure the file exists
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath: self.path])
        return nil;
    
    NSURL *url = [NSURL URLWithString:self.path];
    NSString *path = [url path];
    NSString *extension = [path pathExtension];
    
    return extension;
}

- (NSDictionary *)metaData
{
    // Get a metadata item reference
    MDItemRef itemRef = MDItemCreate(kCFAllocatorDefault, (CFStringRef)self.path);
    if (itemRef == nil)
        return nil;
    
    // Extract a metadata dictionary from the item reference
    CFArrayRef list = MDItemCopyAttributeNames(itemRef);
    NSDictionary *metaData = (NSDictionary *)CFBridgingRelease(MDItemCopyAttributes(itemRef, list));
    
    CFRelease(list);
    CFRelease(itemRef);
    
    return metaData;
}

@end
