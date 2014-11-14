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

- (NSSet *)validFileNames:(NSString *)dir {
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:&error];
    NSMutableSet *tempSet = [NSMutableSet new];
    for (NSString *filename in contents) {
        NSString *currentPath = [[[NSURL URLWithString:dir] URLByAppendingPathComponent:filename] path];
        
        BOOL isValid = NO;
        
        isValid = [filename characterAtIndex:0] != '.' && [filename characterAtIndex:0] != '$' && [[NSFileManager defaultManager] fileExistsAtPath:currentPath isDirectory:&isValid] && !isValid;
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
//        NSString *currentPath = [[[NSURL URLWithString:self.directory] URLByAppendingPathComponent:filename] path];
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:self.directory error:&error];
        NRFile *file = [[NRFile alloc] initWithName:filename withType:fileInfo.fileType withPath:filename withCreationDate:fileInfo.fileCreationDate andWithModificationDate:fileInfo.fileModificationDate];
//        NSLog(@"asdsa %@",filename);
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
            NSError *error;
            //            NRFile *toDelete = [newFiles allObjects][0];
            //            [[NSFileManager defaultManager] removeItemAtPath:toDelete.path error:&error];
            self.currentFileList = [self getNewFileList:self.currentFileNames];
        }
    }
}

@end