//
//  BGCanvas_LinkBack.h
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005, 2007 King Chung Huang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LinkBack/LinkBack.h>

#import "SFDCanvas.h"

@class SFDDrawableInfo;

@interface SFDCanvas (LinkBack) <LinkBackClientDelegate>

#pragma mark LinkBackClientDelegate protocol

- (void)linkBackDidClose:(LinkBack *)link;
- (void)linkBackServerDidSendEdit:(LinkBack *)link;

#pragma mark Managing LinkBacks

- (void)addActiveLink:(LinkBack *)link;
- (void)removeActiveLink:(LinkBack *)link;
- (NSMutableArray *)activeLinks;
- (void)deallocLinks;
- (NSNumber *)canvasKey;

#pragma mark Starting a LinkBack

- (void)beginLinkBackForSelection:(id)sender;
- (void)beginLinkBackForInfo:(SFDDrawableInfo *)info canvas:(SFDCanvas *)canvas;

@end
