//
//  Pal.m
//  PAK processor
//
//  Created by id on 10/31/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Pal.h"

@implementation Pal

- (id)initFromData:(NSData *)data {
    self = [super initFromData:data];
    if (self) {
        if ([data length] != 256 * 3) {
            NSLog(@"Palette length is invalid: It is %ld but should be %d", (unsigned long)[data length], 253 * 3);
        }
        _palette = [[NSMutableArray alloc] init];
        for (int i= 0; i < 256; i++) {
            int red = 0;
            int green = 0;
            int blue = 0;
            [data getBytes:&red range:NSMakeRange(i * 3, 1)];
            [data getBytes:&green range:NSMakeRange(i * 3 + 1, 1)];
            [data getBytes:&blue range:NSMakeRange((i * 3) + 2, 1)];
            red = ((red & 0x3F) * 0x41) >> 4;
            green = ((green & 0x3F) * 0x41) >> 4;
            blue = ((blue & 0x3F) * 0x41) >> 4;
            [_palette addObject:[NSColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1]];
        }
    }
    return self;
}

@end
