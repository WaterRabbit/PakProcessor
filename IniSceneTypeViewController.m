//
//  IniSceneTypeViewController.m
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "IniSceneTypeViewController.h"

@interface IniSceneTypeViewController ()

@end

@implementation IniSceneTypeViewController

- (id)init {
    self = [super initWithNibName:@"IniSceneType" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setContent:(IniScene *)content withSprites:(Icn *)sprites withPalette:(Pal *)palette withMap:(Map *)map {
    
    static const uint8 wall[] = {
        0,  3,  1,  2,  3,  3,  4,  5,  1,  6,  1,  7,  8,  9, 10, 11,
        1, 12,  1, 19,  1, 16,  1, 31,  1, 28,  1, 52,  1, 45,  1, 59,
        3,  3, 13, 20,  3,  3, 22, 32,  3,  3, 13, 53,  3,  3, 38, 60,
        5,  6,  7, 21,  5,  6,  7, 33,  5,  6,  7, 54,  5,  6,  7, 61,
        9,  9,  9,  9, 17, 17, 23, 34,  9,  9,  9,  9, 25, 46, 39, 62,
		11, 12, 11, 12, 13, 18, 13, 35, 11, 12, 11, 12, 13, 47, 13, 63,
		15, 15, 16, 16, 17, 17, 24, 36, 15, 15, 16, 16, 17, 17, 40, 64,
		19, 20, 21, 22, 23, 24, 25, 37, 19, 20, 21, 22, 23, 24, 25, 65,
		27, 27, 27, 27, 27, 27, 27, 27, 14, 29, 14, 55, 26, 48, 41, 66,
		29, 30, 29, 30, 29, 30, 29, 30, 31, 30, 31, 56, 31, 49, 31, 67,
		33, 33, 34, 34, 33, 33, 34, 34, 35, 35, 15, 57, 35, 35, 42, 68,
		37, 38, 39, 40, 37, 38, 39, 40, 41, 42, 43, 58, 41, 42, 43, 69,
		45, 45, 45, 45, 46, 46, 46, 46, 47, 47, 47, 47, 27, 50, 43, 70,
		49, 50, 49, 50, 51, 52, 51, 52, 53, 54, 53, 54, 55, 51, 55, 71,
		57, 57, 58, 58, 59, 59, 60, 60, 61, 61, 62, 62, 63, 63, 44, 72,
		65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 73
	};
    static const sint16 g_table_mapDiff[4] = {
        -64, 1, 64, -1
    };
    
    int pixelSize = 1;
    NSArray *mapTilesArray;
    mapTilesArray = [map.tileSet objectAtIndex:9];
    
    [_winPictureLabel setStringValue:content.basic.winPicture];
    [_losePictureLabel setStringValue:content.basic.loosePicture];
    [_briefPictureLabel setStringValue:content.basic.briefPicture];
    
    [_textView insertText:content.text];
    [_textView scrollRangeToVisible:NSMakeRange(0,0)];
    

    ImageFrame *frame = [sprites.imageFrames objectAtIndex:0];

    NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize * 64, frame.height * pixelSize * 64)];
    [image lockFocus];
    
 //   unsigned long xxx = [[content mapTiles] length] * frame.height * frame.width;
 //   NSRect[] rect =   NSRect[xxx];
 //   int index = 0;
    
    for (int i = 0; i < content.mapTiles.length; i++) {
        uint8 tileIndex;
        [content.mapTiles getBytes:&tileIndex range:NSMakeRange(i, 1)];
        NSInteger frameIndex = [[mapTilesArray objectAtIndex:tileIndex] integerValue];
        frame = [sprites.imageFrames objectAtIndex:frameIndex];
        int yPos = i/64;
        int xPos = i%64;
        
        unsigned char imageContent[frame.width * frame.height];
        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
        
//        for (int z = 0; z < frame.width * frame.height; z++) {
//            if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
//        }

        for (int y = 0; y < frame.height; y++) {
            for (int x = 0; x < frame.width; x++) {
                [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
//                if (i == 0) {
//                    [[NSColor redColor] set];
//                }
         //       rect[index] = NSMakeRect(xPos * frame.width  + x * pixelSize, (64 - yPos - 1) * frame.height + (frame.height - y - 1) * pixelSize, pixelSize, pixelSize);
           //     index++;
                NSRectFill(NSMakeRect(xPos * frame.width  + x * pixelSize, (64 - yPos - 1) * frame.height + (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
            }
        }
    }
//    NSRectFillList(rect, index);
    
    unsigned char wallMap[64*64];
    
    memset(wallMap, 0, 64*64);
    
    mapTilesArray = [map.tileSet objectAtIndex:8];
    frame = [sprites.imageFrames objectAtIndex:[[mapTilesArray objectAtIndex:2] integerValue]];
    unsigned char imageContent[frame.width * frame.height];
   [frame.imageData getBytes:&imageContent length:frame.imageData.length];

    for (int i = 0; i < content.structures.nonBuildings.count; i++) {
        long pos =  [(NonBuilding *)[content.structures.nonBuildings objectAtIndex: i]  position];
        long yPos = pos/64;
        int xPos = pos%64;
        if ([[(NonBuilding *)[content.structures.nonBuildings objectAtIndex: i] type] isEqualTo:@"Concrete"]) {
            for (int y = 0; y < frame.height; y++) {
                for (int x = 0; x < frame.width; x++) {
                    [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
                    NSRectFill(NSMakeRect(xPos * frame.width  + x * pixelSize, (64 - yPos - 1) * frame.height + (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
                }
            }
        } else {
            wallMap[ [(NonBuilding *)[content.structures.nonBuildings objectAtIndex: i]  position]] = 1;
        }
    }
    for (int i = 0 ; i < 64 * 64; i++) {
        if (wallMap[i] > 0) {
            int bits = 0;
            for (int j = 0; j < 4; j++) {
                uint16 curPos = i + g_table_mapDiff[j];
                if ((curPos >= 0)  && (curPos < 64*64)) {
                    if (wallMap[curPos] >= 1) {
                        bits |= (1 << j);
                    }
                }
            }
            
            wallMap[i] = wall[bits] + 1;
            if (bits == 1) {
                wallMap[i] = 1;
            }
        }
    }
    
    mapTilesArray = [map.tileSet objectAtIndex:6];

    for (int i = 0 ; i < 64 * 64; i++) {
        if (wallMap[i] >= 1) {
            frame = [sprites.imageFrames objectAtIndex:[[mapTilesArray objectAtIndex:wallMap[i]] integerValue]];
            unsigned char imageContent[frame.width * frame.height];
            [frame.imageData getBytes:&imageContent length:frame.imageData.length];
            long yPos = i/64;
            int xPos = i%64;
            for (int y = 0; y < frame.height; y++) {
                for (int x = 0; x < frame.width; x++) {
                    [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
                    NSRectFill(NSMakeRect(xPos * frame.width  + x * pixelSize, (64 - yPos - 1) * frame.height + (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
                }
            }
        }
    }
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"StructureInfos.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"StructureInfos" ofType:@"plist"];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    
    for (int i = 0; i < content.structures.buildings.count; i++) {
        long pos =  [(NonBuilding *)[content.structures.buildings objectAtIndex: i]  position];
        NSString *name = [(NonBuilding *)[content.structures.buildings objectAtIndex: i]  type];
        NSString *house = [(NonBuilding *)[content.structures.buildings objectAtIndex: i]  owner];
        NSDictionary *building = [temp objectForKey:name];
        if (building) {
            long width = [[building objectForKey:@"layoutWidth"] integerValue];
            long height = [[building objectForKey:@"layoutHeight"] integerValue];
            long imagesPerGroup = width * height;
            long yPos = (64 -(pos/64 + height)) * 16;
            int xPos = (pos%64) * 16 * pixelSize;
            int iconGroup =[self getIconGroup:[building objectForKey:@"iconGroup"]];
            
            mapTilesArray = [map.tileSet objectAtIndex:iconGroup];
            
            long startingPosition = imagesPerGroup * 2;
            
//            for (int j = 0; j < imagesPerGroup; j++) {
//                statements
//            }
            
            
            for (int k = 0; k < imagesPerGroup; k++) {
                frame = [sprites.imageFrames objectAtIndex:[[mapTilesArray objectAtIndex: startingPosition + k] integerValue]];
                unsigned char imageContent[frame.width * frame.height];
                [frame.imageData getBytes:&imageContent length:frame.imageData.length];
                
                for (int z = 0; z < frame.width * frame.height; z++) {
                    if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += [self getHouseNumber:house] << 4;
                }
                
                for (int x = 0; x < frame.width; x++) {
                    for (int y = 0; y < frame.height; y++) {
                        [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
                        if (imagesPerGroup == 6) {
                            NSRectFill(NSMakeRect(xPos + x * pixelSize  + (frame.width*pixelSize * (k%3)), yPos + (frame.height * (k<3?2:1) - y - 1) * pixelSize, pixelSize, pixelSize));
                        } else if (imagesPerGroup == 4) {
                            NSRectFill(NSMakeRect(xPos + x * pixelSize  + (frame.width*pixelSize * (k%2)), yPos + (frame.height * (k<2?2:1) - y - 1) * pixelSize, pixelSize, pixelSize));
                        } else if (imagesPerGroup == 9) {
                            NSRectFill(NSMakeRect(xPos + x * pixelSize  + (frame.width*pixelSize * (k%3)), yPos + (frame.height * (k<3?3:(k<6?2:1)) - y - 1) * pixelSize, pixelSize, pixelSize));
                        } else {
                            NSRectFill(NSMakeRect(xPos + x * pixelSize  + (frame.width*pixelSize * (k%3)), yPos + (frame.height * (k<3?2:1) - y - 1) * pixelSize, pixelSize, pixelSize));                           
                        }
                    }
                }
 //               z++;
            }
        }
    }
    
    [image unlockFocus];
    [_image setImage:image];
}

- (int) getHouseNumber:(NSString *)houseName {
    if ([houseName  isEqualToString:@"Harkonen"]) {
        return 0;
    } else if ([houseName  isEqualToString:@"Atreides"]) {
        return 1;
    } else if ([houseName  isEqualToString:@"Ordos"]) {
        return 2;
    } else if ([houseName  isEqualToString:@"Fremen"]) {
        return 3;
    } else if ([houseName  isEqualToString:@"Sardaukar"]) {
        return 4;
    } else if ([houseName  isEqualToString:@"Mercenary"]) {
        return 5;
    }
    return 0;
}

- (int) getIconGroup:(NSString *)stringValue {
    if ([stringValue  isEqualToString:@"ICM_ICONGROUP_ROCK_CRATERS"]) {
        return 1;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SAND_CRATERS"]) {
        return 2;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_FLY_MACHINES_CRASH"]) {
        return 3;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SAND_DEAD_BODIES"]) {
        return 4;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SAND_TRACKS"]) {
        return 5;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_WALLS"]) {
        return 6;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_FOG_OF_WAR"]) {
        return 7;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_CONCRETE_SLAB"]) {
        return 8;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_LANDSCAPE"]) {
        return 9;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SPICE_BLOOM"]) {
        return 10;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_HOUSE_PALACE"]) {
        return 11;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_LIGHT_VEHICLE_FACTORY"]) {
        return 12;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_HEAVY_VEHICLE_FACTORY"]) {
        return 13;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_HI_TECH_FACTORY"]) {
        return 14;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_IX_RESEARCH"]) {
        return 15;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_WOR_TROOPER_FACILITY"]) {
        return 16;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_CONSTRUCTION_YARD"]) {
        return 17;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_INFANTRY_BARRACKS"]) {
        return 18;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_WINDTRAP_POWER"]) {
        return 19;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_STARPORT_FACILITY"]) {
        return 20;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SPICE_REFINERY"]) {
        return 21;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_VEHICLE_REPAIR_CENTRE"]) {
        return 22;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_BASE_DEFENSE_TURRET"]) {
        return 23;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_BASE_ROCKET_TURRET"]) {
        return 24;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_SPICE_STORAGE_SILO"]) {
        return 25;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_RADAR_OUTPOST"]) {
        return 26;
    } else if ([stringValue  isEqualToString:@"ICM_ICONGROUP_EOF"]) {
        return 27;
    }
    return 0;
}


@end
