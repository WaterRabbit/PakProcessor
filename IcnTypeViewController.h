//
//  IcnTypeViewController.h
//  PAK processor
//
//  Created by id on 11/15/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HouseTypeViewController.h"
#import "Map.h"

@interface IcnTypeViewController : HouseTypeViewController

@property Map* mapData;

- (void)setContent:(GraphicFileTypeBase *)content withPalette:(Pal *)palette withMap:(Map *)map;

@end
