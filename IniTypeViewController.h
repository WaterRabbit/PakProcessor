//
//  IniTypeViewController.h
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Ini.h"

@interface IniTypeViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *textView;

- (void)setContent:(Ini *)content;

@end
