//
//  Cps.h
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphicFileTypeBase.h"
#import "Pal.h"

@interface Cps : GraphicFileTypeBase

@property int length;
@property int imageLength;
@property bool palettePresent;
@property Pal *palette;

@end
