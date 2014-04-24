//
//  BGCanvas_LinkBack.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005, 2007 King Chung Huang. All rights reserved.
//

#import "SFDCanvas_LinkBack.h"
#import "SFDDrawableInfo_Linkback.h"
#import "SFDSelectionController_LinkBack.h"
#import "SFDAffineGeometry.h"

static NSMutableDictionary *_activeLinksByCanvas = nil;

@implementation SFDCanvas (LinkBack)

+ (NSMutableDictionary *)_activeLinksByCanvas {
	if (_activeLinksByCanvas == nil) {
		_activeLinksByCanvas = [[NSMutableDictionary alloc] initWithCapacity:128];
	}
	
	return _activeLinksByCanvas;
}

#pragma mark LinkBackClientDelegate protocol

- (void)linkBackDidClose:(LinkBack *)link {
	[self removeActiveLink:link];
}

- (void)linkBackServerDidSendEdit:(LinkBack *)link {
	NSPasteboard *pasteboard = [link pasteboard];
	id newInfo, oldInfo;
	
	oldInfo = [link representedObject];
	newInfo = [self makeInfoFromPasteboard:pasteboard withStyle:[oldInfo style]];
	
	id lbd = [newInfo linkBackData];
	[newInfo setLinkBackData:nil];
	[newInfo setLinkBackKey:[oldInfo linkBackKey]];
	[newInfo setLinkBackData:lbd];
	
	NSEnumerator *properties = [[oldInfo styleProperties] objectEnumerator];
	id property, value;
	
	while (property = [properties nextObject]) {
		if ([oldInfo canInspectProperty:property]) {
			value = [oldInfo valueForProperty:property];
			
			if (value != nil && [newInfo canMutateProperty:property]) {
				[newInfo setValue:value forProperty:property];
			}
		}
	}
	
	SFDAffineGeometry *oldGeometry = [oldInfo geometry];
	
	NSSize oldNaturalSize = [oldInfo naturalSize];
	NSSize oldSize = [oldInfo size];
	
	NSSize newNaturalSize = [newInfo naturalSize];
	NSSize newSize = NSMakeSize(newNaturalSize.width * oldSize.width / oldNaturalSize.width, newNaturalSize.height * oldSize.height / oldNaturalSize.height);
	
	SFDAffineGeometry *newGeometry = [[SFDAffineGeometry alloc] initWithNaturalSize:newNaturalSize size:newSize sizesLocked:[oldGeometry sizesLocked] aspectRatioLocked:[oldGeometry aspectRatioLocked] position:[oldGeometry position] angleInDegrees:[oldGeometry angleInDegrees] horizontalFlip:[oldGeometry horizontalFlip] verticalFlip:[oldGeometry verticalFlip] shearXAngle:[oldGeometry shearXAngle] shearYAngle:[oldGeometry shearYAngle]];
	
	[newInfo setGeometry:newGeometry];
		
	id slide = [self performSelector:@selector(activeSlide)];
	
	[slide performSelector:@selector(removeDrawable:) withObject:oldInfo];
	[slide performSelector:@selector(addDrawable:) withObject:newInfo];
	
	[link setRepresentedObject:newInfo];
}

#pragma mark Managing LinkBacks

- (void)addActiveLink:(LinkBack *)link {
	if (link != nil)
		[[self activeLinks] addObject:link];
}

- (void)removeActiveLink:(LinkBack *)link {
	[[self activeLinks] removeObject:link];
}

- (NSMutableArray *)activeLinks {
	NSMutableArray *links = [[[self class] _activeLinksByCanvas] objectForKey:[self canvasKey]];
	
	if (links == nil) {
		links = [NSMutableArray arrayWithCapacity:8];
		
		[[[self class] _activeLinksByCanvas] setObject:links forKey:[self canvasKey]];
	}
	
	return links;
}

- (void)deallocLinks {
	NSMutableArray *links = [self activeLinks];
	
	if ([links count] > 0) {
		[links makeObjectsPerformSelector:@selector(closeLink)];
	}
	
	[[[self class] _activeLinksByCanvas] removeObjectForKey:[self canvasKey]];
}

- (NSNumber *)canvasKey {
	return [NSNumber numberWithUnsignedInt:(unsigned)self];
}

#pragma mark Starting a LinkBack

- (void)beginLinkBackForSelection:(id)sender {
	NSArray *infos = [[self selectionController] selectedLinkBackInfos];
	int idx = [infos count];
	
	while (--idx >= 0) {
		[self beginLinkBackForInfo:[infos objectAtIndex:idx] canvas:self];
	}
}

- (void)beginLinkBackForInfo:(SFDDrawableInfo *)info canvas:(SFDCanvas *)canvas {
	if ([info respondsToSelector:@selector(hasLinkBackData)] && [info performSelector:@selector(hasLinkBackData)]) {
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
