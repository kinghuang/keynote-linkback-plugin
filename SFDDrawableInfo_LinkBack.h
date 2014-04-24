//
//  SFDDrawableInfo_LinkBack.h
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005, 2007 King Chung Huang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SFDDrawableInfo.h"

@class SFAXMLUnarchiver, SFAXMLArchiver;

@interface SFDDrawableInfo (LinkBack)

- (BOOL)hasLinkBackData;
- (id)linkBackData;
- (void)setLinkBackData:(id)data;
- (NSString *)linkBackKey;
- (void)setLinkBackKey:(NSString *)key;

@end