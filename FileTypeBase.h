//
//  FileTypeBase.h
//  PAK processor
//
//  Created by id on 11/13/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTypeBase : NSObject

@property NSData *data;

- (id)initFromData:(NSData *)data;

@end
