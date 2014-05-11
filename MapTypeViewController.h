//
//  MapTypeViewController.h
//  PAK processor
//
//  Created by id on 11/17/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface MapTypeViewController : NSViewController

- (void)setContent:(Map *)content;

@property (weak) IBOutlet NSTextField *legnth;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end
