/*
 *     Generated by class-dump 3.1.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2006 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>

@interface SFRSubviewAbsolverView : NSView
{
    NSArray *mSavedSubviews;
    BOOL mSubviewsSetAside;
}

- (id)initWithFrame:(struct _NSRect)fp8;
- (void)layoutIfNeeded;
- (void)addSubview:(id)fp8;
- (void)addSubview:(id)fp8 positioned:(int)fp12 relativeTo:(id)fp16;

@end

