//
//  HouseTypeViewController.m
//  PAK processor
//
//  Created by id on 11/24/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "HouseTypeViewController.h"

@interface HouseTypeViewController ()

@end

@implementation HouseTypeViewController

- (id)init {
    self = [super initWithNibName:@"ShpType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        _imagesData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setContent:(GraphicFileTypeBase *)content withPalette:(Pal *)palette {
    _housesCombo.delegate = self;
    _palData = palette;
    _grphData = content;
    self.houses = content.houses;
    [self.housesCombo selectItemAtIndex:content.houseID];
    [self willChangeValueForKey:@"canSelectHouses"];
    _canSelectHouses = content.canSelectHouse;
    [self didChangeValueForKey:@"canSelectHouses"];
    [self generateItems];
}

- (void)generateItems {
    [_imagesData removeAllObjects];
    
    int pixelSize = 20;
    
    for (int i = 0; i < [_grphData.imageFrames count]; i++) {
        ImageFrame *frame = [_grphData.imageFrames objectAtIndex:i];
        
        unsigned char imageContent[frame.width * frame.height];
        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
        for (int z = 0; z < frame.width * frame.height; z++) {
            if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += _grphData.houseID << 4;
        }
        
        NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height * pixelSize)];
        [image lockFocus];
        for (int x = 0; x < frame.width; x++) {
            for (int y = 0; y < frame.height; y++) {
                NSColor *color = [_palData.palette objectAtIndex:imageContent[y * frame.width + x ]];
                if (imageContent[y * frame.width + x ] == 0) {
                   color = [color colorWithAlphaComponent:0.0];
                }
                [color set];
                 NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
            }
        }
        [image unlockFocus];
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:image, @"image", [[NSNumber alloc] initWithInt:(i + 1)] , @"index", nil];
        
        [_imagesData addObject:dict];
    }
    [_coll setContent:_imagesData];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    _grphData.houseID = _housesCombo.indexOfSelectedItem;
    [self generateItems];
}

@end
