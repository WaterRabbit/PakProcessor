//
//  Txt.m
//  PAK processor
//
//  Created by id on 03/03/14.
//  Copyright (c) 2014 id. All rights reserved.
//

#import "Txt.h"
#import "FileReaders.h"

@implementation Txt

- (id)initFromData:(NSData *)data compressed:(BOOL)compressed fromKey:(NSInteger)fromKey toKey:(NSInteger)toKey {
    self = [super initFromData:data];
    if (self) {
        _strings = [[NSMutableArray  alloc] init];
        _fromKey = fromKey;
        _toKey = toKey;
        _compresed = compressed;
        [self decodeStrings];
    }
    return self;
}

- (void)decodeStrings {
    char * const s_stringDecompress = " etainosrlhcdupmtasio wb rnsdalmh ieorasnrtlc synstcloer dtgesionr ufmsw tep.icae oiadur laeiyodeia otruetoakhlr eiu,.oansrctlaileoiratpeaoip bm";
    int startIndex;
    long length;
    int count = [FileReaders Get16LEFromData:self.data atOffset:0] / 2;
    long end = _toKey;
    NSData *textData;
    NSString *text;
    
    if (end < 0) {
        end = _fromKey + count - 1;
    }
    for (int i = 0; i < count; i ++) {
        startIndex = [FileReaders Get16LEFromData:self.data atOffset:i * 2];
        if (i + 1 < count) {
            length = [FileReaders Get16LEFromData:self.data atOffset:(i + 1) * 2] - startIndex;
        } else {
            length = self.data.length - startIndex;
        }
        textData = [self.data subdataWithRange:NSMakeRange(startIndex, length)];
        if (_compresed) {
            text = @"";
            for (int j = 0;  j < textData.length; j++) {
                int c = [FileReaders Get8FromData:textData atOffset:j];
                if ((c & 0x80) != 0) {
                    c = c & 0x7f;
                    int c2 =  s_stringDecompress[c >> 3];
                    //                    if (c2 == 0x1B) {
                    //                        c2 = 0x7F + c;
                    //                    }
                    if (c2 > 0 ) {
                        text = [text stringByAppendingString:[NSString stringWithFormat:@"%c", c2]];
                    }
                    c = s_stringDecompress[c + 16];
                }
                //                if (c == 0x1B) {
                //                    c = 0x7F + c;
                //                }
                if (c> 0) {
                    text = [text stringByAppendingString:[NSString stringWithFormat:@"%c",  c]];
                }
            }
        } else  {
            text = [[NSString alloc]  initWithData:textData encoding:NSASCIIStringEncoding];
            text = [text substringToIndex:text.length - 1];
        }
        if (([[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) ||  ((i == 0) &&  (_fromKey == 1))) {
            [_strings addObject:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
//        if (text.length == 1) {
//            NSLog(@"%lu %@", (unsigned long)[text length], text);
//            [text characterAtIndex:0];
//        }
    }
}

@end
