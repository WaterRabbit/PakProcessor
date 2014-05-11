//
//  Cps.m
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Cps.h"

@implementation Cps

- (void)generateImages {
    int width = 320;
    int height = 200;
    
    self.imageFrames = [[NSMutableArray alloc] init];
    int paletteLength = 0;
    unsigned int isPalette = 0;
    unsigned char destination[width * height];
    unsigned char source[width * height];
    self.length = [FileReaders Get16LEFromData:self.data atOffset:0];
    self.imageLength = [FileReaders Get16LEFromData:self.data atOffset:4];
    isPalette = [FileReaders Get32LEFromData:self.data atOffset:6];
    
    if (isPalette != 0) {
       paletteLength = 256 * 3;
       _palettePresent = true;
       self.palette = [[Pal alloc] initFromData:[self.data subdataWithRange:NSMakeRange(10,paletteLength)]];
    } else {
        _palettePresent = false;
    }
    
    [self.data getBytes:&source range:NSMakeRange(10 + paletteLength ,self.length - 8 - paletteLength)];
    Format80_Decode(destination, source, width * height);
    
    [self.imageFrames addObject:[[ImageFrame alloc] initFromData:[[NSData alloc] initWithBytes:destination length:width * height] withWidth:width withHeight:height]];
    
}

@end
