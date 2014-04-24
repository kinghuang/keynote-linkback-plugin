/*
 *     Generated by class-dump 3.1.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2006 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>

@class NSArray, NSMutableSet, SFDCanvas, SFDPageRep;

@interface SFDSelectionController : NSObject
{
    SFDCanvas *mCanvas;
    NSMutableSet *mSelectedObjects;
    struct _NSRect mGeometricBounds;
    struct _NSRect mAlignmentBounds;
    SFDPageRep *mActivePage;
    NSArray *mDraggableObjects;
    BOOL mMultipleSelectionChangesMayBeHappening;
    BOOL mMultipleSelectionChangesHappened;
}

+ (BOOL)deletionIsPermittedWithManagedDrawableRelationshipsInArray:(id)fp8;
+ (BOOL)copyingIsPermittedWithManagedDrawableRelationshipsInArray:(id)fp8;
- (id)init;
- (void)dealloc;
- (void)selectionChanged;
- (void)beginMultipleSelectionChanges;
- (void)endMultipleSelectionChanges;
- (void)beginMarqueeUpdate;
- (void)endMarqueeUpdate;
- (void)setCanvas:(id)fp8;
- (id)canvas;
- (void)addToSelection:(id)fp8;
- (void)removeFromSelection:(id)fp8;
- (void)deselectAll;
- (void)deselectAllNotifyingCanvas:(BOOL)fp8;
- (void)setActivePage:(id)fp8;
- (id)activePage;
- (id)draggableObjects;
- (void)releaseDraggableObjects;
- (void)createDraggableObjectsFromPage:(id)fp8;
- (void)updateDraggableObjectsWithNewActivePage:(id)fp8;
- (id)selectedInfos;
- (id)unlockedSelectedInfos;
- (id)unlockedSelectedObjects;
- (id)selectedObjects;
- (struct _NSRect)geometricBoundsOfSelection;
- (struct _NSRect)alignmentBoundsOfSelection;
- (struct _NSRect)geometricBoundsOfDraggableObjects;
- (struct _NSRect)alignmentBoundsOfDraggableObjects;
- (struct _NSRect)alignmentBoundsOfUnlockedSelection;
- (BOOL)selectionContainsObjectOfClass:(Class)fp8;
- (id)selectedObjectsOfClass:(Class)fp8;
- (BOOL)selectionContainsUnlockedObject;
- (BOOL)selectionContainsLockedObject;
- (BOOL)selectionContainsObjectReplying:(BOOL)fp8 toSelector:(SEL)fp12;
- (id)selectedObjectsReplying:(BOOL)fp8 toSelector:(SEL)fp12;
- (void)dirtySelection;

@end
