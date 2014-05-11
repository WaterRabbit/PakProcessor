//
//  WindowController.h
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PakProcessor.h"

@interface WindowController : NSWindowController<NSTableViewDataSource, NSTableViewDelegate>

@property PakProcessor *pakProcessor;
@property NSViewController *controller;
@property NSView *controllerView;
@property NSString *selectedPakFile;
@property NSString *contentFile;
//@property NSMutableDictionary *paletteFiles;

- (IBAction)GenerateMapSprites:(id)sender;

@property (weak) IBOutlet NSTableView *pakFilesTableView;
@property (weak) IBOutlet NSTableView *pakFileContentFilesTableView;
@property (weak) IBOutlet NSView *viewToReplace;

@end
