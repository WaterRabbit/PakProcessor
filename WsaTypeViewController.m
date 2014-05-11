//
//  WsaTypeViewController.m
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "WsaTypeViewController.h"
#import "format80.h"
#import "format40.h"


@implementation WsaTypeViewController

- (id)init {
    self = [super initWithNibName:@"WsaType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        _images = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setContent:(Wsa *)content withPalette:(Pal *)palette {
    
//    int pixelSize = 1;
    
    for (int i = 0; i < [content.imageFrames count]; i++) {
        ImageFrame *frame = [content.imageFrames objectAtIndex:i];
        
        unsigned char imageContent[frame.width * frame.height];
        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
        
//        NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height * pixelSize)];
//        [image lockFocus];
//        for (int x = 0; x < frame.width; x++) {
//            for (int y = 0; y < frame.height; y++) {
//                [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x ]] set];
//                NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
//            }
//        }
//        [image unlockFocus];
               NSBitmapImageRep *bitRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:frame.width pixelsHigh:frame.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
                for (int x = 0; x < frame.width; x++) {
                    for (int y = 0; y < frame.height; y++) {
                        [bitRep setColor:[palette.palette objectAtIndex:imageContent[y*frame.width + x]] atX:x y:y];
                    }
                }
                NSImage * image = [[NSImage alloc] initWithSize:bitRep.size];
                [image addRepresentation:bitRep];

        [_images addObject:image];
    }
    [_coll setContent:_images];
}

@end
