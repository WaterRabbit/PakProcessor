//
//  PalTypeViewController.h
//  PAK processor
//
//  Created by id on 10/29/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Pal.h"

@interface PalTypeViewController : NSViewController

- (void)setContentFromData:(NSData *)content;
- (void)setContentFromPalette:(Pal *)palette;

@property (weak) IBOutlet NSImageView *image;

@end
