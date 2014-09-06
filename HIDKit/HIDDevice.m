//
//  HIDDevice.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"


// Private Class Extension
@interface HIDDevice ()

@property IOHIDDeviceRef device;

@end


// Implementation
@implementation HIDDevice

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


@end
