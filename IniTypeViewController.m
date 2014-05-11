//
//  IniTypeViewController.m
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "IniTypeViewController.h"

@interface IniTypeViewController ()

@end

@implementation IniTypeViewController

- (id)init {
    self = [super initWithNibName:@"IniType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContent:(Ini *)content {
    [_textView insertText:content.text];
    [_textView scrollRangeToVisible:NSMakeRange(0,0)];
}

@end
