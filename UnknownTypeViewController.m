//
//  UnknownTypeViewController.m
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "UnknownTypeViewController.h"

@interface UnknownTypeViewController ()

@end

@implementation UnknownTypeViewController

- (id)init {
    self = [super initWithNibName:@"UnknownType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContent:(NSData *)content {
    [_legnth setIntValue:(int)[content length]];
    
    NSMutableString *strValue = [[NSMutableString alloc] init];
    NSMutableString *strLineValue = [[NSMutableString alloc] init];
    NSTextStorage *ts = [_textView textStorage];
    for (int i = 0; i < content.length; i++) {
        int value = 0;
        [content getBytes:&value range:NSMakeRange(i, 1)];
        [strValue appendString:[[[NSString alloc] initWithFormat: @"%02x", value] uppercaseString]];
        if (value >= 32) {
            [strLineValue appendString:[[NSString alloc] initWithFormat: @"%c", value]];
        } else {
            [strLineValue appendString:@"."];
        }
        if (i > 0 && (( (i + 1) % 16) == 0)) {
            [strValue appendString:@"   "];
            [strValue appendString:strLineValue];
            strLineValue = [[NSMutableString alloc] init];
            [strValue appendString:@"\n"];
        } else if (i > 0 && (( (i + 1) % 4) == 0)) {
            [strValue appendString:@"|"];
        } else {
            [strValue appendString:@" "];
        }
    }
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:strValue];
    [_textView setFont:[NSFont fontWithName:@"Andale Mono" size:11]];
}

@end
