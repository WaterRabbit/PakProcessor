//
//  GraphicFileTypeBase.m
//  PAK processor
//
//  Created by id on 11/19/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "GraphicFileTypeBase.h"

@interface GraphicFileTypeBase() {

}
@end

@implementation GraphicFileTypeBase

- (id)initFromData:(NSData *)data {
    self = [super initFromData:data];
    if (self) {
        _imageFrames = [[NSMutableArray alloc] init];
        _houseID = 0;
        _canSelectHouse = false;
        [self generateImages];
    }
    return self;
}

- (id)initFromData:(NSData *)data withFrame:(ImageFrame *)frame {
    self = [super initFromData:data];
    if (self) {
        _imageFrames = [[NSMutableArray alloc] init];
        [self generateImagesWithFrame:frame];
    }
    return self;
}

- (void)generateImages {
    NSException *initExeption = [[NSException alloc] initWithName:@"Can not generate images" reason:@"Please override generateImages" userInfo:nil];
    [initExeption raise];
}

- (void)generateImagesWithFrame:(ImageFrame *)frame {
    NSException *initExeption = [[NSException alloc] initWithName:@"Can not generate images" reason:@"Please override generateImagesWithFrame" userInfo:nil];
    [initExeption raise];
}

- (ImageFrame *)getLastFrame {
    if ([_imageFrames count] == 0) return Nil;
    return [_imageFrames objectAtIndex:[_imageFrames count] - 1];
}

- (NSArray *)houses {
    return [[NSArray alloc] initWithObjects:@"Harkonen", @"Attreides", @"Ordos", @"Fremen", @"Sardaukar", @"Mercenery", nil];
}

@end
