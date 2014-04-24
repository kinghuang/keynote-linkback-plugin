//
//  K2LinkBackSupport.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005 King Chung Huang. All rights reserved.
//

#import "K2LinkBackSupport.h"
#import "SFDDrawableInfo_LinkBack.h"
#import "SFDCanvas_LinkBack.h"

#import "APELite.h"
#include <unistd.h>
#include <mach-o/dyld.h>
#import <LinkBack/LinkBack.h>

struct objc_method {
	char *method_name;
	char *method_types;
	void *method_imp;
};

extern struct objc_method *class_getInstanceMethod(void *inClass, void *selector);

typedef void *(*BGC_makeInfoFromPasteboardProcPtr)(void *inObj, char *inSel, NSPasteboard *pasteboard, BOOL style);
typedef void (*NSO_deallocProcPtr)(void *inObj, char *inSel);
typedef void (*BGC_beginEditingRepWithEventProcPtr)(void *inObj, char *inSel, id rep, NSEvent *event);
typedef BOOL (*SFDRep_isEditableProcPtr)(void *inObj, char *inSel);
typedef void *(*SLPC_drawablesFromPasteboard1ProcPtr)(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, BOOL unformatted, BOOL stylesOnly, id drawablesController, char *returningWasNative, id *errors);
typedef void *(*SLPC_drawablesFromPasteboard2ProcPtr)(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, id targetController, char *returningWasNative, id *errors);
typedef void *(*SLDC_importDrawablesFromPasteboard1ProcPtr)(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, BOOL includeFormatting, id *errors);
typedef void *(*SLDC_importDrawablesFromPasteboard2ProcPtr)(void *inObj, char *inSel, NSPasteboard *pasteboard, id importableTypes, BOOL includeFormatting, id *errors);
typedef void (*SLDAPC_beginEditingRepWithEventProcPtr)(void *inObj, char *inSel, id rep, NSEvent *event);
typedef void (*SLC_beginEditingDrawableProcPtr)(void *inObj, char *inSel, id drawable);
typedef void (*SLPC_beginEditingDrawableProcPtr)(void *inObj, char *inSel, id drawable);
typedef void (*SLDA_initiateEditingAtStoragePositionProcPtr)(void *inObj, char *inSel, id fp8);
typedef BOOL (*BGC_validateMenuItemProcPtr)(void *inObj, char *inSel, NSMenuItem *cell);

BGC_makeInfoFromPasteboardProcPtr gBGC_makeInfoFromPasteboard = NULL;
NSO_deallocProcPtr gBGC_dealloc = NULL;
BGC_beginEditingRepWithEventProcPtr gBGC_beginEditingRepWithEvent = NULL;
SFDRep_isEditableProcPtr gSFDImageRep_editable = NULL;
SLPC_drawablesFromPasteboard1ProcPtr gSLPC_drawablesFromPasteboard1 = NULL;
SLPC_drawablesFromPasteboard2ProcPtr gSLPC_drawablesFromPasteboard2 = NULL;
SLDC_importDrawablesFromPasteboard1ProcPtr gSLDC_importDrawablesFromPasteboard1 = NULL;
SLDC_importDrawablesFromPasteboard2ProcPtr gSLDC_importDrawablesFromPasteboard2 = NULL;
SLDAPC_beginEditingRepWithEventProcPtr gSLDAPC_beginEditingRepWithEvent = NULL;
SLC_beginEditingDrawableProcPtr gSLC_beginEditingDrawable = NULL;
SLPC_beginEditingDrawableProcPtr gSLPC_beginEditingDrawable = NULL;
SLDA_initiateEditingAtStoragePositionProcPtr gSLDA_initiateEditingAtStoragePosition = NULL;
BGC_validateMenuItemProcPtr gBGC_validateMenuItem = NULL;

NSArray *retainer = NULL;

void *LB_BGC_makeInfoFromPasteboard(void *inObj, char *inSel, NSPasteboard *pasteboard, BOOL style) {
	id info = gBGC_makeInfoFromPasteboard(inObj, inSel, pasteboard, style);
	
	if ([info respondsToSelector:@selector(setLinkBackData:)] && [[pasteboard types] containsObject:LinkBackPboardType]) {
		id lbd = [pasteboard propertyListForType:LinkBackPboardType];
		
		[info takeValue:lbd forKey:@"linkBackData"];
	}
	
	return info;
}

void *LB_BGC_dealloc(void *inObj, char *inSel) {
	id canvas = inObj;
	
	[canvas deallocLinks];
	
	gBGC_dealloc(inObj, inSel);
}

void *LB_BGC_beginEditingRepWithEvent(void *canvas, char *inSel, id rep, NSEvent *event) {
	id info = [rep info];
	
	if ([info respondsToSelector:@selector(hasLinkBackData)] && [info hasLinkBackData]) {
		[canvas beginLinkBackForInfo:info canvas:[rep canvas]];
	} else {
		gBGC_beginEditingRepWithEvent(canvas, inSel, rep, event);
	}
}

BOOL LB_SFDImageRep_editable(void *inObj, char *inSel) {
	id info = [inObj info];
	
	if ([info respondsToSelector:@selector(hasLinkBackData)] && [info hasLinkBackData]) {
		//NSLog(@"SFDImageRep isEditable = YES");
		return YES;
	} else {
		//NSLog(@"SFDImageRep isEditable = OTHER");
		return gSFDImageRep_editable(inObj, inSel);
	}
}

void *LB_SLPC_drawablesFromPasteboard1(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, BOOL unformatted, BOOL stylesOnly, id drawablesController, char *returningWasNative, id *errors) {
	NSLog(@"drawablesFromPasteboard1:%@ type:%@", pasteboard, type);
	
	return gSLPC_drawablesFromPasteboard1(inObj, inSel, pasteboard, type, unformatted, stylesOnly, drawablesController, returningWasNative, errors);
}

void *LB_SLPC_drawablesFromPasteboard2(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, id targetController, char *returningWasNative, id *errors) {
	NSLog(@"drawablesFromPasteboard2:%@ type:%@", pasteboard, type);
	
	return gSLPC_drawablesFromPasteboard2(inObj, inSel, pasteboard, type, targetController, returningWasNative, errors);
}

void *LB_SLDC_importDrawablesFromPasteboard1(void *inObj, char *inSel, NSPasteboard *pasteboard, id type, BOOL includeFormatting, id *errors) {
	NSLog(@"importDrawablesFromPasteboard1:");
	
	id drawables = gSLDC_importDrawablesFromPasteboard1(inObj, inSel, pasteboard, type, includeFormatting, errors);
	NSEnumerator *infos = [drawables objectEnumerator];
	id info;
	
	while (info = [infos nextObject]) {
		if ([info respondsToSelector:@selector(setLinkBackData:)] && [[pasteboard types] containsObject:LinkBackPboardType]) {
			NSLog(@"setting LinkBack data");
			
			id lbd = [pasteboard propertyListForType:LinkBackPboardType];
			
			[info takeValue:lbd forKey:@"linkBackData"];
		}
	}
	
	return drawables;
}

void *LB_SLDC_importDrawablesFromPasteboard2(void *inObj, char *inSel, NSPasteboard *pasteboard, id importableTypes, BOOL includeFormatting, id *errors) {
	NSLog(@"importDrawablesFromPasteboard2:%@ importableTypes:%@", pasteboard, importableTypes);
	
	return gSLDC_importDrawablesFromPasteboard2(inObj, inSel, pasteboard, importableTypes, includeFormatting, errors);
}

void *LB_LSDAPC_beginEditingRepWithEvent(void *inObj, char *inSel, id rep, NSEvent *event) {
	NSLog(@"beginEditingRep:%@ withEvent:%@", rep, event);
	
	gSLDAPC_beginEditingRepWithEvent(inObj, inSel, rep, event);
}

void *LB_SLC_beginEditingDrawable(void *inObj, char *inSel, id drawable) {
	NSLog(@"beginEditingDrawable:%@", drawable);
	
	gSLC_beginEditingDrawable(inObj, inSel, drawable);
}

void *LB_SLPC_beginEditingDrawable(void *inObj, char *inSel, id drawable) {
	NSLog(@"beginEditingDrawable:%@", drawable);
	
	gSLPC_beginEditingDrawable(inObj, inSel, drawable);
}

void *LB_SLDA_initiateEditingAtStoragePosition(void *inObj, char *inSel, id fp8) {
	NSLog(@"initiateEditingAtStoragePosition:%@", fp8);
	
	gSLDA_initiateEditingAtStoragePosition(inObj, inSel, fp8);
}

BOOL LB_BGC_validateMenuItem(void *inObj, char *inSel, NSMenuItem *cell) {
	SEL action = [cell action];
	
	if (action == @selector(beginLinkBackForSelection:)) {
		BOOL ret;
		NSString *title;
		NSArray *infos = [[inObj selectionController] selectedLinkBackInfos];
		
		if ([infos count] == 1) {
			title = [[[infos objectAtIndex:0] linkBackData] linkBackEditMenuTitle];
			ret = YES;
		} else if ([infos count] > 1) {
			title = LinkBackEditMultipleMenuTitle();
			ret = YES;
		} else {
			title = LinkBackEditNoneMenuTitle();
			ret = NO;
		}
		
		[cell setTitle:title];
		
		return ret;
	}
	
	return gBGC_validateMenuItem(inObj, inSel, cell);
}

@implementation K2LinkBackSupport

+ (void)initialize {
	id observer = [[K2LinkBackSupport alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(appDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
	
	[SFDDrawableInfo_LinkBack poseAsClass:[SFDDrawableInfo class]];
	
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	if ([identifier isEqualToString:@"com.apple.iWork.Keynote"]) {
		Class bgcClass = objc_getClass("BGCanvas");
		struct objc_method *method;
		
		if (bgcClass) {
			[bgcClass initialize];
			
			/*
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"makeInfoFromPasteboard:withStyle:")))
				gBGC_makeInfoFromPasteboard = APEPatchCreate(method->method_imp, &LB_BGC_makeInfoFromPasteboard);
			 */
			
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"dealloc")))
				gBGC_dealloc = APEPatchCreate(method->method_imp, &LB_BGC_dealloc);
			
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"beginEditingRep:withEvent:")))
				gBGC_beginEditingRepWithEvent = APEPatchCreate(method->method_imp, &LB_BGC_beginEditingRepWithEvent);
			
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"validateMenuItem:")))
				gBGC_validateMenuItem = APEPatchCreate(method->method_imp, &LB_BGC_validateMenuItem);
		}
		
		if (bgcClass = objc_getClass("SFDImageRep")) {
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"isEditable")))
				gSFDImageRep_editable = APEPatchCreate(method->method_imp, &LB_SFDImageRep_editable);
		}
	} else if ([identifier isEqualToString:@"com.apple.iWork.Pages"]) {
		Class slcClass = objc_getClass("SLPasteboardController");
		struct objc_method *method;
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"drawablesFromPasteboard:type:unformatted:stylesOnly:toDrawablesController:returningWasNative:errors:")))
				gSLPC_drawablesFromPasteboard1 = APEPatchCreate(method->method_imp, &LB_SLPC_drawablesFromPasteboard1);
			else
				NSLog(@"failed to patch drawablesFromPasteboard1");
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"drawablesFromPasteboard:type:targetController:returningWasNative:errors:")))
				gSLPC_drawablesFromPasteboard2 = APEPatchCreate(method->method_imp, &LB_SLPC_drawablesFromPasteboard2);
			else
				NSLog(@"failed to patch drawablesFromPasteboard2");
		} else {
			NSLog(@"failed to find SLPasteboardController");
		}
		
		slcClass = objc_getClass("SLDrawablesController");
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"importDrawablesFromPasteboard:type:includingFormatting:errors:")))
				gSLDC_importDrawablesFromPasteboard1 = APEPatchCreate(method->method_imp, &LB_SLDC_importDrawablesFromPasteboard1);
			else
				NSLog(@"failed to patch importDrawablesFromPasteboard1");
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"importDrawablesFromPasteboard:importableTypes:includingFormatting:errors:")))
				gSLDC_importDrawablesFromPasteboard2 = APEPatchCreate(method->method_imp, &LB_SLDC_importDrawablesFromPasteboard2);
			else
				NSLog(@"failed to patch importDrawablesFromPasteboard2");
		} else {
			NSLog(@"failed to find SLDrawablesController");
		}
		
		slcClass = objc_getClass("SLDrawableAttachmentProxyCanvas");
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"beginEditingRep:withEvent:")))
				gSLDAPC_beginEditingRepWithEvent = APEPatchCreate(method->method_imp, &LB_LSDAPC_beginEditingRepWithEvent);
			else
				NSLog(@"failed to patch beginEditingRep:withEvent:");
		} else {
			NSLog(@"failed to find SLDrawableAttachmentProxyCanvas");
		}
		
		slcClass = objc_getClass("SLCanvas");
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"beginEditingDrawable:")))
				gSLC_beginEditingDrawable = APEPatchCreate(method->method_imp, &LB_SLC_beginEditingDrawable);
			else
				NSLog(@"failed to patch beginEditingDrawable");
		} else {
			NSLog(@"failed to find SLCanvas");
		}
		
		slcClass = objc_getClass("SLPaginatedCanvas");
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"beginEditingDrawable:")))
				gSLPC_beginEditingDrawable = APEPatchCreate(method->method_imp, &LB_SLPC_beginEditingDrawable);
			else
				NSLog(@"failed to patch beginEditingDrawable");
		} else {
			NSLog(@"failed to find SLPaginatedCanvas");
		}
		
		slcClass = objc_getClass("SLDrawableAttachment");
		
		if (slcClass) {
			[slcClass initialize];
			
			if (method = class_getInstanceMethod(slcClass, NSSelectorFromString(@"initiateEditingAtStoragePosition:")))
				gSLDA_initiateEditingAtStoragePosition = APEPatchCreate(method->method_imp, &LB_SLDA_initiateEditingAtStoragePosition);
			else
				NSLog(@"failed to patch initiateEditingAtStoragePosition");
		} else {
			NSLog(@"failed to find SLDrawablesAttachment");
		}
	}
	
	// Prep the LinkBack edit menu item
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *editMenu = [[mainMenu itemAtIndex:2] submenu];
	
	[editMenu insertItem:[NSMenuItem separatorItem] atIndex:[editMenu numberOfItems]];
	
	NSMenuItem *linkBackEdit = [editMenu addItemWithTitle:LinkBackEditNoneMenuTitle() action:@selector(beginLinkBackForSelection:) keyEquivalent:@""];
	[linkBackEdit setEnabled:NO];
}

- (id)init {
	if (self = [super init]) {
		
	}
	
	return self;
}

- (void)appDidFinishLaunching:(NSNotification *)notification {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	if ([identifier isEqualToString:@"com.apple.iWork.Keynote"]) {
		Class bgcClass = objc_getClass("BGCanvas");
		struct objc_method *method;
		
		if (bgcClass) {
			[bgcClass initialize];
			
			if (method = class_getInstanceMethod(bgcClass, NSSelectorFromString(@"makeInfoFromPasteboard:withStyle:")))
				gBGC_makeInfoFromPasteboard = APEPatchCreate(method->method_imp, &LB_BGC_makeInfoFromPasteboard);
		}
	}
}

@end
