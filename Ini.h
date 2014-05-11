//
//  Ini.h
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileTypeBase.h"

@interface Ini : FileTypeBase

@property NSString *text;
@property NSArray *lines;

- (int)getLineCount;
- (NSString *)getLine:(int)lineNumber;
- (BOOL)isCommentLine:(int)lineNumber;
- (BOOL)isCategaroyLine:(int)lineNumber;
- (BOOL)isValueLine:(int)lineNumber;
- (NSDictionary *)getKeyValue:(NSString *)line;
- (NSArray *)getStringArrayAsNumericArray:(NSArray *)array;
- (NSArray *)getStringAsNumericArray:(NSString *)line;

@end
