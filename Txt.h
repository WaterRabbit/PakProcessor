//
//  Txt.h
//  PAK processor
//
//  Created by id on 03/03/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import "FileTypeBase.h"

@interface Txt : FileTypeBase

- (id)initFromData:(NSData *)data compressed:(BOOL)compressed fromKey:(NSInteger)fromKey toKey:(NSInteger)toKey;

@property NSMutableArray *strings;
@property long fromKey;
@property long toKey;
@property BOOL compresed;

@end
