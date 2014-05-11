//
//  ScenarioStructures.m
//  PAK processor
//
//  Created by id on 02/02/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import "ScenarioStructures.h"

@implementation Building

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithId:(NSInteger)buildingId withHouse:(NSString*)house withType:(NSString*)type withHitpoints:(NSInteger)hitpoints withPosition:(NSInteger)position {
    self = [super init];
    if (self) {
        _buildingId = buildingId;
        _position = position;
        _owner = house;
        _type = type;
        _health = hitpoints;
    }
    return self;
}

@end

@implementation NonBuilding

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithPosition:(NSInteger)position withHouse:(NSString*)house withType:(NSString*)type {
    self = [super init];
    if (self) {
        _position = position;
        _owner = house;
        _type = type;
    }
    return self;
}

@end

@implementation ScenarioStructures

- (id)init {
    self = [super init];
    if (self) {
        _buildings = [[NSMutableArray alloc] init];
        _nonBuildings = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
