//
//  GraphicFileTypeBase.h
//  PAK processor
//
//  Created by id on 11/19/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "FileTypeBase.h"
#import "format80.h"
#import "format40.h"
#import "FileReaders.h"
#import "ImageFrame.h"

@interface GraphicFileTypeBase : FileTypeBase

@property NSMutableArray *imageFrames;
@property int houseID;
@property BOOL canSelectHouse;

@property (readonly) NSArray *houses;

- (void)generateImages;

- (void)generateImagesWithFrame:(ImageFrame *)frame;

- (id)initFromData:(NSData *)data withFrame:(ImageFrame *)frame;
- (ImageFrame *)getLastFrame;

@end
