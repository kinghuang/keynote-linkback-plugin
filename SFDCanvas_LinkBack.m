//
//  BGCanvas_LinkBack.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import "SFDCanvas_LinkBack.h"

static NSMutableDictionary *activeLinksByCanvas = nil;

@implementation SFDCanvas (LinkBack)

+ (void)initialize {
	activeLinksByCanvas = [[NSMutableDictionary alloc] initWithCapacity:128];
}

- (void)linkBackDidClose:(LinkBack *)link {
	[self removeActiveLink:link];
}

- (void)linkBackServerDidSendEdit:(LinkBack *)link {
	NSPasteboard *pasteboard = [link pasteboard];
	id newInfo, oldInfo = [link representedObject];
	
	newInfo = [self makeInfoFromPasteboard:pasteboard withStyle:[oldInfo style]];
	
	//NSLog(@"[oldInfo style] = %@", [oldInfo style]);
	
	id lbd = [newInfo linkBackData];
	[newInfo setLinkBackData:nil];
	[newInfo setLinkBackKey:[oldInfo linkBackKey]];
	[newInfo setLinkBackData:lbd];

	NSEnumerator *mutableProperties = [[newInfo mutableProperties] objectEnumerator];
	id property;
	
	while (property = [mutableProperties nextObject]) {
		if ([oldInfo canInspectProperty:property]) {
			[newInfo setValue:[oldInfo valueForProperty:property] forProperty:property];
			//NSLog(@"setValue:%@ forProperty:%@", [oldInfo valueForProperty:property], property);
		}
	}
	
	id transform = [[oldInfo geometry] transform];
	NSSize natural = [[newInfo geometry] naturalSize];
	
	SFDAffineGeometry *geometry = [[SFDAffineGeometry alloc] initWithNaturalBounds:NSMakeRect(0, 0, natural.width, natural.height) transform:transform sizesLocked:NO aspectRatioLocked:YES];
	
	[newInfo setGeometry:geometry];
	
	id slide = [self activeSlide];
	[slide removeDrawable:oldInfo];
	[slide addDrawable:newInfo];
	
	[link setRepresentedObject:newInfo];
}

// Managing LinkBacks
- (void)addActiveLink:(LinkBack *)link {
	if (link != nil)
		[[self activeLinks] addObject:link];
}

- (void)removeActiveLink:(LinkBack *)link {
	[[self activeLinks] removeObject:link];
}

- (NSMutableArray *)activeLinks {
	NSMutableArray *links = [activeLinksByCanvas objectForKey:[self canvasKey]];
	
	if (links == nil) {
		links = [NSMutableArray arrayWithCapacity:8];
		
		[activeLinksByCanvas setObject:links forKey:[self canvasKey]];
	}
	
	return links;
}

- (void)deallocLinks {
	NSMutableArray *links = [self activeLinks];
	
	if ([links count] > 0) {
		[links makeObjectsPerformSelector:@selector(closeLink)];
	}
	
	[activeLinksByCanvas removeObjectForKey:[self canvasKey]];
}

- (NSNumber *)canvasKey {
	return [NSNumber numberWithUnsignedInt:(unsigned)self];
}

// Starting a LinkBack
- (void)beginLinkBackForSelection:(id)sender {
	NSArray *infos = [[self selectionController] selectedLinkBackInfos];
	int idx = [infos count];
	
	while (--idx >= 0) {
		[self beginLinkBackForInfo:[infos objectAtIndex:idx] canvas:self];
	}
}

- (void)beginLinkBackForInfo:(SFDDrawableInfo *)info canvas:(SFDCanvas *)canvas {
	if ([info respondsToSelector:@selector(hasLinkBackData)] && [info hasLinkBackData]) {
		id data = [info linkBackData];
		
		NSString *sourceName = [[[info storage] document] displayName];
		
		LinkBack *link = [LinkBack editLinkBackData:data sourceName:sourceName delegate:canvas itemKey:[info linkBackKey]];
		
		if (link) {
			[link setRepresentedObject:info];
			
			[canvas addActiveLink:link];
		}
	}
}


@end
