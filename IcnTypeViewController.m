//
//  IcnTypeViewController.m
//  PAK processor
//
//  Created by id on 11/15/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "IcnTypeViewController.h"

@implementation IcnTypeViewController

- (void)setContent:(GraphicFileTypeBase *)content withPalette:(Pal *)palette withMap:(Map *)map {
    _mapData = map;
    [super setContent:content withPalette:palette];
}

- (void)generateItems {
    [self.imagesData removeAllObjects];
    
    int pixelSize = 20;
    
    int i = 0;
    int j = 1;
    for (NSMutableArray *array in _mapData.tileSet) {
        if (i == 0) {
            i++;
            continue;
        };
        if ( i == 13 || i == 14 || i == 21 || i == 22 | i == 25 || i == 26 || (i >= 15 && i <= 19) || i == 12 || i == 11 || i == 20) {
            int z = 0;
            ImageFrame *frame = [self.grphData.imageFrames objectAtIndex:[[array objectAtIndex:z] intValue]];
            while (z < array.count) {
                int tileWidth =  [_mapData getStructureWidth:i];
                int tileHeight =  [_mapData getStructureHeight:i];
                int tileNum  = tileWidth * tileHeight;
                
                NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize * tileWidth, frame.height * pixelSize * tileHeight)];
                [image lockFocus];

                for (int k = 0; k < tileNum; k++) {
                    frame = [self.grphData.imageFrames objectAtIndex:[[array objectAtIndex:z] intValue]];
                    unsigned char imageContent[frame.width * frame.height];
                    [frame.imageData getBytes:&imageContent length:frame.imageData.length];
                    
                    for (int z = 0; z < frame.width * frame.height; z++) {
                        if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
                    }
                    
                    for (int x = 0; x < frame.width; x++) {
                        for (int y = 0; y < frame.height; y++) {
                            [(NSColor *)[self.palData.palette objectAtIndex:imageContent[y * frame.width + x]] set];
                            if (tileNum == 6) {
                                NSRectFill(NSMakeRect(x * pixelSize  + (frame.width*pixelSize * (k%3)), (frame.height * (k<3?2:1) - y - 1) * pixelSize, pixelSize, pixelSize));
                            } else if (tileNum == 4) {
                                NSRectFill(NSMakeRect(x * pixelSize  + (frame.width*pixelSize * (k%2)), (frame.height * (k<2?2:1) - y - 1) * pixelSize, pixelSize, pixelSize));
                            } else if (tileNum == 9) {
                                NSRectFill(NSMakeRect(x * pixelSize  + (frame.width*pixelSize * (k%3)), (frame.height * (k<3?3:(k<6?2:1)) - y - 1) * pixelSize, pixelSize, pixelSize));
                            }
                        }
                    }
                    z++;
                }
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:image, @"image", [[NSString alloc] initWithFormat:@"%d-%d|%@", i,j - 1,@1], @"index", nil];
                
                [self.imagesData addObject:dict];
                j++;
                
                [image unlockFocus];
            }
        } else {
            for (NSNumber *num in array) {
                ImageFrame *frame = [self.grphData.imageFrames objectAtIndex:[num intValue]];
                
                unsigned char imageContent[frame.width * frame.height];
                [frame.imageData getBytes:&imageContent length:frame.imageData.length];
                for (int z = 0; z < frame.width * frame.height; z++) {
                    if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
                    if (i == 7) {
                        imageContent[z] += 10;
                    }
                }
                
                NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height * pixelSize)];
                [image lockFocus];
                for (int x = 0; x < frame.width; x++) {
                    for (int y = 0; y < frame.height; y++) {
                        [(NSColor *)[self.palData.palette objectAtIndex:imageContent[y * frame.width + x ]] set];
                        NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
                    }
                }
                [image unlockFocus];
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:image, @"image", [[NSString alloc] initWithFormat:@"%d-%d|%@", i,j, num], @"index", nil];
                
                [self.imagesData addObject:dict];
                j++;
            }
        }
        j = 1;
        i++;
    }
//    for (int i = 0; i < [self.grphData.imageFrames count]; i++) {
//        ImageFrame *frame = [self.grphData.imageFrames objectAtIndex:i];
//        
//        unsigned char imageContent[frame.width * frame.height];
//        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
//        for (int z = 0; z < frame.width * frame.height; z++) {
//            if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
//        }
//        
//        NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height * pixelSize)];
//        [image lockFocus];
//        for (int x = 0; x < frame.width; x++) {
//            for (int y = 0; y < frame.height; y++) {
//                [(NSColor *)[self.palData.palette objectAtIndex:imageContent[y * frame.width + x ]] set];
//                NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
//            }
//        }
//        [image unlockFocus];
//        
//        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:image, @"image", [[NSNumber alloc] initWithInt:(i + 1)] , @"index", nil];
//        
//        [self.imagesData addObject:dict];
//    }
    [self.coll setContent:self.imagesData];
}

@end
