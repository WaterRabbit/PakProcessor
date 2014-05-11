//
//  PalTypeViewController.m
//  PAK processor
//
//  Created by id on 10/29/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "PalTypeViewController.h"

@interface PalTypeViewController ()

@end

@implementation PalTypeViewController

- (id)init {
    self = [super initWithNibName:@"PalType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContentFromData:(NSData *)content {
    
    NSBitmapImageRep *bitRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:320 pixelsHigh:320 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
 
    for (int i= 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            int red = 0;
            int green = 0;
            int blue = 0;
            [content getBytes:&red range:NSMakeRange((i*16 +j)*3, 1)];
            [content getBytes:&green range:NSMakeRange((i*16 +j)*3 + 1, 1)];
            [content getBytes:&blue range:NSMakeRange((i*16 +j)*3 + 2, 1)];
            red = ((red & 0x3F) * 0x41) >> 4;
            green = ((green & 0x3F) * 0x41) >> 4;
            blue = ((blue & 0x3F) * 0x41) >> 4;
            NSLog(@"%d %d %d", red, green, blue);
            for (int x = 0; x < 20; x++) {
                for (int y = 0; y < 20; y++) {
                    [bitRep setColor:[NSColor colorWithDeviceRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1] atX:(j*20 + x)  y:(i*20 + y)];
                }
            }
        }
    }
    [_image setImage:[[NSImage alloc] initWithSize:bitRep.size]];
    [[_image image] addRepresentation:bitRep];
}

- (void)setContentFromPalette:(Pal *)palette {

    NSBitmapImageRep *bitRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:320 pixelsHigh:320 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
    
    for (int i= 0; i < 16; i++) {
        for (int j = 0; j < 16; j++) {
            for (int x = 0; x < 20; x++) {
                for (int y = 0; y < 20; y++) {
                    [bitRep setColor:[palette.palette objectAtIndex:(i * 16 +j) ] atX:(j*20 + x)  y:(i*20 + y)];
                }
            }
        }
    }
    [_image setImage:[[NSImage alloc] initWithSize:bitRep.size]];
    [[_image image] addRepresentation:bitRep];
}

@end
