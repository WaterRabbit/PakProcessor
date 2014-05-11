//
//  CpsTypeViewController.m
//  PAK processor
//
//  Created by id on 10/28/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "CpsTypeViewController.h"

@interface CpsTypeViewController ()

@end

@implementation CpsTypeViewController

- (id)init {
    self = [super initWithNibName:@"CpsType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
    }    
    return self;
}

- (void)setContent:(Cps *)content withPalette:(Pal *)palette {

    [_size setIntValue:content.length];
    [_imageSize setIntValue:content.imageLength];
    if (content.palettePresent) {
        [_palettePresent setState:NSOnState];
    } else {
        [_palettePresent setState:NSOffState];
        content.palette = palette;
    }
    
    ImageFrame *frame = [content.imageFrames objectAtIndex:0];
    
    
    NSBitmapImageRep *bitRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:frame.width pixelsHigh:frame.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
   
    unsigned char imageContent[frame.width * frame.height];
    [frame.imageData getBytes:&imageContent length:frame.imageData.length];
    for (int x = 0; x < frame.width; x++) {
        for (int y = 0; y < frame.height; y++) {
            [bitRep setColor:[content.palette.palette objectAtIndex:imageContent[y * frame.width + x]] atX:x y:y];
        }
    }
    
    [_image setImage:[[NSImage alloc] initWithSize:bitRep.size]];
    [[_image image] addRepresentation:bitRep];
}


@end
