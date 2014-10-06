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

@dynamic children;
- (NSArray *)children
{
	NSArray *rawChildren = CFBridgingRelease(IOHIDElementGetChildren(_element) );
	
	NSMutableArray *children = [NSMutableArray array];
	for (id elementRef in rawChildren)
	{
		HIDElement *child = [[HIDElement alloc] initWithElementRef:(__bridge IOHIDElementRef)elementRef onDevice:_device parent:self];
		[children addObject:child];
	}
	
	return [children copy];
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
