//
//  Tools.h
//  PAK processor
//
//  Created by id on 11/12/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pal.h"
#import "ImageFrame.h"

@interface Tools : NSObject

+ (BOOL)isCPS:(NSString *)file;

+ (BOOL)isSHP:(NSString *)file;

+ (BOOL)isTxt:(NSString *)file;

+ (NSImage *)generateImageFromFrame:(ImageFrame *)frame withPalette:(Pal *)palette;

@end
