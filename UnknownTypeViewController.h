//
//  UnknownTypeViewController.h
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UnknownTypeViewController : NSViewController

- (void)setContent:(NSData *)content;

@property (weak) IBOutlet NSTextField *legnth;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@end
