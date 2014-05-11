//
//  TxtTypeViewController.m
//  PAK processor
//
//  Created by id on 03/03/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import "TxtTypeViewController.h"

@interface TxtTypeViewController ()

@end

@implementation TxtTypeViewController

- (id)init {
    self = [super initWithNibName:@"IniType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContent:(Txt *)content {
    
    NSString *result = @"";
    for (int i = 0; i < content.strings.count; i++) {
        result = [result stringByAppendingString:[content.strings objectAtIndex:i]];
        result = [result stringByAppendingString:@"\n"];
    }
    
    [_textView insertText:result];
    [_textView scrollRangeToVisible:NSMakeRange(0,0)];
}

@end
