//
//  FileTypeBase.m
//  PAK processor
//
//  Created by id on 11/13/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "FileTypeBase.h"

@implementation FileTypeBase

- (id)init {
    NSException *initExeption = [[NSException alloc] initWithName:@"Can not init" reason:@"Use initFromData instead" userInfo:nil];
    [initExeption raise];
    return nil;
}

- (id)initFromData:(NSData *)data {
    self = [super init];
    if (self) {
        _data = [[NSData alloc] initWithData:data];
    }
    return self;
}

@end
