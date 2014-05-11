//
//  ImageFrame.m
//  PAK processor
//
//  Created by id on 11/21/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "ImageFrame.h"

@implementation ImageFrame

- (id)init {
    NSException *initExeption = [[NSException alloc] initWithName:@"Can not init" reason:@"Use initFromData instead" userInfo:nil];
    [initExeption raise];
    return nil;
}

- (id)initFromData:(NSData *)data withWidth:(int)width withHeight:(int)height {
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        _imageData = [[NSData alloc] initWithData:data];
    }
    return self;
}

@end
