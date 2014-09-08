//
//  HIDElement.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement.h"

@interface HIDElement ()

@property (readonly) IOHIDElementRef element;

@end

@implementation HIDElement

//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithElementRef:NULL parent:nil];
}

- (instancetype)initWithElementRef:(IOHIDElementRef)element parent:(HIDDevice *)parentDevice
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(element);
		NSParameterAssert(parentDevice);
		if (CFGetTypeID(element) != IOHIDElementGetTypeID() )
		{
			return nil;
		}
		
		_element = element;
		_parentDevice = parentDevice;
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

@end
