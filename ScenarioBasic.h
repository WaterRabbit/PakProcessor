//
//  ScenarioBasic.h
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenarioBasic : NSObject

@property NSString *loosePicture;
@property NSString *winPicture;
@property NSString *briefPicture;

@property int timeOut;
@property int mapScale;
@property int cursorPos;
@property int tacticalPos;
@property int looseFlags;
@property int winFlags;

@end
