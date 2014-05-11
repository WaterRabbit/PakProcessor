//
//  MapTypeViewController.m
//  PAK processor
//
//  Created by id on 11/17/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "MapTypeViewController.h"

@implementation MapTypeViewController

- (id)init {
    self = [super initWithNibName:@"MapType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContent:(Map *)content {
    [_legnth setIntValue:(int)[content.data length]];
    
    NSMutableString *strValue = [[NSMutableString alloc] init];
    NSTextStorage *ts = [_textView textStorage];
    
    for (int i = 0; i < [content.tileSet count]; i++) {
         [strValue appendFormat:@"%d | ", i ];
        for (int j = 0; j < [[content.tileSet objectAtIndex:i] count]; j++) {
            [strValue appendFormat:@"%@ ", [[content.tileSet objectAtIndex:i] objectAtIndex:j]];
        }
        [strValue appendString:@".\n"];
    }
//    for (int i = 0; i < content.length; i++) {
//        int value = 0;
//        [content getBytes:&value range:NSMakeRange(i, 1)];
//        [strValue appendString:[[[NSString alloc] initWithFormat: @"%02x", value] uppercaseString]];
//        if (value >= 32) {
//            [strLineValue appendString:[[NSString alloc] initWithFormat: @"%c", value]];
//        } else {
//            [strLineValue appendString:@"."];
//        }
//        if (i > 0 && (( (i + 1) % 16) == 0)) {
//            [strValue appendString:@"   "];
//            [strValue appendString:strLineValue];
//            strLineValue = [[NSMutableString alloc] init];
//            [strValue appendString:@"\n"];
//        } else if (i > 0 && (( (i + 1) % 4) == 0)) {
//            [strValue appendString:@"|"];
//        } else {
//            [strValue appendString:@" "];
//        }
//    }
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:strValue];
    [_textView setFont:[NSFont fontWithName:@"Andale Mono" size:11]];
}
@end
