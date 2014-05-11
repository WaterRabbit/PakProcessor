//
//  Tools.m
//  PAK processor
//
//  Created by id on 11/12/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Tools.h"
#import "Pal.h"
#import "ImageFrame.h"

@implementation Tools

+ (BOOL)isCPS:(NSString *)file {
    return ([[file pathExtension] isEqual:@"CPS"] || [file  hasPrefix:@"HERALD."] || [file  hasPrefix:@"MISC."] || [file  hasPrefix:@"TITLE."]);
}

+ (BOOL)isSHP:(NSString *)file {
    return ([[file pathExtension] isEqual:@"SHP"] || [file  hasPrefix:@"MENTAT."] || [file  hasPrefix:@"CHOAM."] || [file  hasPrefix:@"BTTN."]);
}

+ (BOOL)isTxt:(NSString *)file {
    return ([file  hasPrefix:@"DUNE."] || [file  hasPrefix:@"MESSAGE."] || [file  hasPrefix:@"INTRO."] ||
            [file  hasPrefix:@"TEXTH."] || [file  hasPrefix:@"PROTECT."] || [file  hasPrefix:@"TEXTA."] || [file  hasPrefix:@"TEXTO."]) && (
    [file hasSuffix:@"ENG"] || [file hasSuffix:@"GER"] ||[file hasSuffix:@"FRE"]);
}

+ (NSImage *)generateImageFromFrame:(ImageFrame *)frame withPalette:(Pal *)palette {
    NSBitmapImageRep *bitRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:frame.width pixelsHigh:frame.height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:32];
    
    unsigned char imageContent[frame.width * frame.height];
    [frame.imageData getBytes:&imageContent length:frame.imageData.length];
    for (int x = 0; x < frame.width; x++) {
        for (int y = 0; y < frame.height; y++) {
            [bitRep setColor:[palette.palette objectAtIndex:imageContent[y * frame.width + x]] atX:x y:y];
        }
    }
    
    NSImage *image = [[NSImage alloc] initWithSize:bitRep.size];
    [image addRepresentation:bitRep];
    return image;
}

@end
