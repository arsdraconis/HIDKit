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
		_device = device;
		_parent = parentElement;
	}
	return self;
}

- (void)dealloc
{
	if (_element)
	{
		CFRelease(_element);
		_element = NULL;
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

@dynamic collectionType;
- (IOHIDElementCollectionType)collectionType
{
	return IOHIDElementGetCollectionType(_element);
}

@dynamic children;
- (NSArray *)children
{
	CFArrayRef rawChildren = IOHIDElementGetChildren(_element);
	if (!rawChildren)
		return [NSArray array];
	
	CFIndex elementCount = CFArrayGetCount(rawChildren);
	
	NSMutableArray *elements = [NSMutableArray array];
	for (int i = 0; i < elementCount; i++)
	{
		IOHIDElementRef elementRef = (IOHIDElementRef)CFArrayGetValueAtIndex(rawChildren, i);
		HIDElement *element = [[HIDElement alloc] initWithElementRef:elementRef
															onDevice:_device
															  parent:self];
		
		if (element)
		{
			HIDLog(@"Adding element %@", element);
			[elements addObject:element];
		}
	}
	
//	CFRelease(rawChildren);
	return [elements copy];

}


//------------------------------------------------------------------------------
#pragma mark Interacting with Device Properties
//------------------------------------------------------------------------------
- (NSString *)getStringProperty:(CFStringRef)key
{
	CFTypeRef value = IOHIDElementGetProperty(_element, key);
	
	NSString *ret;
	if (value)
	{
		ret = [NSString stringWithString:(__bridge NSString *)value];
	}
	else
	{
		ret = @"Unknown";
	}
	
	return ret;
}

- (BOOL)getUInt32Property:(uint32_t *)outValue forKey:(CFStringRef)key
{
	BOOL result = NO;
	
	CFTypeRef value = IOHIDElementGetProperty(_element, key);
	if (value && CFNumberGetTypeID() == CFGetTypeID(value) )
	{
		result = (BOOL)CFNumberGetValue( (CFNumberRef)value, kCFNumberSInt32Type, outValue);
	}
	
	return result;
}

- (void)setUInt32Property:(CFStringRef)key value:(uint32_t)value
{
	CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &value);
	
	if (numberRef)
	{
		IOHIDElementSetProperty(_element, key, numberRef);
		CFRelease(numberRef);
	}
}


@end
