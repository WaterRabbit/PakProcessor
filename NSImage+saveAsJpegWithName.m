//
//  NSImage+saveAsJpegWithName.m
//  PAK processor
//
//  Created by id on 30/01/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import "NSImage+saveAsJpegWithName.h"

@implementation NSImage (saveAsJpegWithName)

- (void) saveAsJpegWithName:(NSString*) fileName
{
    // Cache the reduced image
    NSData *imageData = [self TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    [imageData writeToFile:fileName atomically:NO];
}

@end
