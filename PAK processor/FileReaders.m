//
//  FileReaders.m
//  PAK processor
//
//  Created by id on 11/16/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "FileReaders.h"

@implementation FileReaders

+ (unsigned char)Get8FromData:(NSData *)data atOffset:(int)offset {
    unsigned char result = 0;
    [data getBytes:&result range:NSMakeRange(offset, 1)];
    return result;
}

+ (unsigned short)Get16LEFromData:(NSData *)data atOffset:(int)offset {
    unsigned short result = 0;
    [data getBytes:&result range:NSMakeRange(offset, 2)];
    return result;
}

+ (unsigned short)Get16BEFromData:(NSData *)data atOffset:(int)offset {
    unsigned short result = 0;
    [data getBytes:&result range:NSMakeRange(offset, 2)];
    result = CFSwapInt16(result);
    return result;
}

+ (unsigned int)Get32LEFromData:(NSData *)data atOffset:(int)offset {
    unsigned int result = 0;
    [data getBytes:&result range:NSMakeRange(offset, 4)];
    return result;
}

+ (unsigned int)Get32BEFromData:(NSData *)data atOffset:(int)offset {
    unsigned int result = 0;
    [data getBytes:&result range:NSMakeRange(offset, 4)];
    result = CFSwapInt32(result);
    return result;
}

@end
