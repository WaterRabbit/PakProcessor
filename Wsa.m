//
//  Wsa.m
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Wsa.h"

@implementation Wsa

- (void)generateImages {
    [self generateImagesWithFrame:nil];
}

- (void)generateImagesWithFrame:(ImageFrame *)frame {
    unsigned short frames = [FileReaders Get16LEFromData:self.data atOffset:0];
    unsigned short width = [FileReaders Get16LEFromData:self.data atOffset:2];
    unsigned short height = [FileReaders Get16LEFromData:self.data atOffset:4];
    unsigned short requiredBufferSize = [FileReaders Get16LEFromData:self.data atOffset:6];
    unsigned short isSpecial = [FileReaders Get16LEFromData:self.data atOffset:8];
    unsigned int animationOffsetStart = [FileReaders Get32LEFromData:self.data atOffset:10];
    unsigned int animationOffsetEnd = [FileReaders Get32LEFromData:self.data atOffset:14];
    int lengthSpecial = 0;
    unsigned long lengthFileContent = 0;
    int lengthAnimation = 0;
    
    if (isSpecial) {
        lengthSpecial = 0x300;
    }
    
    int offset = 14;
    
    lengthFileContent = [[self data] length];
    lengthAnimation = animationOffsetEnd - animationOffsetStart;
    lengthFileContent -= lengthSpecial + lengthAnimation + 10;
    
    NSLog(@"Frames: %d", frames);
    NSLog(@"Width: %d", width);
    NSLog(@"Height: %d", height);
    NSLog(@"Required buffer size: %d", requiredBufferSize);
    NSLog(@"Is Special: %d", isSpecial);
    NSLog(@"Animation offset start: %d", animationOffsetStart);
    NSLog(@"Animation offset end: %d", animationOffsetEnd);
    
    unsigned char destination[width*height+1000000];
    unsigned char source[width*height+1000000];
    unsigned char dest2[width*height+1000000];
    memset(dest2, 0, sizeof(dest2));
    memset(destination, 0, sizeof(destination));
    memset(source, 0, sizeof(source));
    
    
    while (frames > 0) {
        [self.data getBytes:&source range:NSMakeRange(animationOffsetStart ,animationOffsetEnd - animationOffsetStart)];
        Format80_Decode(destination, source, width*height);
        if (frame != nil) {
            [frame.imageData getBytes:&dest2 length:frame.imageData.length];
 ////            Format40_Decode(dest2, destination);
            frame =nil;
        } else {
            Format40_Decode(dest2, destination);
        }
        [self.imageFrames addObject:[[ImageFrame alloc] initFromData:[[NSData alloc] initWithBytes:dest2 length:width * height] withWidth:width withHeight:height]];
        
        frames--;
        animationOffsetStart = animationOffsetEnd;
        offset = offset + 4;
        [self.data getBytes:&animationOffsetEnd range:NSMakeRange(offset, 4)];
        NSLog(@"Animation offset end: %d", animationOffsetEnd);
    }
}

@end
