//
//  Ini.m
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Ini.h"

@implementation Ini

- (id)initFromData:(NSData *)data {
    self = [super initFromData:data];
    if (self) {
        _text = [[NSString alloc]  initWithData:data encoding:NSASCIIStringEncoding];
    }
    return self;
}

- (int)getLineCount {
    if (_lines == nil) {
        _lines = [self getLines];
    }
    return (int)_lines.count;
};

- (NSString *)getLine:(int)lineNumber {
    if (_lines == nil) {
        _lines = [self getLines];
    }
    return _lines[lineNumber - 1];
};

- (NSArray *)getLines {
    unsigned long length = [_text length];
    unsigned long paraStart = 0, paraEnd = 0, contentsEnd = 0;
    NSMutableArray *array = [NSMutableArray array];
    NSRange currentRange;
    while (paraEnd < length)
    {
        [_text getParagraphStart:&paraStart end:&paraEnd
                     contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
        currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
        [array addObject:[_text substringWithRange:currentRange]];
    }
    return array;
}

- (BOOL)isCommentLine:(int)lineNumber {
    NSString *line = _lines[lineNumber - 1];
    if ([line hasPrefix:@"["])return false;
    if ([line rangeOfString:@"="].location != NSNotFound) return false;
    return true;
}


- (BOOL)isCategaroyLine:(int)lineNumber {
    NSString *line = _lines[lineNumber - 1];
    if ([line hasPrefix:@"["])return true;
    return false;
}

- (BOOL)isValueLine:(int)lineNumber {
    NSString *line = _lines[lineNumber - 1];
    if ([line rangeOfString:@"="].location != NSNotFound) return true;
    return false;
}

- (NSDictionary *)getKeyValue:(NSString *)line {
    NSArray *lineItems = [line componentsSeparatedByString:@"="];
    NSString *name = [lineItems[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *value = [lineItems[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [[NSDictionary alloc] initWithObjectsAndKeys:name, @"key", value, @"value", nil];
}

- (NSArray *)getStringArrayAsNumericArray:(NSArray *)array {
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (NSString *item in array) {
        [newArray addObject:[[NSNumber alloc] initWithInt:[item intValue]]];
    }
    return newArray;
}

- (NSArray *)getStringAsNumericArray:(NSString *)line {
    NSArray *array = [line componentsSeparatedByString:@","];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (NSString *item in array) {
        [newArray addObject:[[NSNumber alloc] initWithInt:[item intValue]]];
    }
    return newArray;
}

@end
