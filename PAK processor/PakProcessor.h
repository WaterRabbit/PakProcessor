//
//  PakProcessor.h
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PakProcessor : NSObject

@property NSArray *pakFiles;
@property NSMutableDictionary *filesInPakFiles;
@property NSMutableDictionary *fileContents;

- (id)initWithFiles:(NSArray *) fileNames;

- (void)processFiles;
//- (NSData *)processFileContent:(NSString *)file atOffset:(unsigned long long)offset withLength:(unsigned long)length;

@end
