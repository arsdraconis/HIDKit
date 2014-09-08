//
//  HIDElement.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement.h"
#import "HIDElement+Private.h"

@implementation HIDElement

//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithElementRef:NULL onDevice:nil parent:nil];
}

- (instancetype)initWithElementRef:(IOHIDElementRef)element onDevice:(HIDDevice *)device parent:(HIDElement *)parentElement
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(element);
		if (CFGetTypeID(element) != IOHIDElementGetTypeID() )
		{
			return nil;
		}
		
		CFRetain(element);
		_element = element;
		_parentDevice = device;
		_parent = parentElement;
	}
	return self;
}

- (void)dealloc
{
	if (_element)
	{
		CFRelease(_element);
	}
}

//------------------------------------------------------------------------------
#pragma mark Element Properties
//------------------------------------------------------------------------------
@dynamic type;
- (IOHIDElementType)type
{
	return IOHIDElementGetType(_element);
}

@dynamic children;
- (NSArray *)children
{
	NSArray *rawChildren = CFBridgingRelease(IOHIDElementGetChildren(_element) );
	
	NSMutableArray *children = [NSMutableArray array];
	for (id elementRef in rawChildren)
	{
		HIDElement *child = [[HIDElement alloc] initWithElementRef:(__bridge IOHIDElementRef)elementRef onDevice:_parentDevice parent:self];
		[children addObject:child];
	}
	
	return [children copy];
}

@end
