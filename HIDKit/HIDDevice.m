//
//  HIDDevice.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"
#import "HIDDevice+Private.h"


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
		
		_device = deviceRef;
		
//		IOHIDDeviceRegisterInputValueCallback(_device, &DS4DeviceInputValueCallback, (__bridge void *)self);
		IOHIDDeviceScheduleWithRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		IOReturn success = IOHIDDeviceOpen(_device, kIOHIDOptionsTypeNone);
		if (success != kIOReturnSuccess)
		{
			IOHIDDeviceUnscheduleFromRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
			CFRelease(_device);
			return nil;
		}
	}
	return self;
}

- (void)dealloc
{
	if (_device)
	{
		IOHIDDeviceClose(_device, kIOHIDOptionsTypeNone);
		IOHIDDeviceUnscheduleFromRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(_device);
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
#pragma mark Interacting with Device Properties
//------------------------------------------------------------------------------
- (NSString *)getStringProperty:(CFStringRef)key
{
	return (NSString *)CFBridgingRelease(IOHIDDeviceGetProperty(_device,  key));
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
	NSArray *rawElements = CFBridgingRelease(IOHIDDeviceCopyMatchingElements(_device, NULL, kIOHIDOptionsTypeNone) );
	
	NSMutableArray *elements = [NSMutableArray new];
	for (id element in rawElements)
	{
		// TODO: Write me!
	}
	
	return [elements copy];
}

- (NSArray *)elementsMatchingDictionary:(NSDictionary *)criteria
{
	NSMutableArray *elements = [self.elements mutableCopy];
	
	// TODO: Write me!
	
	return [elements copy];
}

@end
