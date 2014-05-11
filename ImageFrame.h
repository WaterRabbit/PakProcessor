//
//  ImageFrame.h
//  PAK processor
//
//  Created by id on 11/21/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFrame : NSObject

@property int width;
@property int height;

@property NSData* imageData;

- (id)initFromData:(NSData *)data withWidth:(int)width withHeight:(int)height;

@end
