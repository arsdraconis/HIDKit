//
//  HIDDevice.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"
#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"
#import "HIDElement.h"

// Implementation
@implementation HIDDevice


//------------------------------------------------------------------------------
#pragma mark Creating and Destroying Instances
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithDeviceRef:NULL];
}

- (instancetype)initWithDeviceRef:(IOHIDDeviceRef)deviceRef
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(deviceRef);
		if (CFGetTypeID(deviceRef) != IOHIDDeviceGetTypeID())
		{
			return nil;
		}
		
		CFRetain(deviceRef);
		_device = deviceRef;
		
//		IOHIDDeviceRegisterInputValueCallback(_device, &DS4DeviceInputValueCallback, (__bridge void *)self);
		
		HIDLog(@"Device created: %@", self.description);
	}
	return self;
}

- (void)dealloc
{
	if (_device)
	{
		if (_isOpen)
		{
			HIDLog(@"Device was released without closing: %@", self.description);
			IOHIDDeviceUnscheduleFromRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
			IOHIDDeviceClose(_device, kIOHIDOptionsTypeNone);
		}
		
		CFRelease(_device);
		_device = NULL;
	}
}

//------------------------------------------------------------------------------
#pragma mark Retrieving the I/O Service
//------------------------------------------------------------------------------
@dynamic service;
- (io_service_t)service
{
	return IOHIDDeviceGetService(_device);
}

//------------------------------------------------------------------------------
#pragma mark Describing the Device
//------------------------------------------------------------------------------
- (NSString *)description
{
	return [NSString stringWithFormat:@"HIDDevice: %p \n \
	{ \n \
			\tName: %@ \n \
			\tManufacturer: %@ \n \
			\tIOHIDDeviceRef: %p \n \
	}", self, self.product, self.manufacturer, self.device];
}


//------------------------------------------------------------------------------
#pragma mark Opening and Closing the Device
//------------------------------------------------------------------------------

- (void)open
{
	IOHIDDeviceScheduleWithRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	IOReturn success = IOHIDDeviceOpen(_device, kIOHIDOptionsTypeNone);
	
	if (success != kIOReturnSuccess)
	{
		self.isOpen = YES;
	}
	else
	{
		self.isOpen = NO;
	}
}

- (void)close
{
	IOHIDDeviceUnscheduleFromRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	IOReturn success = IOHIDDeviceClose(_device, kIOHIDOptionsTypeNone);
	
	if (success != kIOReturnSuccess)
	{
		self.isOpen = NO;
	}
	else
	{
		self.isOpen = YES;
	}
}

//------------------------------------------------------------------------------
#pragma mark Interacting with Device Properties
//------------------------------------------------------------------------------
- (NSString *)getStringProperty:(CFStringRef)key
{
	CFTypeRef value = IOHIDDeviceGetProperty(_device,  key);
	
	NSString *ret = nil;
	if (value)
	{
		ret = [NSString stringWithString:(__bridge NSString *)value];
	}
	
	return ret;
}

- (BOOL)getUInt32Property:(uint32_t *)outValue forKey:(CFStringRef)key
{
	BOOL result = NO;
	
	CFTypeRef value = IOHIDDeviceGetProperty(_device, key);
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
		IOHIDDeviceSetProperty(_device, key, numberRef);
		CFRelease(numberRef);
	}
}

//------------------------------------------------------------------------------
#pragma mark Retrieving Device Elements
//------------------------------------------------------------------------------
@dynamic elements;
- (NSArray *)elements
{
	CFArrayRef rawElements = IOHIDDeviceCopyMatchingElements(_device, NULL, kIOHIDOptionsTypeNone);
	CFIndex elementCount = CFArrayGetCount(rawElements);
	
	NSMutableArray *elements = [NSMutableArray array];
	for (int i = 0; i < elementCount; i++)
	{
		IOHIDElementRef elementRef = (IOHIDElementRef)CFArrayGetValueAtIndex(rawElements, i);
		if (IOHIDElementGetParent(elementRef))
		{
			HIDLog(@"Element with parent skipped. Element cookie: %u", IOHIDElementGetCookie(elementRef));
			continue;
		}
		
		HIDElement *element = [[HIDElement alloc] initWithElementRef:elementRef
															onDevice:self
															  parent:nil];
		
		if (element)
		{
			HIDLog(@"Adding element %@", element);
			[elements addObject:element];
		}
	}
	
	CFRelease(rawElements);	
	return [elements copy];
}

// TODO: Way too much duplication. Refactor.
// FIXME: There's a bug in this.
- (NSArray *)allElements
{
	CFArrayRef rawElements = IOHIDDeviceCopyMatchingElements(_device, NULL, kIOHIDOptionsTypeNone);
	CFIndex elementCount = CFArrayGetCount(rawElements);
	
	NSMutableArray *elements = [NSMutableArray array];
	for (int i = 0; i < elementCount; i++)
	{
		IOHIDElementRef elementRef = (IOHIDElementRef)CFArrayGetValueAtIndex(rawElements, i);
		
		HIDElement *element = [[HIDElement alloc] initWithElementRef:elementRef
															onDevice:self
															  parent:nil];
		
		if (element)
		{
			HIDLog(@"Adding element %@", element);
			[elements addObject:element];
		}
	}
	
	CFRelease(rawElements);
	return [elements copy];
}

- (NSArray *)elementsMatchingDictionary:(NSDictionary *)criteria
{
	NSMutableArray *elements = [self.allElements mutableCopy];
	
	// TODO: Write me!
	
	return [elements copy];
}

@end
