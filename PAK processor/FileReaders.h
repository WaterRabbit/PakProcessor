//
//  FileReaders.h
//  PAK processor
//
//  Created by id on 11/16/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileReaders : NSObject

+ (unsigned char)Get8FromData:(NSData *)data atOffset:(int)offset;

+ (unsigned short)Get16LEFromData:(NSData *)data atOffset:(int)offset;

+ (unsigned short)Get16BEFromData:(NSData *)data atOffset:(int)offset;

+ (unsigned int)Get32LEFromData:(NSData *)data atOffset:(int)offset;

+ (unsigned int)Get32BEFromData:(NSData *)data atOffset:(int)offset;


@end
