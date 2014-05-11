//
//  Map.h
//  PAK processor
//
//  Created by id on 11/16/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "FileTypeBase.h"

@interface Map : FileTypeBase

@property NSMutableArray *tileSet;

- (int)getStructureWidth:(int)mapIndex;
- (int)getStructureHeight:(int)mapIndex;

@end
