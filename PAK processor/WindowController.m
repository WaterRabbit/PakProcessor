//
//  WindowController.m
//  PAK processor
//
//  Created by id on 10/27/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "WindowController.h"
#import "UnknownTypeViewController.h"
#import "IniTypeViewController.h"
#import "CpsTypeViewController.h"
#import "PalTypeViewController.h"
#import "WsaTypeViewController.h"
#import "ShpTypeViewController.h"
#import "IcnTypeViewController.h"
#import "MapTypeViewController.h"
#import "IniSceneTypeViewController.h"
#import "TxtTypeViewController.h"

#import "Shp.h"
#import "Cps.h"


#import "NSImage+saveAsJpegWithName.h"
#import "Tools.h"

@interface WindowController ()

@end

@implementation WindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
//        _pakFileContents = [[NSMutableDictionary alloc] init];
//        _pakFiles = [[NSMutableArray alloc] init];
////        _paletteFiles = [[NSMutableDictionary alloc] init];
//        _fileContents = [[NSMutableDictionary alloc] init];
//        [_pakFiles addObjectsFromArray:];
        _pakProcessor = [[PakProcessor alloc] initWithFiles:[[NSBundle mainBundle] pathsForResourcesOfType:@"PAK" inDirectory:nil]];
//        for (NSString *file in _pakFiles) {
//            [self processSelectedPakFile:file];
//        }
        [_pakProcessor processFiles];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if ([tableView.identifier isEqualToString:@"Files"]) {
        return _pakProcessor.pakFiles.count;
    } else if ([tableView.identifier isEqualToString:@"FileContents"]) {
        if (_selectedPakFile == nil) {
            return 0;
        }
        return [(NSMutableArray *)[_pakProcessor.filesInPakFiles valueForKey:_selectedPakFile] count];
    }
    return 0;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableView.identifier isEqualToString:@"Files"]) {
        return [[_pakProcessor.pakFiles objectAtIndex:row] lastPathComponent];
    } else if ([tableView.identifier isEqualToString:@"FileContents"]) {
        return [(NSMutableArray *)[_pakProcessor.filesInPakFiles valueForKey:_selectedPakFile] objectAtIndex:row];
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([[notification.object identifier] isEqualToString:@"Files"]) {
        NSInteger row = [_pakFilesTableView selectedRow];
        if (row == -1 ) {
            _selectedPakFile = nil;
        } else {
            NSString *selectedFile = [_pakProcessor.pakFiles objectAtIndex:row];
            _selectedPakFile = selectedFile;
        }
        [_pakFileContentFilesTableView deselectAll:self];
        [_pakFileContentFilesTableView reloadData];
        [_pakFileContentFilesTableView scrollRowToVisible:0];

    } else if ([[notification.object identifier] isEqualToString:@"FileContents"]) {
        if (_controller != nil) {
            [_controllerView  removeFromSuperview];
            [[_controller view] removeFromSuperview];
            _controller = nil;
            _controllerView = nil;
        }
        NSInteger row = [_pakFileContentFilesTableView selectedRow];
        if (row == -1) {
            
        } else {
            NSString *selectedContentFile = [(NSMutableArray *)[_pakProcessor.filesInPakFiles valueForKey:_selectedPakFile] objectAtIndex:row];
            if ([[selectedContentFile pathExtension] isEqualToString:@"PAL"]) {
                PalTypeViewController *controller = [[PalTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                [controller setContentFromPalette:[_pakProcessor.fileContents valueForKey:selectedContentFile]];
            } else if ([[selectedContentFile pathExtension] isEqualToString:@"INI"]) {
                if ([selectedContentFile hasPrefix:@"SCEN"]) {
                    IniSceneTypeViewController *controller = [[IniSceneTypeViewController alloc] init];
                    _controller = controller;
                    _controllerView = [_controller view];
                    [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile] withSprites:[_pakProcessor.fileContents valueForKey:@"ICON.ICN"] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"] withMap:[_pakProcessor.fileContents valueForKey:@"ICON.MAP"]];
                } else {
                    IniTypeViewController *controller = [[IniTypeViewController alloc] init];
                    _controller = controller;
                    _controllerView = [_controller view];
                    [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile]];
                }
            } else if ([[selectedContentFile pathExtension] isEqualToString:@"MAP"]) {
                MapTypeViewController *controller = [[MapTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile]];
            } else if ([Tools isCPS:selectedContentFile]) {
                CpsTypeViewController *controller = [[CpsTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                NSString *paletteFile = @"IBM.PAL";
                if ([selectedContentFile isEqual:@"MENTATM.CPS"] || [selectedContentFile hasPrefix:@"MISC."]) {
                    paletteFile = @"BENE.PAL";
                }
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile] withPalette:[_pakProcessor.fileContents valueForKey:paletteFile]];
            } else if ([[selectedContentFile pathExtension] isEqualToString:@"WSA"]) {
                WsaTypeViewController *controller = [[WsaTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                NSString *paletteFile = @"IBM.PAL";
                if ([selectedContentFile isEqual:@"WESTWOOD.WSA"]) {
                    paletteFile = @"WESTWOOD.PAL";
                }
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile] withPalette:[_pakProcessor.fileContents valueForKey:paletteFile]];
            } else if ([[selectedContentFile pathExtension] isEqualToString:@"ICN"]) {
                IcnTypeViewController *controller = [[IcnTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"] withMap:[_pakProcessor.fileContents valueForKey:@"ICON.MAP"]];
            } else if ([Tools isSHP:selectedContentFile]) {
                ShpTypeViewController *controller = [[ShpTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                NSString *paletteFile = @"IBM.PAL";
                if ([selectedContentFile isEqual:@"MENSHPM.SHP"]) {
                    paletteFile = @"BENE.PAL";
                }
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile] withPalette:[_pakProcessor.fileContents valueForKey:paletteFile]];
            } else if ([Tools isTxt:selectedContentFile]) {
                 TxtTypeViewController *controller = [[TxtTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [_controller view];
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile]];
            } else {
                UnknownTypeViewController *controller = [[UnknownTypeViewController alloc] init];
                _controller = controller;
                _controllerView = [controller view];
                [controller setContent:[_pakProcessor.fileContents valueForKey:selectedContentFile]];
            }
            [_controllerView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            _controllerView.frame = CGRectMake(0, 0,
                                                CGRectGetWidth(_viewToReplace.bounds),
                                                CGRectGetHeight(_viewToReplace.bounds));
            [_viewToReplace addSubview:[_controller view]];
            [_viewToReplace setAutoresizesSubviews:YES];
            [_controllerView setAutoresizesSubviews:YES];
        }
    }
}
- (IBAction)GenerateMapSprites:(id)sender {
    [self generateSprites:[_pakProcessor.fileContents valueForKey:@"ICON.ICN"] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"] withMap:[_pakProcessor.fileContents valueForKey:@"ICON.MAP"]];
}

- (void)generateSprites:(Icn *)sprites withPalette:(Pal *)palette withMap:(Map *)map {
    int pixelSize = 1;
    NSArray *mapTilesArray;
    mapTilesArray = [map.tileSet objectAtIndex:9];
    ImageFrame *frame = [sprites.imageFrames objectAtIndex:0];
    
    for (int i = 0; i < mapTilesArray.count; i++) {
        NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height)];
        [image lockFocus];

        NSInteger frameIndex = [[mapTilesArray objectAtIndex:i] integerValue];
        frame = [sprites.imageFrames objectAtIndex:frameIndex];
//        int yPos = i/64;
//        int xPos = i%64;
        
        unsigned char imageContent[frame.width * frame.height];
        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
        
        //        for (int z = 0; z < frame.width * frame.height; z++) {
        //            if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
        //        }
        for (int y = 0; y < frame.height; y++) {
            for (int x = 0; x < frame.width; x++) {
                [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
                NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
            }
        }
        [image unlockFocus];
        
      //  [image saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/%ld.jpg", (long)frameIndex]];
    }
}


- (IBAction)GenerateTexts:(id)sender {
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"StructureInfos.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
    }
    
//    if ([fileName hasPrefix:@"DUNE"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:1 toKey:339] forKey:fileName];
//    } else if ([fileName hasPrefix:@"MESSAGE"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:340 toKey:367] forKey:fileName];
//    } else if ([fileName hasPrefix:@"INTRO"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:FALSE fromKey:368 toKey:404] forKey:fileName];
//    } else if ([fileName hasPrefix:@"TEXTH"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:405 toKey:444] forKey:fileName];
//    } else if ([fileName hasPrefix:@"TEXTA"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:445 toKey:484] forKey:fileName];
//    } else if ([fileName hasPrefix:@"TEXTO"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:485 toKey:524] forKey:fileName];
//    } else if ([fileName hasPrefix:@"PROTECT"]) {
//        [_fileContents setValue:[[Txt alloc] initFromData:data compressed:TRUE fromKey:525 toKey:-1] forKey:fileName];
//    }
   
    NSEnumerator *enumerator = [temp objectEnumerator];
    id value;
    

    
    Txt *txtContentEng = [_pakProcessor.fileContents valueForKey:@"DUNE.ENG"];
    Txt *txtContentGer = [_pakProcessor.fileContents valueForKey:@"DUNE.GER"];
    Txt *txtContentFre = [_pakProcessor.fileContents valueForKey:@"DUNE.FRE"];
    for (int i = 0; i<= 339; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i] forKey:@"French"];
            }
        }
    }
    
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"MESSAGE.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"MESSAGE.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"MESSAGE.FRE"];
    for (int i = 340; i<= 367; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-340] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-340] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-340] forKey:@"French"];
            }
        }
    }
    
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"INTRO.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"INTRO.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"INTRO.FRE"];
    for (int i = 368; i<= 404; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-368] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-368] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-368] forKey:@"French"];
            }
        }
    }
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"TEXTH.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"TEXTH.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"TEXTH.FRE"];
    for (int i = 405; i<= 444; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-405] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-405] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-405] forKey:@"French"];
            }
        }
    }
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"TEXTA.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"TEXTA.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"TEXTA.FRE"];
    for (int i = 445; i<= 484; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-445] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-445] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-445] forKey:@"French"];
            }
        }
    }
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"TEXTO.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"TEXTO.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"TEXTO.FRE"];
    for (int i = 485; i<= 524; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-485] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-485] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-485] forKey:@"French"];
            }
        }
    }
    txtContentEng = [_pakProcessor.fileContents valueForKey:@"PROTECT.ENG"];
    txtContentGer = [_pakProcessor.fileContents valueForKey:@"PROTECT.GER"];
    txtContentFre = [_pakProcessor.fileContents valueForKey:@"PROTECT.FRE"];
    for (int i = 525; i<= 525 + txtContentEng.strings.count - 1; i++) {
        enumerator = [temp objectEnumerator];
        while ((value = [enumerator nextObject])) {
            if ([[value objectForKey:@"Code"] integerValue] == i) {
                [value setValue:[txtContentEng.strings objectAtIndex:i-525] forKey:@"English"];
                [value setValue:[txtContentGer.strings objectAtIndex:i-525] forKey:@"German"];
                [value setValue:[txtContentFre.strings objectAtIndex:i-525] forKey:@"French"];
            }
        }
    }
    
    NSError *error;
    
    
    plistXML = [NSPropertyListSerialization  dataWithPropertyList:temp format:format options:NSPropertyListXMLFormat_v1_0 error:&error];
    if (![[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"/tmp/String.plist"] contents:plistXML attributes:nil]) {
        NSLog(@"false");
    }
}

- (IBAction)GenerateMentats:(id)sender {
    
    Cps *mentat = [_pakProcessor.fileContents valueForKey:@"MENTATA.CPS"];
    
    [[Tools generateImageFromFrame:[mentat.imageFrames objectAtIndex:0] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:@"/tmp/mentata.jpg"];
    mentat = [_pakProcessor.fileContents valueForKey:@"MENTATH.CPS"];
    
    [[Tools generateImageFromFrame:[mentat.imageFrames objectAtIndex:0] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:@"/tmp/mentath.jpg"];
    
    mentat = [_pakProcessor.fileContents valueForKey:@"MENTATO.CPS"];
    
    [[Tools generateImageFromFrame:[mentat.imageFrames objectAtIndex:0] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:@"/tmp/mentato.jpg"];
    
    mentat = [_pakProcessor.fileContents valueForKey:@"MENTATM.CPS"];
    
    [[Tools generateImageFromFrame:[mentat.imageFrames objectAtIndex:0] withPalette:[_pakProcessor.fileContents valueForKey:@"BENE.PAL"]]  saveAsJpegWithName:@"/tmp/mentatm.jpg"];
    
    Shp *shp = [_pakProcessor.fileContents valueForKey:@"MENSHPA.SHP"];
    
    for (int i = 0; i < shp.imageFrames.count; i++) {
        [[Tools generateImageFromFrame:[shp.imageFrames objectAtIndex:i] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/mentata_%d.png", i]];
    }
    
    shp = [_pakProcessor.fileContents valueForKey:@"MENSHPO.SHP"];
    
    for (int i = 0; i < shp.imageFrames.count; i++) {
        [[Tools generateImageFromFrame:[shp.imageFrames objectAtIndex:i] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/mentato_%d.png", i]];
    }
    
    shp = [_pakProcessor.fileContents valueForKey:@"MENSHPH.SHP"];
    
    for (int i = 0; i < shp.imageFrames.count; i++) {
        [[Tools generateImageFromFrame:[shp.imageFrames objectAtIndex:i] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/mentath_%d.png", i]];
    }
    
    shp = [_pakProcessor.fileContents valueForKey:@"MENSHPM.SHP"];
    
    for (int i = 0; i < shp.imageFrames.count; i++) {
        [[Tools generateImageFromFrame:[shp.imageFrames objectAtIndex:i] withPalette:[_pakProcessor.fileContents valueForKey:@"BENE.PAL"]]  saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/mentatm_%d.png", i]];
    }
}

- (IBAction)GenerateMentatHelpImages:(id)sender {
    
    
    NSArray *pakFiles = [[_pakProcessor.filesInPakFiles allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH %@", @"MENTAT.PAK"]];

    NSArray *files = [_pakProcessor.filesInPakFiles objectForKey:[pakFiles objectAtIndex:0]];
    
    NSString *str = @"";
    
    for (NSString *file in files) {
        Wsa *wsa = [_pakProcessor.fileContents valueForKey:file];
        for (int i = 0; i < wsa.imageFrames.count; i++) {
            [[Tools generateImageFromFrame:[wsa.imageFrames objectAtIndex:i] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"]]  saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/%@_%d.png", [[file stringByDeletingPathExtension] lowercaseString],  i]];
        
        }
        str = [str stringByAppendingString:[[NSString alloc] initWithFormat:@"%d", wsa.imageFrames.count]];
        str = [str stringByAppendingString:@", "];
    }
    
}

- (IBAction)GenerateUnitSprites:(id)sender {
    Shp *shp1 = [_pakProcessor.fileContents valueForKey:@"UNITS2.SHP"];
    Shp *shp2 = [_pakProcessor.fileContents valueForKey:@"UNITS1.SHP"];
    Shp *shp3 = [_pakProcessor.fileContents valueForKey:@"UNITS.SHP"];

    
//    [self generateSprites:[_pakProcessor.fileContents valueForKey:@"ICON.ICN"] withPalette:[_pakProcessor.fileContents valueForKey:@"IBM.PAL"] withMap:[_pakProcessor.fileContents valueForKey:@"ICON.MAP"]];
}

//- (void)generateSprites:(Icn *)sprites withPalette:(Pal *)palette withMap:(Map *)map {
//    int pixelSize = 1;
//    NSArray *mapTilesArray;
//    mapTilesArray = [map.tileSet objectAtIndex:9];
//    ImageFrame *frame = [sprites.imageFrames objectAtIndex:0];
//    
//    for (int i = 0; i < mapTilesArray.count; i++) {
//        NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(frame.width * pixelSize, frame.height)];
//        [image lockFocus];
//        
//        NSInteger frameIndex = [[mapTilesArray objectAtIndex:i] integerValue];
//        frame = [sprites.imageFrames objectAtIndex:frameIndex];
//        //        int yPos = i/64;
//        //        int xPos = i%64;
//        
//        unsigned char imageContent[frame.width * frame.height];
//        [frame.imageData getBytes:&imageContent length:frame.imageData.length];
//        
//        //        for (int z = 0; z < frame.width * frame.height; z++) {
//        //            if (imageContent[z] >= 0x90 && imageContent[z] <= 0x96) imageContent[z] += self.grphData.houseID << 4;
//        //        }
//        for (int y = 0; y < frame.height; y++) {
//            for (int x = 0; x < frame.width; x++) {
//                [(NSColor *)[palette.palette objectAtIndex:imageContent[y * frame.width + x]] set];
//                NSRectFill(NSMakeRect(x * pixelSize, (frame.height - y - 1) * pixelSize, pixelSize, pixelSize));
//            }
//        }
//        [image unlockFocus];
//        
//        //  [image saveAsJpegWithName:[NSString stringWithFormat:@"/tmp/%ld.jpg", (long)frameIndex]];
//    }
//}


@end
