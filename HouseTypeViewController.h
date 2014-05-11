//
//  HouseTypeViewController.h
//  PAK processor
//
//  Created by id on 11/24/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Pal.h"
#import "GraphicFileTypeBase.h"

@interface HouseTypeViewController : NSViewController <NSComboBoxDelegate>

@property NSMutableArray *imagesData;

@property NSArray *houses;

@property GraphicFileTypeBase *grphData;
@property Pal *palData;

- (void)setContent:(GraphicFileTypeBase *)content withPalette:(Pal *)palette;

@property (weak) IBOutlet NSCollectionView *coll;
@property (weak) IBOutlet NSComboBox *housesCombo;

@property bool canSelectHouses;

@end
