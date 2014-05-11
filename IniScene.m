//
//  IniScene.m
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#define max(a, b) ((a) > (b) ? (a) : (b))

#define min(a, b) ((a) < (b) ? (a) : (b))

#import "IniScene.h"

#import "MapHelpers.h"

@interface IniScene() {
    unsigned char _seed0;
    unsigned char _seed1;
    unsigned char _seed2;
    unsigned char _seed3;
    
}
@end

@implementation IniScene

- (id)initFromData:(NSData *)data {
    self = [super initFromData:data];
    if (self) {
        _basic = [[ScenarioBasic alloc] init];
        _map = [[ScenarioMap alloc] init];
        _mapTiles = [[NSData alloc] init];
        _categories = [[NSMutableDictionary alloc] init];
        _structures = [[ScenarioStructures alloc] init];
        
        int lineNum = [self getLineCount];
        NSString *category;
        for (int i = 1; i <= lineNum; i++) {
            NSString *line = [[self getLine:i] copy];
            line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            line = [line stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
            if ([line length] > 0 && [line characterAtIndex:0] != ';') {
                if ([line characterAtIndex:0] == '[' && [line characterAtIndex:line.length - 1] == ']') {
                    category = [line substringWithRange:NSMakeRange(1, line.length - 2)];
                    [_categories setObject:[[NSMutableDictionary alloc] init] forKey:category];
                } else {
                    NSArray *components = [line componentsSeparatedByString:@"="];
                    if (components.count > 1) {
                        [[_categories objectForKey:category] setObject:[components objectAtIndex:1]  forKey:[components objectAtIndex:0]];
                    }
                }
            }
        }
        
        _basic.loosePicture = [[_categories objectForKey:@"BASIC"] objectForKey:@"LosePicture"];
        _basic.winPicture = [[_categories objectForKey:@"BASIC"] objectForKey:@"WinPicture"];
        _basic.briefPicture = [[_categories objectForKey:@"BASIC"] objectForKey:@"BriefPicture"];
        _basic.timeOut = [[[_categories objectForKey:@"BASIC"] objectForKey:@"TimeOut"] integerValue];
        _basic.mapScale = [[[_categories objectForKey:@"BASIC"] objectForKey:@"MapScale"] integerValue];
        _basic.cursorPos = [[[_categories objectForKey:@"BASIC"] objectForKey:@"CursorPos"] integerValue];
        _basic.tacticalPos = [[[_categories objectForKey:@"BASIC"] objectForKey:@"TacticalPos"] integerValue];
        _basic.looseFlags = [[[_categories objectForKey:@"BASIC"] objectForKey:@"LoseFlags"] integerValue];
        _basic.winFlags = [[[_categories objectForKey:@"BASIC"] objectForKey:@"WinFlags"] integerValue];
        
        _map.seed = [[[_categories objectForKey:@"MAP"] objectForKey:@"Seed"] integerValue];
        _map.bloom = [self getStringAsNumericArray:[[_categories objectForKey:@"MAP"] objectForKey:@"Bloom"]];
        _map.field = [self getStringAsNumericArray:[[_categories objectForKey:@"MAP"] objectForKey:@"Field"]];
        
        for (NSString *key in [[_categories objectForKey:@"STRUCTURES"] allKeys]) {
            NSString *value = [[_categories objectForKey:@"STRUCTURES"] objectForKey:key];
            if ([key characterAtIndex:0] == 'I') {
                if ([key length] < 3) {
                    NSLog(@"Invalid structure identifier %@", key);
                } else {
                    NSInteger structureId = [[key substringFromIndex:2] integerValue];
                    NSArray *structureItems = [value componentsSeparatedByString:@","];
                    [_structures.buildings addObject:[[Building alloc] initWithId:structureId withHouse:[structureItems objectAtIndex:0] withType:[structureItems objectAtIndex:1] withHitpoints:[[structureItems objectAtIndex:2] integerValue] withPosition:[[structureItems objectAtIndex:3] integerValue]]];
                }
            } else {
                if ([key length] < 4) {
                    NSLog(@"Invalid structure identifier %@", key);
                } else {
                    NSInteger position = [[key substringFromIndex:3] integerValue];
                    NSArray *structureItems = [value componentsSeparatedByString:@","];
                    [_structures.nonBuildings addObject:[[NonBuilding alloc] initWithPosition:position withHouse:[structureItems objectAtIndex:0] withType:[structureItems objectAtIndex:1]]];
                }
            }
        }
        
        
        [self generateMap:_map.seed];
        //     NSString *category = @"";
        
        //        for (int i = 1; i <= lineNum; i++) {
        ////            NSLog(@"%@", [self getLine:i]);
        //            if (![self isCommentLine:i]) {
        //                if ([self isCategaroyLine:i]) {
        //                    NSString *line = [[self getLine:i] copy];
        //                    line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //                    category = [line stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
        //                } else {
        //                    if ([category isEqualToString:@"[BASIC]"]) {
        //                        NSString *line = [self getLine:i];
        //                        NSDictionary *keyValue = [self getKeyValue:line];
        //                        NSString *name = [keyValue objectForKey:@"key"];
        //                        NSString *value = [keyValue objectForKey:@"value"];
        //                        if ([name isEqualToString:@"LosePicture"]) {
        //                            _basic.loosePicture = value;
        //                        } else if ([name isEqualToString:@"WinPicture"]) {
        //                            _basic.winPicture = value;
        //                        } else if ([name isEqualToString:@"BriefPicture"]) {
        //                            _basic.briefPicture = value;
        //                        } else if ([name isEqualToString:@"TimeOut"]) {
        //                            _basic.timeOut = [value intValue];
        //                        } else if ([name isEqualToString:@"MapScale"]) {
        //                            _basic.mapScale = [value intValue];
        //                        } else if ([name isEqualToString:@"CursorPos"]) {
        //                            _basic.cursorPos = [value intValue];
        //                        } else if ([name isEqualToString:@"TacticalPos"]) {
        //                            _basic.TacticalPos = [value intValue];
        //                        } else if ([name isEqualToString:@"LoseFlags"]) {
        //                            _basic.looseFlags = [value intValue];
        //                        } else if ([name isEqualToString:@"WinFlags"]) {
        //                            _basic.winFlags = [value intValue];
        //                        }
        //                    } else if ([category isEqualToString:@"[MAP]"]) {
        //                        NSString *line = [self getLine:i];
        //                        NSDictionary *keyValue = [self getKeyValue:line];
        //                        NSString *name = [keyValue objectForKey:@"key"];
        //                        NSString *value = [keyValue objectForKey:@"value"];
        //                        if ([name isEqualToString:@"Field"]) {
        //                            _map.field = [self getStringAsNumericArray:value];
        //                        } else if ([name isEqualToString:@"Bloom"]) {
        //                            _map.bloom = [self getStringAsNumericArray:value];
        //                        } else if ([name isEqualToString:@"Seed"]) {
        //                            _map.seed = [value intValue];
        //                            [self generateMap:[value intValue]];
        //                       //     [self generateMap:353];
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
    //   [self generateMap:0];
    return self;
}

- (void)generateMap:(unsigned int)seed {
    
    [self initSeed:seed];
    
    uint16 i;
    uint16 j;
    uint16 k;
    uint8  memory[273];
    uint16 currentRow[64];
    uint16 previousRow[64];
    uint16 spriteID1;
    uint16 spriteID2;
    
    uint8 g_map[64 * 64];
    
    memset(g_map, 0, 64*64);
    
    for (i = 0; i < 272; i++) {
        memory[i] = [self generateRandomNumber] & 0xF;
        if (memory[i] > 0xA) memory[i] = 0xA;
    }
    
    i = ([self generateRandomNumber] & 0xF) + 1;
    while (i-- != 0) {
        short base = [self generateRandomNumber];
        if (i == 0) {
            i =0;
        }
        for (j = 0; j < sizeof(around); j++) {
            short index = min(max(0, base + around[j]), 272);
            
            memory[index] = (memory[index] + ([self generateRandomNumber] & 0xF)) & 0xF;
        }
    }
    
    i = ([self generateRandomNumber] & 0x3) + 1;
    while (i-- != 0) {
        short base = [self generateRandomNumber];
        
        for (j = 0; j < sizeof(around); j++) {
            short index = min(max(0, base + around[j]), 272);
            
            memory[index] = [self generateRandomNumber] & 0x3;
        }
    }
    
    for (j = 0; j < 16; j++) {
        for (i = 0; i < 16; i++) {
            g_map[Tile_PackXY(i * 4, j * 4)] = memory[j * 16 + i];
        }
    }
    
    /* Average around the 4x4 grid. */
    for (j = 0; j < 16; j++) {
        for (i = 0; i < 16; i++) {
            for (k = 0; k < 21; k++) {
                unsigned char *offsets = _offsetTable[(i + 1) % 2][k];
                uint16 packed1;
                uint16 packed2;
                uint16 packed;
                uint16 sprite2;
                
                packed1 = Tile_PackXY(i * 4 + offsets[0], j * 4 + offsets[1]);
                packed2 = Tile_PackXY(i * 4 + offsets[2], j * 4 + offsets[3]);
                packed = (packed1 + packed2) / 2;
                
                if (Tile_IsOutOfMap(packed)) continue;
                
                packed1 = Tile_PackXY((i * 4 + offsets[0]) & 0x3F, j * 4 + offsets[1]);
                packed2 = Tile_PackXY((i * 4 + offsets[2]) & 0x3F, j * 4 + offsets[3]);
                assert(packed1 < 64 * 64);
                
                /* ENHANCEMENT -- use groundSpriteID=0 when out-of-bounds to generate the original maps. */
                if (packed2 < 64 * 64) {
                    sprite2 = g_map[packed2];
                } else {
                    sprite2 = 0;
                }
                
                g_map[packed] = (g_map[packed1] + sprite2 + 1) / 2;
            }
        }
    }
    
    
    
    
    memset(currentRow, 0, 128);
    
    /* Average each tile with its neighbours. */
    for (j = 0; j < 64; j++) {
        uint16 t = j * 64;
        memcpy(previousRow, currentRow, 128);
        
        for (i = 0; i < 64; i++) currentRow[i] = g_map[t + i];
        
        for (i = 0; i < 64; i++) {
            uint16 neighbours[9];
            uint16 total = 0;
            
            neighbours[0] = (i == 0  || j == 0)  ? currentRow[i] : previousRow[i - 1];
            neighbours[1] = (           j == 0)  ? currentRow[i] : previousRow[i];
            neighbours[2] = (i == 63 || j == 0)  ? currentRow[i] : previousRow[i + 1];
            neighbours[3] = (i == 0)             ? currentRow[i] : currentRow[i - 1];
            neighbours[4] =                        currentRow[i];
            neighbours[5] = (i == 63)            ? currentRow[i] : currentRow[i + 1];
            neighbours[6] = (i == 0  || j == 63) ? currentRow[i] : g_map[t + i + 63];
            neighbours[7] = (           j == 63) ? currentRow[i] : g_map[t + i + 64];
            neighbours[8] = (i == 63 || j == 63) ? currentRow[i] : g_map[t + i + 65];
            
            for (k = 0; k < 9; k++) total += neighbours[k];
            g_map[t + i] = total / 9;
        }
    }
    
    /* Filter each tile to determine its final type. */
    spriteID1 = [self generateRandomNumber] & 0xF;
    if (spriteID1 < 0x8) spriteID1 = 0x8;
    if (spriteID1 > 0xC) spriteID1 = 0xC;
    
    spriteID2 = ([self generateRandomNumber] & 0x3) - 1;
    if (spriteID2 > spriteID1 - 3) spriteID2 = spriteID1 - 3;
    
    for (i = 0; i < 4096; i++) {
        uint16 spriteID = g_map[i];
        
        if (spriteID > spriteID1 + 4) {
            spriteID = LST_ENTIRELY_MOUNTAIN;
        } else if (spriteID >= spriteID1) {
            spriteID = LST_ENTIRELY_ROCK;
        } else if (spriteID <= spriteID2) {
            spriteID = LST_ENTIRELY_DUNE;
        } else {
            spriteID = LST_NORMAL_SAND;
        }
        
        g_map[i] = spriteID;
    }
    
    /* Add some spice. */
    i = [self generateRandomNumber] & 0x2F;
    while (i-- != 0) {
        tile32 tile;
        uint16 packed;
        
        while (true) {
            packed = [self generateRandomNumber] & 0x3F;
            packed = Tile_PackXY([self generateRandomNumber] & 0x3F, packed);
            
            if (g_table_landscapeInfo[g_map[packed]].canBecomeSpice) break;
        }
        
        tile = Tile_UnpackTile(packed);
        
        j = [self generateRandomNumber] & 0x1F;
        while (j-- != 0) {
            while (true) {
                packed = Tile_PackTile([self Tile_MoveByRandom:tile distance:[self generateRandomNumber] & 0x3F center:true]);
                
                if (!Tile_IsOutOfMap(packed)) break;
            }
            
            Map_AddSpiceOnTile(g_map, packed);
        }
    }
    
    /* Make everything smoother and use the right sprite indexes. */
    for (j = 0; j < 64; j++) {
        uint16 t = j * 64;
        
        memcpy(previousRow, currentRow, 128);
        
        for (i = 0; i < 64; i++) currentRow[i] = g_map[t + i];
        
        for (i = 0; i < 64; i++) {
            uint16 current = g_map[t + i];
            uint16 up      = (j == 0)  ? current : previousRow[i];
            uint16 left    = (i == 63) ? current : currentRow[i + 1];
            uint16 down    = (j == 63) ? current : g_map[t + i + 64];
            uint16 right   = (i == 0)  ? current : currentRow[i - 1];
            uint16 spriteID = 0;
            
            if (up    == current) spriteID |= 1;
            if (left  == current) spriteID |= 2;
            if (down  == current) spriteID |= 4;
            if (right == current) spriteID |= 8;
            
            switch (current) {
                case LST_NORMAL_SAND:
                    spriteID = 0;
                    break;
                case LST_ENTIRELY_ROCK:
                    if (up    == LST_ENTIRELY_MOUNTAIN) spriteID |= 1;
                    if (left  == LST_ENTIRELY_MOUNTAIN) spriteID |= 2;
                    if (down  == LST_ENTIRELY_MOUNTAIN) spriteID |= 4;
                    if (right == LST_ENTIRELY_MOUNTAIN) spriteID |= 8;
                    spriteID++;
                    break;
                case LST_ENTIRELY_DUNE:
                    spriteID += 17;
                    break;
                case LST_ENTIRELY_MOUNTAIN:
                    spriteID += 33;
                    break;
                case LST_SPICE:
                    if (up    == LST_THICK_SPICE) spriteID |= 1;
                    if (left  == LST_THICK_SPICE) spriteID |= 2;
                    if (down  == LST_THICK_SPICE) spriteID |= 4;
                    if (right == LST_THICK_SPICE) spriteID |= 8;
                    spriteID += 49;
                    break;
                case LST_THICK_SPICE:
                    spriteID += 65;
                    break;
                default: break;
            }
            
            g_map[t + i] = spriteID;
        }
    }
    
    /* Finalise the tiles with the real sprites. */
    //	iconMap = &g_iconMap[g_iconMap[ICM_ICONGROUP_LANDSCAPE]];
    //
    //	for (i = 0; i < 4096; i++) {
    _mapTiles = [[NSData alloc] initWithBytes:g_map length:4096];
    //    }
    //	Tile *t = &g_map[i];
    //    g_map[i] = iconMap[g_map[i]];
    //		t->groundSpriteID  = iconMap[t->groundSpriteID];
    //		t->overlaySpriteID = g_veiledSpriteID;
    //		t->houseID         = HOUSE_HARKONNEN;
    //		t->isUnveiled      = false;
    //		t->hasUnit         = false;
    //		t->hasStructure    = false;
    //		t->hasAnimation    = false;
    //		t->hasExplosion  = false;
    //		t->index           = 0;
    //	}
    
    //for (i = 0; i < 4096; i++) g_mapSpriteID[i] = g_map[i];
    
    
    
}

- (void)initSeed:(unsigned int)seed {
    _seed0 = (seed >>  0) & 0xFF;
    _seed1 = (seed >>  8) & 0xFF;
    _seed2 = (seed >> 16) & 0xFF;
    _seed3 = (seed >> 24) & 0xFF;
}

- (unsigned char)generateRandomNumber {
    uint16 val16;
    uint8 val8;
    
    val16 = (_seed1 << 8) | _seed2;
    val8 = ((val16 ^ 0x8000) >> 15) & 1;
    val16 = (val16 << 1) | ((_seed0 >> 1) & 1);
    val8 = (_seed0 >> 2) - _seed0 - val8;
    _seed0 = (val8 << 7) | (_seed0 >> 1);
    _seed1 = val16 >> 8;
    _seed2 = val16 & 0xFF;
    //   NSLog(@"%d", _seed0 ^ _seed1);
    return _seed0 ^ _seed1;
}


uint16 Tile_PackTile(tile32 tile)
{
    return (Tile_GetPosY(tile) << 6) | Tile_GetPosX(tile);
}

/**
 * Packs an x and y coordinate into a 12 bits packed tile.
 *
 * @param x The X-coordinate from.
 * @param x The Y-coordinate from.
 * @return The coordinates packed into 12 bits.
 */
uint16 Tile_PackXY(uint16 x, uint16 y)
{
    return (y << 6) | x;
}

/**
 * Unpacks a 12 bits packed tile to a 32 bits tile struct.
 *
 * @param packed The uint16 containing the 12 bits packed tile information.
 * @return The unpacked tile.
 */
tile32 Tile_UnpackTile(uint16 packed)
{
    tile32 tile;
    
    tile.x = (((packed >> 0) & 0x3F) << 8) | 0x80;
    tile.y = (((packed >> 6) & 0x3F) << 8) | 0x80;
    
    return tile;
}

bool Tile_IsOutOfMap(uint16 packed)
{
    return (packed & 0xF000) != 0;
}

static void Map_AddSpiceOnTile(uint8 *g_map, uint16 packed)
{
    uint16 t;
    
    t = g_map[packed];
    
    switch (t) {
        case LST_SPICE:
            g_map[packed] = LST_THICK_SPICE;
            Map_AddSpiceOnTile(g_map, packed);
            return;
            
        case LST_THICK_SPICE: {
            signed char i;
            signed char j;
            
            for (j = -1; j <= 1; j++) {
                for (i = -1; i <= 1; i++) {
                    //Tile *t2;
                    uint16 packed2 = Tile_PackXY(Tile_GetPackedX(packed) + i, Tile_GetPackedY(packed) + j);
                    
                    if (Tile_IsOutOfMap(packed2)) continue;
                    
                    //	t2 = &g_map[packed2];
                    
                    if (!g_table_landscapeInfo[g_map[packed2]].canBecomeSpice) {
                        g_map[packed] = LST_SPICE;
                        continue;
                    }
                    
                    if (g_map[packed2] != LST_THICK_SPICE) g_map[packed2] = LST_SPICE;
                }
            }
            return;
        }
            
        default:
            if (g_table_landscapeInfo[g_map[packed]].canBecomeSpice) g_map[packed] = LST_SPICE;
            return;
    }
}

-(tile32) Tile_MoveByRandom:(tile32)tile distance:(uint16)distance center:(bool)center
{
    uint16 x;
    uint16 y;
    tile32 ret;
    uint8 orientation;
    uint16 newDistance;
    
    if (distance == 0) return tile;
    
    x = Tile_GetX(tile);
    y = Tile_GetY(tile);
    
    newDistance =[self generateRandomNumber];
    while (newDistance > distance) newDistance /= 2;
    distance = newDistance;
    
    orientation = [self generateRandomNumber];
    x += ((_stepX[orientation] * distance) / 128) * 16;
    y -= ((_stepY[orientation] * distance) / 128) * 16;
    
    if (x > 16384 || y > 16384) return tile;
    
    ret.x = x;
    ret.y = y;
    
    return center ? Tile_Center(ret) : ret;
}

uint16 Tile_GetX(tile32 tile)
{
    return tile.x;
}

/**
 * Returns the Y-position of the tile.
 *
 * @param tile The tile32 to get the Y-position from.
 * @return The Y-position of the tile.
 */
uint16 Tile_GetY(tile32 tile)
{
    return tile.y;
}

tile32 Tile_Center(tile32 tile)
{
    tile32 result;
    
    result = tile;
    result.x = (result.x & 0xff00) | 0x80;
    result.y = (result.y & 0xff00) | 0x80;
    
    return result;
}

tile32 Tile_MakeXY(uint16 x, uint16 y)
{
    tile32 tile;
    
    tile.x = x << 8;
    tile.y = y << 8;
    
    return tile;
}

uint8 Tile_GetPackedX(uint16 packed)
{
    return (packed >> 0) & 0x3F;
}

/**
 * Unpacks a 12 bits packed tile and retrieves the Y-position.
 *
 * @param packed The uint16 containing the 12 bits packed tile.
 * @return The unpacked Y-position.
 */
uint8 Tile_GetPackedY(uint16 packed)
{
    return (packed >> 6) & 0x3F;
}

/**
 * Returns the X-position of the tile.
 *
 * @param tile The tile32 to get the X-position from.
 * @return The X-position of the tile.
 */
uint8 Tile_GetPosX(tile32 tile)
{
    return (tile.x >> 8) & 0x3f;
}

uint8 Tile_GetPosY(tile32 tile)
{
    return (tile.y >> 8) & 0x3f;
}

@end
