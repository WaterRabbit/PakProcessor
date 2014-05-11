//
//  IniSceneTypeViewController.h
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IniScene.h"
#import "Pal.h"
#import "Icn.h"
#import "Map.h"

@interface IniSceneTypeViewController : NSViewController

@property (weak) IBOutlet NSTextField *losePictureLabel;
@property (weak) IBOutlet NSTextField *winPictureLabel;
@property (weak) IBOutlet NSTextField *briefPictureLabel;

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSImageView *image;

- (void)setContent:(IniScene *)content withSprites:(Icn *)sprites withPalette:(Pal *)palette  withMap:(Map *)map;

@end
