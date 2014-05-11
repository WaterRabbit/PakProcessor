//
//  Map.m
//  PAK processor
//
//  Created by id on 11/16/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Map.h"
#import "FileReaders.h"

@implementation Map

- (id)initFromData:(NSData *)data {
    self = [super initFromData:data];
    if (self) {
        int offset = 0;
        unsigned int numTileSets = [FileReaders Get16LEFromData:data atOffset:offset];
        offset += 2;
        _tileSet = [[NSMutableArray alloc] initWithCapacity:numTileSets];
        for (unsigned long i = 0, pre = numTileSets, cur = 0; i < numTileSets; i++, pre = cur) {
            unsigned long off = [FileReaders Get16LEFromData:data atOffset:offset];
            unsigned long size = (cur = (i == numTileSets-1) ? [data length]/2 : off) - pre;
            [_tileSet setObject:[[NSMutableArray alloc] initWithCapacity:size] atIndexedSubscript:i];
            for (int k = 0; k < size; k++) {
                [[_tileSet objectAtIndex:i] addObject:@4];
            }
            NSLog(@"%ld  %ld", off, size);
            offset += 2;
        }
        for (int i= 1; i < numTileSets; i++) {
            for (int j = 0; j < [[_tileSet objectAtIndex:i] count]; j++) {
                [[_tileSet objectAtIndex:i] setObject:[[NSNumber alloc] initWithInt:[FileReaders Get16LEFromData:data atOffset:offset]] atIndexedSubscript:j];
                offset += 2;
            }
        }
    }
    return self;
}

- (int)getStructureWidth:(int)mapIndex {
    if ( mapIndex == 13 || mapIndex == 14 || mapIndex == 21 || mapIndex == 22) {
        return 3;
    } else if (mapIndex == 25 || mapIndex == 26 || (mapIndex >= 15 && mapIndex <= 19) || mapIndex == 12) {
        return 2;
    } else if (mapIndex == 11 || mapIndex == 20) {
        return 3;
    } else {
        return 1;
    }
}

- (int)getStructureHeight:(int)mapIndex {
    if ( mapIndex == 13 || mapIndex == 14 || mapIndex == 21 || mapIndex == 22) {
        return 2;
    } else if (mapIndex == 25 || mapIndex == 26 || (mapIndex >= 15 && mapIndex <= 19) || mapIndex == 12) {
        return 2;
    } else if (mapIndex == 11 || mapIndex == 20) {
        return 3;
    } else {
        return 1;
    }
}

@end
