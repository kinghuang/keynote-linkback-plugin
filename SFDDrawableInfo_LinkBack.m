//
//  SFDDrawableInfo_LinkBack.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005, 2007 King Chung Huang. All rights reserved.
//

#import "SFDDrawableInfo_LinkBack.h"
#import <LinkBack/LinkBack.h>

@implementation SFDDrawableInfo (LinkBack)

static NSMutableDictionary *_linkBackDataByInfo = nil;
static NSMutableDictionary *_linkBackKeysByInfo = nil;

+ (NSMutableDictionary *)_linkBackDataByInfo {
	if (_linkBackDataByInfo == nil) {
		_linkBackDataByInfo = [[NSMutableDictionary alloc] initWithCapacity:128];
	}
	
	return _linkBackDataByInfo;
}

+ (NSMutableDictionary *)_linkBackKeysByInfo {
	if (_linkBackKeysByInfo == nil) {
		_linkBackKeysByInfo = [[NSMutableDictionary alloc] initWithCapacity:128];
	}
	
	return _linkBackKeysByInfo;
}

- (void)deallocLinkBack {
	[self setLinkBackData:nil];
	[self setLinkBackKey:nil];
}

- (BOOL)hasLinkBackData {
	return ([self linkBackData] != nil);
}

- (id)linkBackData {
	return [[[self class] _linkBackDataByInfo] objectForKey:[self linkBackKey]];
}

- (void)setLinkBackData:(id)data {
	if (data != nil) {
		[[[self class] _linkBackDataByInfo] setObject:data forKey:[self linkBackKey]];
	} else {
		[[[self class] _linkBackDataByInfo] removeObjectForKey:[self linkBackKey]];
	}
}

- (NSString *)linkBackKey {
	NSString *key = [[[self class] _linkBackKeysByInfo] objectForKey:[NSString stringWithFormat:@"%u", (unsigned)self]];

	if (key == nil) {
		key = LinkBackUniqueItemKey();
		
		[self setLinkBackKey:key];
	}
	
	return key;
}

- (void)setLinkBackKey:(NSString *)key {
	if (key != nil) {
		[[[self class] _linkBackKeysByInfo] setObject:key forKey:[NSString stringWithFormat:@"%u", (unsigned)self]];
	} else {
		[[[self class] _linkBackKeysByInfo] removeObjectForKey:[NSString stringWithFormat:@"%u", (unsigned)self]];
	}
	
}

@end
