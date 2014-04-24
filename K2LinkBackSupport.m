//
//  K2LinkBackSupport.m
//  K2LinkBackSupport
//
//  Created by King Chung Huang on 3/12/05.
//  Copyright 2005, 2007 King Chung Huang. All rights reserved.
//

#import "K2LinkBackSupport.h"

#import <LinkBack/LinkBack.h>

#import <unistd.h>
#import <mach-o/dyld.h>
#import "APELite.h"

#import <libxml/tree.h>

#import "SFDDrawableInfo_LinkBack.h"
#import "SFDCanvas_LinkBack.h"

struct objc_method {
	char *method_name;
	char *method_types;
	void *method_imp;
};

#pragma mark Swizzled methods typedefs

extern struct objc_method *class_getInstanceMethod(void *inClass, void *selector);

typedef void *(*BGC_makeInfoFromPasteboardProcPtr)(id inObj, SEL inSel, NSPasteboard *pasteboard, BOOL style);
typedef void (*NSO_deallocProcPtr)(id inObj, SEL inSel);
typedef void (*BGC_beginEditingRepWithEventProcPtr)(id inObj, SEL inSel, id rep, NSEvent *event);
typedef BOOL (*SFDRep_isEditableProcPtr)(id inObj, SEL inSel);
typedef void *(*SLDC_importDrawablesFromPasteboard1ProcPtr)(id inObj, SEL inSel, NSPasteboard *pasteboard, id type, BOOL includeFormatting, id *errors);
typedef BOOL (*BGC_validateMenuItemProcPtr)(id inObj, SEL inSel, NSMenuItem *cell);
typedef void *(*SFDDI_initWithXMLUnarchiverProcPtr)(id inObj, SEL inSel, SFAXMLUnarchiver *unarchiver, xmlNodePtr node, unsigned long version);
typedef void (*SFDDI_encodeWithXMLArchievrProcPtr)(id inObj, SEL inSel, SFAXMLArchiver *archiver, xmlNodePtr node, unsigned long version);
typedef void (*SFDDI_deallocProcPtr)(id inObj, SEL inSel);

BGC_makeInfoFromPasteboardProcPtr gBGC_makeInfoFromPasteboard = NULL;
NSO_deallocProcPtr gBGC_dealloc = NULL;
BGC_beginEditingRepWithEventProcPtr gBGC_beginEditingRepWithEvent = NULL;
SFDRep_isEditableProcPtr gSFDImageRep_editable = NULL;
SLDC_importDrawablesFromPasteboard1ProcPtr gSLDC_importDrawablesFromPasteboard1 = NULL;
BGC_validateMenuItemProcPtr gBGC_validateMenuItem = NULL;
SFDDI_initWithXMLUnarchiverProcPtr gSFDDI_initWithXMLUnarchiver = NULL;
SFDDI_encodeWithXMLArchievrProcPtr gSFDDI_encodeWithXMLArchiver = NULL;
SFDDI_deallocProcPtr gSFDDI_dealloc = NULL;

#pragma mark Swizzled methods implementation

void *LB_BGC_makeInfoFromPasteboard(id inObj, SEL inSel, NSPasteboard *pasteboard, BOOL style) {
	id info = gBGC_makeInfoFromPasteboard(inObj, inSel, pasteboard, style);
	
	if ([info respondsToSelector:@selector(setLinkBackData:)] && [[pasteboard types] containsObject:LinkBackPboardType]) {
		id lbd = [pasteboard propertyListForType:LinkBackPboardType];
		
		[info performSelector:@selector(setLinkBackData:) withObject:lbd];
	}
	
	return info;
}

void *LB_BGC_dealloc(id canvas, SEL inSel) {
	if ([canvas respondsToSelector:@selector(deallocLinks)]) {
		[canvas performSelector:@selector(deallocLinks)];
	}
	
	gBGC_dealloc(canvas, inSel);
}

void *LB_BGC_beginEditingRepWithEvent(id inObj, SEL inSel, id rep, NSEvent *event) {
	NSLog(@"LB_BGC_beginEditingRepWithEvent");
	
	if ([rep respondsToSelector:@selector(info)]) {
		id info = [rep performSelector:@selector(info)];
		
		if ([info respondsToSelector:@selector(hasLinkBackData)] && [info performSelector:@selector(hasLinkBackData)]) {
			id canvas = inObj;
			
			NSLog(@"YES");
			
			[canvas beginLinkBackForInfo:info canvas:[rep performSelector:@selector(canvas)]];
		} else {
			NSLog(@"NO");
			
			gBGC_beginEditingRepWithEvent(inObj, inSel, rep, event);
		}
	}

}

BOOL LB_SFDImageRep_editable(id rep, SEL inSel) {
	NSLog(@"LB_SFDImageRep_editable");
	
	if ([rep respondsToSelector:@selector(info)]) {
		id info = [rep performSelector:@selector(info)];
		
		if ([info respondsToSelector:@selector(hasLinkBackData)] && [info performSelector:@selector(hasLinkBackData)]) {
			NSLog(@"\tYES");
			return YES;
		} else {
			NSLog(@"\tNO");
			return gSFDImageRep_editable(rep, inSel);
		}
	}
}

void *LB_SLDC_importDrawablesFromPasteboard1(id inObj, SEL inSel, NSPasteboard *pasteboard, id type, BOOL includeFormatting, id *errors) {
	id drawables = gSLDC_importDrawablesFromPasteboard1(inObj, inSel, pasteboard, type, includeFormatting, errors);
	NSEnumerator *infos = [drawables objectEnumerator];
	id info;
	
	while (info = [infos nextObject]) {
		if ([info respondsToSelector:@selector(setLinkBackData:)] && [[pasteboard types] containsObject:LinkBackPboardType]) {
			id lbd = [pasteboard propertyListForType:LinkBackPboardType];
			
			[info takeValue:lbd forKey:@"linkBackData"];
		}
	}
	
	return drawables;
}

BOOL LB_BGC_validateMenuItem(id inObj, SEL inSel, NSMenuItem *cell) {
	if ([cell action] == @selector(beginLinkBackForSelection:)) {
		BOOL ret;
		NSString *title;
		id canvas = inObj;
		
		NSArray *infos = [[canvas selectionController] performSelector:@selector(selectedLinkBackInfos)];
		
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

void *LB_SFDDI_initWithXMLUnarchiver(id inObj, SEL inSel, SFAXMLUnarchiver *unarchiver, xmlNodePtr node, unsigned long version) {
	id obj = nil;
	
	if (obj = gSFDDI_initWithXMLUnarchiver(inObj, inSel, unarchiver, node, version)) {
		xmlNode *cur_node = node->children;
		NSData *lbd = nil;
		
		for (cur_node = node->children; cur_node && (lbd == nil); cur_node = cur_node->next) {
			if (cur_node->type == XML_ELEMENT_NODE && strcmp(cur_node->name, "LinkBackData") == 0) {
				lbd = [unarchiver createObjectOfClass:[NSData class] fromNode:cur_node];
			}
		}
		
		if (lbd != nil) {
			[obj setLinkBackData:[NSPropertyListSerialization propertyListFromData:lbd mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil]];
		}
	}
		
	return obj;
}

void LB_SFDDI_encodeWithXMLArchiver(id inObj, SEL inSel, SFAXMLArchiver *archiver, xmlNodePtr node, unsigned long version) {
	gSFDDI_encodeWithXMLArchiver(inObj, inSel, archiver, node, version);
	
	id obj = inObj;
	id lbd = [obj linkBackData];
	
	if (lbd != nil) {
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:lbd format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
		
		if (data != nil) {
			[archiver encodeObject:data asChildOf:node withName:"LinkBackData" xmlNamespace:nil];
		}
	}	
}

void LB_SFDDI_dealloc(id inObj, SEL inSel) {
	id info = inObj;
	
	if ([info respondsToSelector:@selector(deallocLinkBack)]) {
		[info performSelector:@selector(deallocLinkBack)];
	}
	
	gSFDDI_dealloc(inObj, inSel);
}

#pragma mark Plugin initialization

@implementation K2LinkBackSupport

+ (void)initialize {
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	// Note: Leopard has its own functions. Check compatibility.
	
	if ([identifier isEqualToString:@"com.apple.iWork.Keynote"]) {
		Class bgclass;
		struct objc_method *method;
		
		if (bgclass = objc_getClass("BGCanvas")) {
			[bgclass initialize];
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"makeInfoFromPasteboard:withStyle:")))
				gBGC_makeInfoFromPasteboard = APEPatchCreate(method->method_imp, &LB_BGC_makeInfoFromPasteboard);
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"dealloc")))
				gBGC_dealloc = APEPatchCreate(method->method_imp, &LB_BGC_dealloc);
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"beginEditingRep:withEvent:")))
				gBGC_beginEditingRepWithEvent = APEPatchCreate(method->method_imp, &LB_BGC_beginEditingRepWithEvent);
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"validateMenuItem:")))
				gBGC_validateMenuItem = APEPatchCreate(method->method_imp, &LB_BGC_validateMenuItem);
		}
		
		if (bgclass = objc_getClass("SFDImageRep")) {
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"isEditable")))
				gSFDImageRep_editable = APEPatchCreate(method->method_imp, &LB_SFDImageRep_editable);
		}
		
		if (bgclass = objc_getClass("SFDDrawableInfo")) {
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"initWithXMLUnarchiver:node:version:")))
				gSFDDI_initWithXMLUnarchiver = APEPatchCreate(method->method_imp, &LB_SFDDI_initWithXMLUnarchiver);
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"encodeWithXMLArchiver:node:version:")))
				gSFDDI_encodeWithXMLArchiver = APEPatchCreate(method->method_imp, &LB_SFDDI_encodeWithXMLArchiver);
			
			if (method = class_getInstanceMethod(bgclass, NSSelectorFromString(@"dealloc")))
				gSFDDI_dealloc = APEPatchCreate(method->method_imp, &LB_SFDDI_dealloc);
		}
	} else if ([identifier isEqualToString:@"com.apple.iWork.Pages"]) {
		// Removed for public code release
	}
	
	// Add the LinkBack menu item
	
	NSMenu *mainMenu = [NSApp mainMenu];
	NSMenu *editMenu = [[mainMenu itemAtIndex:2] submenu];
	
	[editMenu insertItem:[NSMenuItem separatorItem] atIndex:[editMenu numberOfItems]];
	
	NSMenuItem *linkBackEdit = [editMenu addItemWithTitle:LinkBackEditNoneMenuTitle() action:@selector(beginLinkBackForSelection:) keyEquivalent:@""];
	[linkBackEdit setEnabled:NO];
}

@end
