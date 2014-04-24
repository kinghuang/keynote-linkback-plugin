//
//  BGCanvas_LinkBack.h
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SFDrawables/SFDrawables.h>
#import <LinkBack/LinkBack.h>

@interface SFDCanvas (LinkBack) <LinkBackClientDelegate>

// LinkBackClientDelegate
- (void)linkBackDidClose:(LinkBack *)link;
- (void)linkBackServerDidSendEdit:(LinkBack *)link;

// Managing LinkBacks
- (void)addActiveLink:(LinkBack *)link;
- (void)removeActiveLink:(LinkBack *)link;
- (NSArray *)activeLinks;
- (void)deallocLinks;
- (NSNumber *)canvasKey;

// Starting a LinkBack
- (void)beginLinkBackForSelection:(id)sender;
- (void)beginLinkBackForInfo:(SFDDrawableInfo *)info canvas:(SFDCanvas *)canvas;

@end
