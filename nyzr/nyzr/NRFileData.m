//
//  NRFileData.m
//  nyzr
//
//  Created by Rajiv Thamburaj on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRFileData.h"

@implementation NRFileData

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = filePath;
    }
    
    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer"
                                 userInfo:nil];
    return nil;
}

- (NSString *)domain
{
    NSString *domainKey = @"kMDItemWhereFroms";
    
    // Make sure the file exists
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath: _filePath])
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
    
    if (![manager fileExistsAtPath: _filePath])
        return nil;
    
    NSURL *url = [NSURL URLWithString:_filePath];
    NSString *path = [url path];
    NSString *extension = [path pathExtension];
    
    return extension;
}

- (NSDictionary *)metaData
{
    // Get a metadata item reference
    MDItemRef itemRef = MDItemCreate(kCFAllocatorDefault, (CFStringRef)_filePath);
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
