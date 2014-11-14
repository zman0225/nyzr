//
//  NRDirectory.m
//  nyzr
//
//  Created by Ziyuan Liu on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import "NRDirectory.h"
#import "NRFile.h"

@interface NRDirectory ()

@property (nonatomic, strong) NSString *directory;
@property (nonatomic, strong) NSSet *currentFileList;
@property (nonatomic, strong) NSSet *currentFileNames;
@end

@implementation NRDirectory

- (id)initWithDirectory:(NSString *)dir {
    if (self = [super init]) {
        self.directory = dir;
        self.currentFileNames = [self validFileNames:self.directory];
        self.currentFileList = [self getNewFileList:self.currentFileNames];
    }
    
    return self;
}

- (BOOL)isFileValid:(NSString *)filename path:(NSString *)currentPath {
    BOOL isValid = NO;
    NSURL *fileUrl = [NSURL URLWithString:[currentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    NSLog(@"extension is %@ %@ %@" ,[[fileUrl pathExtension] lowercaseString],fileUrl,currentPath);
    return [filename characterAtIndex:0] != '.' && [filename characterAtIndex:0] != '$' && [[NSFileManager defaultManager] fileExistsAtPath:currentPath isDirectory:&isValid] && !isValid && [[[fileUrl pathExtension] lowercaseString] isNotEqualTo:@"tmp"] && [[[fileUrl pathExtension] lowercaseString] isNotEqualTo:@"crdownload"] && [[[fileUrl pathExtension] lowercaseString] isNotEqualTo:@"download"];
}

- (NSSet *)validFileNames:(NSString *)dir {
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
    NSMutableSet *tempSet = [NSMutableSet new];
    for (NSString *filename in contents) {
        NSString *currentPath = [[[NSURL URLWithString:dir] URLByAppendingPathComponent:filename] path];
        
        BOOL isValid = [self isFileValid:filename path:currentPath];
        if (isValid) {
            [tempSet addObject:currentPath];
        }
    }
    return [tempSet copy];
}

- (NSSet *)newFiles:(NSSet *)old and:(NSSet *)new {
    NSMutableSet *temp = [new mutableCopy];
    [temp minusSet:old];
    return [temp copy];
}

- (NSSet *)getNewFileList:(NSSet *)fileNames {
    NSError *error;
    NSMutableSet *tempSet = [NSMutableSet new];
    
    for (NSString *filename in fileNames) {
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:self.directory error:&error];
        NRFile *file = [[NRFile alloc] initWithName:filename withType:fileInfo.fileType withPath:filename withCreationDate:fileInfo.fileCreationDate andWithModificationDate:fileInfo.fileModificationDate];
        [tempSet addObject:file];
    }
    return [tempSet copy];
}

- (void)directoryChanged {
    NSSet *newFileNames = [self validFileNames:self.directory];
    NSSet *newFileList = [NSSet new];
    
    if (self.currentFileNames.count != newFileNames.count) {
        NSMutableSet *temp = [newFileNames mutableCopy];
        [temp minusSet:self.currentFileNames];
        newFileList = [self getNewFileList:temp];
    }
    
    self.currentFileNames = [newFileNames copy];
    
    if (newFileList.count > 0) {
        NSSet *newFiles = [self newFiles:self.currentFileList and:newFileList];
        if (newFiles.count > 0) {
            NRFile *newFile = ((NRFile *)[newFiles allObjects][0]);
            NSLog(@"new files %@", newFile.name);
            //            [newFile deleteFile];
            self.currentFileList = [self getNewFileList:self.currentFileNames];
        }
    }
}

@end
