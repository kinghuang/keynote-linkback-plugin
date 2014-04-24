//
//  SFDSelectionController_LinkBack.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/30/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import "SFDSelectionController_LinkBack.h"


@implementation SFDSelectionController (LinkBack)

- (NSArray *)selectedLinkBackInfos {
	NSArray *selectedInfos = [self selectedInfos];
	NSMutableArray *linkBackInfos = [NSMutableArray arrayWithCapacity:[selectedInfos count]];
	
	NSEnumerator *infos = [selectedInfos objectEnumerator];
	SFDDrawableInfo *info;
	
	while (info = [infos nextObject]) {
		if ([info hasLinkBackData]) {
			[linkBackInfos addObject:info];
		}
	}
	
	return linkBackInfos;
}

@end
