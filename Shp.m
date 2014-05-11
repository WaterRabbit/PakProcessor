//
//  Shp.m
//  PAK processor
//
//  Created by id on 11/5/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Shp.h"

@implementation Shp

- (void)generateImages {
    self.imageFrames = [[NSMutableArray alloc] init];

    int position = 0;
    
    unsigned short frames = [FileReaders Get16LEFromData:self.data atOffset:position];

    position = position + 2;
    
    unsigned short offsets[frames + 1];
    unsigned short refOffsets[frames + 1];
    
    for (int i = 0; i <= frames; i++) {
        offsets[i] = [FileReaders Get16LEFromData:self.data atOffset:position];
        position = position + 2;
        refOffsets[i] = [FileReaders Get16LEFromData:self.data atOffset:position];
        position = position + 2;
//        NSLog(@"X %d %d", offsets[i], refOffsets[i]);
    }
    
    for (int i = 0; i < frames; i++) {
        position = offsets[i] + 2;
        unsigned short flag = [FileReaders Get16LEFromData:self.data atOffset:position];
        position = position + 2;
 //       unsigned char slices = [FileReaders Get8FromData:self.data atOffset:position];
        position = position + 1;
        unsigned short width = [FileReaders Get16LEFromData:self.data atOffset:position];
        position = position + 2;
        unsigned char height = [FileReaders Get8FromData:self.data atOffset:position];
        position = position + 1;
//        unsigned short filesize = [FileReaders Get16LEFromData:self.data atOffset:position];
        position = position + 2;
//        unsigned short imagesize = [FileReaders Get16LEFromData:self.data atOffset:position];
      
//        NSLog(@"%d %d %d %d %d %d", flag, slices, width, height, filesize, imagesize);
                
        unsigned char destination[width * height];
        unsigned char source[width * height];
        unsigned char dest2[width * height];
        memset(dest2, 0, sizeof(dest2));
        memset(destination, 0, sizeof(destination));
        memset(source, 0, sizeof(source));
        
        unsigned short  paletteOffset = 0;
        if (flag == 0) {
            [self.data getBytes:&source range:NSMakeRange(offsets[i] + 12 ,offsets[i + 1] - offsets[i] - 10)];
            Format80_Decode(destination, source, width * height);
        } else if (flag == 1) {
            paletteOffset = offsets[i] + 12;
            [self.data getBytes:&source range:NSMakeRange(offsets[i] + 12 + 16 ,offsets[i + 1] - offsets[i] - 10 - 16)];
            Format80_Decode(destination, source, width * height);
        } else if (flag == 3) {
            paletteOffset = offsets[i] + 12;
            [self.data getBytes:&destination range:NSMakeRange(offsets[i] + 12 + 16 ,offsets[i + 1] - offsets[i] - 10 - 16)];
        } else {
            [self.data getBytes:&destination range:NSMakeRange(offsets[i] + 12 ,offsets[i + 1] - offsets[i] - 10)];
        }
        decode2(destination, dest2, width*height);
        if (paletteOffset != 0) {
            for (int z = 0; z < width * height; z++) {
                dest2[z] = [FileReaders Get8FromData:self.data atOffset:paletteOffset + dest2[z]];
//                if (dest2[z] >= 0x90 && dest2[z] <= 0x96) dest2[z] += 2 << 4;
            }
        }
        [self.imageFrames addObject:[[ImageFrame alloc] initFromData:[[NSData alloc] initWithBytes:dest2 length:width * height] withWidth:width withHeight:height]];
    }
}

@end
