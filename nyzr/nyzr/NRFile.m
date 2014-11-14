//
//  NRFile.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRFile.h"
#import "FileHash.h"

@interface NRFile () {
    NSString *_hash;
}

@end

@implementation NRFile

+ (id)fileWithFilePath:(NSString *)filepath {
    NSString *filename_trunc = [filepath lastPathComponent];
    NSError *error;
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:&error];
    NRFile *file = [[NRFile alloc] initWithName:filename_trunc withType:fileInfo.fileType withPath:filepath withCreationDate:fileInfo.fileCreationDate andWithModificationDate:fileInfo.fileModificationDate];
    return file;
}

- (id)initWithName:(NSString *)name withType:(NSString *)type withPath:(NSString *)path withCreationDate:(NSDate *)creationDate andWithModificationDate:(NSDate *)modDate {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
        self.path = path;
        self.creationDate = creationDate;
        self.modificationDate = modDate;
    }
    
    _hash = [FileHash md5HashOfFileAtPath:self.path];
    return self;
}

- (NSUInteger)hash {
    return [_hash hash];
}

- (NSString *)domain {
    NSString *domainKey = @"kMDItemWhereFroms";
    
    // Make sure the file exists
    //    NSFileManager *manager = [NSFileManager defaultManager];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        return nil;
    }
    
    // Get the metadata and make sure it contains the "where from" key
    NSDictionary *metaData = [self metaData];
    if (![metaData objectForKey:domainKey])
        return nil;
    
    NSArray *domains = [metaData valueForKey:domainKey];
    NSURL *url;
    
    // Get the URL from which the file was downloaded, if it's available
    if ([domains count] > 1) {
        if ([[domains objectAtIndex:1] length] > 2)
            url = [NSURL URLWithString:[domains objectAtIndex:1]];
        else
            url = [NSURL URLWithString:[domains objectAtIndex:0]];
    }
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

- (NSString *)extension {
    NSURL *url = [NSURL fileURLWithPath:_path];
    NSLog(@"full path %@", _path);
    NSLog(@"extension %@", [url pathExtension]);
    
    return [url pathExtension];
}

- (NSDictionary *)metaData {
    // Get a metadata item reference
    MDItemRef itemRef = MDItemCreate(kCFAllocatorDefault, (CFStringRef)_path);
    if (itemRef == nil)
        return nil;
    
    // Extract a metadata dictionary from the item reference
    CFArrayRef list = MDItemCopyAttributeNames(itemRef);
    NSDictionary *metaData = (NSDictionary *)CFBridgingRelease(MDItemCopyAttributes(itemRef, list));
    
    CFRelease(list);
    CFRelease(itemRef);
    
    return metaData;
}

- (void)deleteFile {
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:self.path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.path error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Removed %@", self.path);
        }
    }
}

@end
