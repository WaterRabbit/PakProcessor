//
//  TxtTypeViewController.h
//  PAK processor
//
//  Created by id on 03/03/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Txt.h"

@interface TxtTypeViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *textView;

- (void)setContent:(Txt *)content;


@end
