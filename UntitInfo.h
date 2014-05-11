//
//  UntitInfo.h
//  PAK processor
//
//  Created by id on 05/04/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UntitInfo : NSObject

@property NSString *name;
@property NSString *nameLong;
@property NSString *wsa;
@property NSMutableArray *objectFlags;
@property NSNumber *spawnChance;
@property NSNumber *hitpoints;
@property NSNumber *fogUncoverRadius;

- (void)loadUnit:(NSString*)unitName;

@end
