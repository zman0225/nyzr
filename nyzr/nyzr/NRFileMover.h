//
//  NRFileMover.h
//  nyzr
//
//  Created by Rajiv Thamburaj on 11/13/14.
//  Copyright (c) 2014 NYZR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuleMatcher.h"
#import "NRFile.h"

@interface NRFileMover : NSObject


- (void)moveNewFile:(NRFile *)file;

@end
