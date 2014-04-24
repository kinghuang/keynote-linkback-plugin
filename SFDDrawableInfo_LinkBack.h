//
//  SFDDrawableInfo_LinkBack.h
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SFArchiving/SFArchiving.h>
#import <SFDrawables/SFDrawables.h>
#import <libxml/tree.h>

@interface SFDDrawableInfo_LinkBack : SFDDrawableInfo

// SFArchiving
- (id)initWithXMLUnarchiver:(SFAXMLUnarchiver *)unarchiver node:(struct _xmlNode *)node;
- (void)encodeWithXMLArchiver:(SFAXMLArchiver *)archiver node:(struct _xmlNode *)node;

// Link Back
- (BOOL)hasLinkBackData;
- (id)linkBackData;
- (void)setLinkBackData:(id)data;
- (NSString *)linkBackKey;
- (void)setLinkBackKey:(NSString *)key;

@end
