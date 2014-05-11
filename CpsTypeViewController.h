//
//  CpsTypeViewController.h
//  PAK processor
//
//  Created by id on 10/28/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cps.h"
#import "Pal.h"

@interface CpsTypeViewController : NSViewController

- (void)setContent:(Cps *)content withPalette:(Pal *)palette;

@property (weak) IBOutlet NSTextField *size;
@property (weak) IBOutlet NSTextField *imageSize;
@property (weak) IBOutlet NSButton *palettePresent;
@property (weak) IBOutlet NSImageView *image;
@end
