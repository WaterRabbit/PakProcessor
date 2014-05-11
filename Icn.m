//
//  Icn.m
//  PAK processor
//
//  Created by id on 11/15/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Icn.h"

@implementation Icn

- (void)generateImages {
    int offset = 0;
    NSLog(@"%c%c%c%c", [FileReaders Get8FromData:self.data atOffset:offset], [FileReaders Get8FromData:self.data atOffset:offset + 1], [FileReaders Get8FromData:self.data atOffset:offset + 2], [FileReaders Get8FromData:self.data atOffset:offset + 3]);
    NSLog(@"%u", [FileReaders Get32BEFromData:self.data atOffset:4]);
    offset = 8;
    NSLog(@"%c%c%c%c%c%c%c%c", [FileReaders Get8FromData:self.data atOffset:offset], [FileReaders Get8FromData:self.data atOffset:offset + 1], [FileReaders Get8FromData:self.data atOffset:offset + 2], [FileReaders Get8FromData:self.data atOffset:offset + 3], [FileReaders Get8FromData:self.data atOffset:offset + 4], [FileReaders Get8FromData:self.data atOffset:offset + 5], [FileReaders Get8FromData:self.data atOffset:offset + 6], [FileReaders Get8FromData:self.data atOffset:offset + 7]);
    offset = 16 + 8; //28
    NSLog(@"%c%c%c%c", [FileReaders Get8FromData:self.data atOffset:offset], [FileReaders Get8FromData:self.data atOffset:offset + 1], [FileReaders Get8FromData:self.data atOffset:offset + 2], [FileReaders Get8FromData:self.data atOffset:offset + 3]);
    
    offset = offset + 4;
    
    int ssetLength = [FileReaders Get32BEFromData:self.data atOffset:offset] - 8;
    
    NSLog(@"%u", ssetLength);
    //
    offset = offset + 4;
    //
    NSLog(@"%u", [FileReaders Get16LEFromData:self.data atOffset:offset]);
    NSLog(@"%u", [FileReaders Get16LEFromData:self.data atOffset:offset + 2]);
    
    offset += 4 + 4;
    
    int ssetStart = offset;
    
    offset += ssetLength;
    
    NSLog(@"%c%c%c%c", [FileReaders Get8FromData:self.data atOffset:offset], [FileReaders Get8FromData:self.data atOffset:offset + 1], [FileReaders Get8FromData:self.data atOffset:offset + 2], [FileReaders Get8FromData:self.data atOffset:offset + 3]);
    offset += 4;
    
    int rpalLength = [FileReaders Get32BEFromData:self.data atOffset:offset];
    NSLog(@"%u", rpalLength);
    
    offset += 4;
    
    int rpalStart = offset;
    
    offset += rpalLength;
    
    NSLog(@"%c%c%c%c", [FileReaders Get8FromData:self.data atOffset:offset], [FileReaders Get8FromData:self.data atOffset:offset + 1], [FileReaders Get8FromData:self.data atOffset:offset + 2], [FileReaders Get8FromData:self.data atOffset:offset + 3]);
    offset += 4;
    
    int rtblLength = [FileReaders Get32BEFromData:self.data atOffset:offset];
    NSLog(@"%u", rtblLength);
    
    int rtblStart = offset + 4;
    
    for (int i = 0; i < 399; i++) {
        unsigned char image[16 * 16];
        memset(image, 0, sizeof(image));
        NSLog(@"%d", i);
        unsigned char palette[16];
        int iconRtbl = rtblStart + i;
        int iconRPal = rpalStart + ([FileReaders Get8FromData:self.data atOffset:iconRtbl] << 4);
        for (int paletteIndex = 0; paletteIndex < 16; paletteIndex++) {
            unsigned char colour = [FileReaders Get8FromData:self.data atOffset:iconRPal + paletteIndex];
            palette[paletteIndex] = colour;
        }
        int tileStart = ssetStart + i * ((16 * 16) >> 1);
        
        for (int x = 0; x < 16 * 16; x++) {
            uint8 val = [FileReaders Get8FromData:self.data atOffset:tileStart];
            uint8 left  = val >> 4;
            uint8 right = val & 0xF;
            if (palette[left] != 0)  {
                image[x] = palette[left];
            }
            x++;
           if (palette[right] != 0)  {
                image[x] = palette[right];
            }
            tileStart++;            
        }
        [self.imageFrames addObject:[[ImageFrame alloc] initFromData:[[NSData alloc] initWithBytes:image length:16 * 16] withWidth:16 withHeight:16]];
    }
}

@end
