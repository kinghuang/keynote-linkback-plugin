/*
 *     Generated by class-dump 3.1.1.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2006 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>

@class NSBezierPath, NSString, NSURL, SFDAffineGeometry, SFSStyle;

@interface SFDDrawableInfo : NSObject
{
    SFDAffineGeometry *mRelativeGeometry;
    SFSStyle *mStyle;
    BOOL mIsLocked;
    NSURL *mURL;
    NSString *mName;
    NSBezierPath *mExteriorWrapPath;
    SFDAffineGeometry *mLastGeometryUsedForWrap;
    id mStorage;
    id mLayer;
    id mDrawableContainer;
    SFDAffineGeometry *mGeometry;
    unsigned int mUsageCount;
    BOOL mIsManaging;
    unsigned int mIsEditing;
    BOOL mExteriorWrapInvalid;
    BOOL mExteriorWrapPathFromArchive;
    SFDAffineGeometry *mArchivedContainerGeometry;
}

+ (Class)preferredStyleClass;
+ (BOOL)acceptsNilStyles;
+ (id)createAnonymousStyleWithParentIdentifier:(id)fp8 stylesheet:(id)fp12;
- (id)initWithGeometry:(id)fp8 style:(id)fp12;
- (id)init;
- (void)dealloc;
- (BOOL)isEqual:(id)fp8;
- (unsigned int)hash;
- (id)description;
- (id)style;
- (void)setStyle:(id)fp8;
- (BOOL)isLocked;
- (void)setIsLocked:(BOOL)fp8;
- (void)setIsLocked:(BOOL)fp8 applyToStyle:(BOOL)fp12;
- (id)URL;
- (void)setURL:(id)fp8;
- (id)name;
- (void)setName:(id)fp8;
- (id)storage;
- (void)setStorage:(id)fp8;
- (id)layer;
- (void)setLayer:(id)fp8;
- (BOOL)isAttached;
- (id)owningAttachment;
- (void)setOwningAttachment:(id)fp8;
- (id)containingInfo;
- (void)setContainingInfo:(id)fp8;
- (void)setContainingInfoAndRegisterForUndo:(id)fp8;
- (id)topmostContainingInfo;
- (id)drawableContainer;
- (void)setDrawableContainer:(id)fp8;
- (void)setDrawableContainer:(id)fp8 postingNotification:(BOOL)fp12;
- (id)geometricContainer;
- (id)relativeGeometry;
- (void)setRelativeGeometry:(id)fp8 registerUndo:(BOOL)fp12;
- (void)setRelativeGeometry:(id)fp8;
- (id)geometry;
- (void)setGeometry:(id)fp8 registerUndo:(BOOL)fp12;
- (void)setGeometry:(id)fp8;
- (id)geometryRelativeToObject:(id)fp8;
- (void)geometricContainerPropertiesChanged:(id)fp8;
- (struct _NSSize)naturalSize;
- (BOOL)sizesLocked;
- (struct _NSSize)size;
- (void)setSize:(struct _NSSize)fp8;
- (BOOL)aspectRatioLocked;
- (void)setAspectRatioLocked:(BOOL)fp8;
- (struct _NSPoint)position;
- (void)setPosition:(struct _NSPoint)fp8;
- (BOOL)horizontalFlip;
- (void)setHorizontalFlip:(BOOL)fp8;
- (BOOL)verticalFlip;
- (void)setVerticalFlip:(BOOL)fp8;
- (float)angleInDegrees;
- (void)setAngleInDegrees:(float)fp8;
- (float)angleInRadians;
- (void)setAngleInRadians:(float)fp8;
- (void)setAngleAboutFixedPointInDegrees:(float)fp8;
- (BOOL)canAutoSize;
- (void)setCanAutoSize:(BOOL)fp8;
- (struct _NSSize)minimumSize;
- (BOOL)validateSize:(struct _NSSize)fp8;
- (struct _NSRect)naturalBounds;
- (struct _NSRect)bounds;
- (id)transform;
- (id)geometryProperties;
- (id)geometryPropertiesAffectingTransform;
- (id)styleProperties;
- (id)propertiesAffectingExteriorWrap;
- (unsigned int)usageCount;
- (void)incrementUsageCount;
- (void)decrementUsageCount;
- (void)beginEditing;
- (void)undoableBeginEditing;
- (void)endEditing;
- (void)undoableEndEditing;
- (BOOL)isEditing;
- (void)processEditing;
- (void)adoptStylesheet:(id)fp8 styleMap:(id)fp12;
- (BOOL)canClearStyleOverrides;
- (void)clearStyleOverrides;
- (id)undoManager;
- (void)sendChangeNotificationForProperty:(id)fp8;
- (void)sendChangeNotificationForProperties:(id)fp8;
- (Class)preferredRepClass;
- (struct _NSRect)wrapBounds;
- (id)interiorWrapPath;
- (id)exteriorWrapPath;
- (id)buildExteriorWrapPath;
- (id)buildExteriorWrapPathWithParameters:(id)fp8;
- (void)invalidateExteriorWrapPath;
- (id)document;
- (id)inspectableProperties;
- (id)mutableProperties;
- (BOOL)canInspectProperty:(id)fp8;
- (BOOL)canMutateProperty:(id)fp8;
- (BOOL)isStateMixedForProperty:(id)fp8;
- (id)valueForProperty:(id)fp8 withScope:(id)fp12;
- (id)valueForProperty:(id)fp8;
- (id)valuesForProperty:(id)fp8 withScope:(id)fp12;
- (id)valuesForProperty:(id)fp8;
- (void)setValue:(id)fp8 forProperty:(id)fp12 withScope:(id)fp16;
- (void)setValue:(id)fp8 forProperty:(id)fp12;
- (void)setValuesForProperties:(id)fp8 withScope:(id)fp12;
- (void)setValuesForProperties:(id)fp8;
- (BOOL)validateValue:(id)fp8 forProperty:(id)fp12;
- (BOOL)canMutateViaAction:(id)fp8;
- (void)mutateViaAction:(id)fp8 arguments:(id)fp12;
- (void)stylePropertiesChanged:(id)fp8;
- (BOOL)supportsDashedLineStyle;
- (id)sfxFilters;
- (id)sfxLocalizedDeliveryOptionsForFilter:(id)fp8;
- (int)numberOfAnimationChunksWithChunkingStyle:(int)fp8;
- (BOOL)reverseChunkingIsSupported;
- (void)scaleBy:(double)fp8 withOffset:(struct _NSPoint)fp16 alreadyScaledObjects:(id)fp24;
- (id)topLevelGroup;
- (struct _NSPoint)inlineRelativeGeometryPosition;
- (id)managedDrawables;
- (id)managingDrawable;
- (BOOL)isManaged;
- (BOOL)containsManaged;
- (BOOL)canManage;
- (BOOL)isManaging;
- (void)setIsManaging:(BOOL)fp8;
- (BOOL)isBeingManaged;
- (void)setIsBeingManaged:(BOOL)fp8;
- (void)disableIsManaging;
- (void)disableIsBeingManaged;
- (void)enableIsManaging;
- (void)enableIsBeingManaged;
- (void)willBeRemovedFromDocument;
- (void)wasAddedToDocument;
- (id)associatedDrawables;
- (id)placeholderGeometry;
- (void)setPlaceholderGeometry:(id)fp8;
- (void)updateMotionPaths;
- (BOOL)canApplyImageFilters;

@end
