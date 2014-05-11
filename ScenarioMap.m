//
//  ScenarioMap.m
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "ScenarioMap.h"

@implementation ScenarioMap

- (id)init {
    self = [super init];
    if (self) {
        _field = [[NSArray alloc] init];
        _bloom = [[NSArray alloc] init];
    }
    return self;
}
@end
