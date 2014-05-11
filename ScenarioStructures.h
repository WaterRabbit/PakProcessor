//
//  ScenarioStructures.h
//  PAK processor
//
//  Created by id on 02/02/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Building : NSObject

@property NSInteger buildingId;
@property NSString *owner;
@property NSString *type;
@property NSInteger health;
@property NSInteger position;

- (id)initWithId:(NSInteger)buildingId withHouse:(NSString*)house withType:(NSString*)type withHitpoints:(NSInteger)hitpoints withPosition:(NSInteger)position;

@end

@interface NonBuilding : NSObject

@property NSInteger position;
@property NSString *owner;
@property NSString *type;

- (id)initWithPosition:(NSInteger)position withHouse:(NSString*)house withType:(NSString*)type;

@end

@interface ScenarioStructures : NSObject

@property NSMutableArray *buildings;

@property NSMutableArray *nonBuildings;

@end
