//
//  WsaTypeViewController.h
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Wsa.h"
#import "Pal.h"

@interface WsaTypeViewController : NSViewController

@property NSMutableArray *images;

- (void)setContent:(Wsa *)content withPalette:(Pal *)palette;

@property (weak) IBOutlet NSCollectionView *coll;
@property (strong) IBOutlet NSArrayController *arrCont;

@end
