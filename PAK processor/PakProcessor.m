//
//  PakProcessor.m
//  PAK processor
//
//  Created by id on 11/2/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "PakProcessor.h"

#import "Pal.h"
#import "Ini.h"
#import "Cps.h"
#import "Wsa.h"
#import "Shp.h"
#import "Icn.h"
#import "Map.h"
#import "Tools.h"
#import "IniScene.h"
#import "Txt.h"

@implementation PakProcessor

- (id)init {
    NSException *initExeption = [[NSException alloc] initWithName:@"Can not init" reason:@"Use initWithFiles" userInfo:nil];
    [initExeption raise];
    return nil;
}

- (id)initWithFiles:(NSArray *) fileNames {
    self = [super init];
    if (self) {
        _pakFiles = fileNames;
        _filesInPakFiles = [[NSMutableDictionary alloc] init];
        _fileContents = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)processFiles {
    _filesInPakFiles = [[NSMutableDictionary alloc] init];
    _fileContents = [[NSMutableDictionary alloc] init];
    for (NSString *fileName in _pakFiles) {
        [self processSelectedPakFile:fileName];
    }
}

- (NSData *)processFileContent:(NSString *)file atOffset:(unsigned long long)offset withLength:(unsigned long)length {
    NSData *result;
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForReadingAtPath:file];
    [handle seekToFileOffset:offset];
    result = [handle readDataOfLength:length];
    [handle closeFile];
    return result;
}

- (void)processSelectedPakFile:(NSString *)processingFile {
    NSFileHandle *handle;
    int nextPosition;
    int position;
    int i;
    long filesize;
    long size;
    char filename[256];
    NSString *fileName;
    NSData *data;
    
    handle = [NSFileHandle fileHandleForReadingAtPath:processingFile];
    filesize = [[[NSFileManager defaultManager] attributesOfItemAtPath:processingFile error:nil] fileSize];
    data = [handle readDataOfLength:4];
    if (data == nil) {
        [handle closeFile];
        return;
    }
    [data getBytes:&nextPosition length:4];
    
    [_filesInPakFiles setValue:[[NSMutableArray alloc] init] forKey:processingFile];
    
    while (nextPosition != 0) {
        position = nextPosition;
        for (i = 0; i < sizeof(filename); i++) {
            data = [handle readDataOfLength:1];
            if (data == nil) {
                [handle closeFile];
                return;
            }
            [data getBytes:&filename[i] length:1];
            if (filename[i] == '\0') {
                break;
            }
        }
        if (i == sizeof(filename)) {
            [handle closeFile];
            return;
        }
        data = [handle readDataOfLength:4];
        if (data == nil) {
            [handle closeFile];
            return;
        }
        [data getBytes:&nextPosition length:4];
        size = (nextPosition != 0) ? nextPosition - position : filesize - position;
        
        fileName = [[NSString alloc] initWithCString:filename encoding:NSASCIIStringEncoding];
//        NSLog(@"%@", fileName);
        data = [self processFileContent:processingFile atOffset:position withLength:size];
        if ([[fileName pathExtension] isEqual:@"PAL"]) {
            [_fileContents setValue:[[Pal alloc] initFromData:data] forKey:fileName];
        } else if ([[fileName pathExtension] isEqual:@"INI"]) {
            if ([fileName hasPrefix:@"SCEN"]) {
                [_fileContents setValue:[[IniScene alloc] initFromData:data] forKey:fileName];
            } else {
                [_fileContents setValue:[[Ini alloc] initFromData:data] forKey:fileName];
            }
        } else if ([Tools isCPS:fileName]) {
            [_fileContents setValue:[[Cps alloc] initFromData:data] forKey:fileName];
        } else if ([[fileName pathExtension] isEqual:@"WSA"]) {
            if ([fileName isEqual:@"INTRO7B.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"INTRO7A.WSA"] getLastFrame]] forKey:fileName];
            } else if ([fileName isEqual:@"INTRO8B.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"INTRO8A.WSA"] getLastFrame]] forKey:fileName];
            } else if ([fileName isEqual:@"INTRO8C.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"INTRO8B.WSA"] getLastFrame]] forKey:fileName];
            } else if ([fileName isEqual:@"HFINALC.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"HFINALB.WSA"] getLastFrame]] forKey:fileName];
            } else if ([fileName isEqual:@"OFINALB.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"OFINALA.WSA"] getLastFrame]] forKey:fileName];
            }  else if ([fileName isEqual:@"OFINALC.WSA"]) {
                [_fileContents setValue:[[Wsa alloc] initFromData:data withFrame:[[_fileContents  valueForKey:@"OFINALB.WSA"] getLastFrame]] forKey:fileName];
            } else {
                [_fileContents setValue:[[Wsa alloc] initFromData:data] forKey:fileName];
            }
        } else if ([[fileName pathExtension] isEqual:@"ICN"]) {
            Icn *icnData = [[Icn alloc] initFromData:data];
            [icnData setCanSelectHouse:true];
            [_fileContents setValue:icnData forKey:fileName];
        } else if ([[fileName pathExtension] isEqual:@"MAP"]) {
            [_fileContents setValue:[[Map alloc] initFromData:data] forKey:fileName];
        } else if ([Tools isSHP:fileName]) {
            if ([fileName isEqual:@"CREDIT12.SHP"] ||[fileName isEqual:@"CREDIT13.SHP"]||[fileName isEqual:@"CREDIT14.SHP"]||[fileName isEqual:@"CREDIT15.SHP"]) {
                continue;
            }
            Shp *shpData = [[Shp alloc] initFromData:data];
            if ([fileName isEqual:@"UNITS.SHP"] ||[fileName isEqual:@"UNITS1.SHP"]||[fileName isEqual:@"UNITS2.SHP"]) {
                [shpData setCanSelectHouse:true];
            }
            [_fileContents setValue:shpData forKey:fileName];
        } else if ([Tools isTxt:fileName]) {
            if ([fileName hasPrefix:@"DUNE"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:1 toKey:339] forKey:fileName];
            } else if ([fileName hasPrefix:@"MESSAGE"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:340 toKey:367] forKey:fileName];
            } else if ([fileName hasPrefix:@"INTRO"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:368 toKey:404] forKey:fileName];
            } else if ([fileName hasPrefix:@"TEXTH"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:405 toKey:444] forKey:fileName];
            } else if ([fileName hasPrefix:@"TEXTA"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:445 toKey:484] forKey:fileName];
            } else if ([fileName hasPrefix:@"TEXTO"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:485 toKey:524] forKey:fileName];
            } else if ([fileName hasPrefix:@"PROTECT"]) {
                [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:525 toKey:-1] forKey:fileName];
            }
        } else {
            [_fileContents setValue:data forKey:fileName];
        }
        [[_filesInPakFiles valueForKey:processingFile] addObject:fileName];
    }
    [handle closeFile];
}

@end
