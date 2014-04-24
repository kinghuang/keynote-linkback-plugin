//
//  SFDDrawableInfo_LinkBack.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import "SFDDrawableInfo_LinkBack.h"

static NSMutableDictionary *linkBackDataByInfo = nil;
static NSMutableDictionary *linkBackKeysByInfo = nil;

@implementation SFDDrawableInfo_LinkBack

+ (void)initialize {
	linkBackDataByInfo = [[NSMutableDictionary alloc] initWithCapacity:256];
	linkBackKeysByInfo = [[NSMutableDictionary alloc] initWithCapacity:256];
}

- (void)dealloc {
	[linkBackDataByInfo removeObjectForKey:[self linkBackKey]];
	
	[super dealloc];
}

// SFArchiving
- (id)initWithXMLUnarchiver:(SFAXMLUnarchiver *)unarchiver node:(struct _xmlNode *)node {
	if (self = [super initWithXMLUnarchiver:unarchiver node:node]) {
		xmlNode *cur_node = node->children;
		NSData *lbd = nil;
		
		for (cur_node = node->children; cur_node && (lbd == nil); cur_node = cur_node->next) {
			if (cur_node->type == XML_ELEMENT_NODE && strcmp(cur_node->name, "LinkBackData") == 0) {
				lbd = [unarchiver createObjectOfClass:[NSData class] fromNode:cur_node];
			}
		}
		
		if (lbd != nil) {
			[self setLinkBackData:[NSPropertyListSerialization propertyListFromData:lbd mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil]];
		}
	}

	return self;
}

- (void)encodeWithXMLArchiver:(SFAXMLArchiver *)archiver node:(struct _xmlNode *)node {
	[super encodeWithXMLArchiver:archiver node:node];
	
	id lbd = [self linkBackData];
	
	if (lbd != nil) {
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:lbd format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
		
		if (data != nil) {
			[archiver encodeObject:data asChildOf:node withName:"LinkBackData" xmlNamespace:nil];
		}
	}
}

// Link Back
- (BOOL)hasLinkBackData {
	return ([self linkBackData] != nil);
}

- (id)linkBackData {
	return [linkBackDataByInfo objectForKey:[self linkBackKey]];
}

- (void)setLinkBackData:(id)data {
	if (data != nil) {
		[linkBackDataByInfo setObject:data forKey:[self linkBackKey]];
	} else {
		[linkBackDataByInfo removeObjectForKey:[self linkBackKey]];
	}
}

- (NSString *)linkBackKey {
	NSString *key = [linkBackKeysByInfo objectForKey:[NSString stringWithFormat:@"%u", (unsigned)self]];

	if (key == nil) {
		key = LinkBackUniqueItemKey();
		
		[self setLinkBackKey:key];
	}
	
	return key;
}

- (void)setLinkBackKey:(NSString *)key {
	[linkBackKeysByInfo setObject:key forKey:[NSString stringWithFormat:@"%u", (unsigned)self]];
}



@end
