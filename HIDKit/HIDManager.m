//
//  HIDManager.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDManager.h"
#import "HIDDevice.h"
@import IOKit.hid;



//------------------------------------------------------------------------------
#pragma mark Notification Keys
//------------------------------------------------------------------------------
NSString * const HIDManagerDeviceDidConnectNotification = @"HIDManagerDeviceDidConnectNotification";
NSString * const HIDManagerDeviceDidDisconnectNotification = @"HIDManagerDeviceDidDisconnectNotification";



//------------------------------------------------------------------------------
#pragma mark Device Callback Functions
//------------------------------------------------------------------------------
static void HIDManagerDeviceMatchCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceDidConnectNotification object:(__bridge id)context];
}

static void HIDManagerDeviceRemovedCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceDidDisconnectNotification object:(__bridge id)context];
}



//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HIDManager ()

@property IOHIDManagerRef manager;

@end



//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HIDManager

//------------------------------------------------------------------------------
#pragma mark Retrieving the Shared Manager
//------------------------------------------------------------------------------
+ (instancetype)sharedManager
{
	static HIDManager *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init];
	});
	
	return sharedInstance;

}


//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
		if (!_manager || CFGetTypeID(_manager) != IOHIDManagerGetTypeID() )
		{
			return nil;
		}
		
		IOHIDManagerSetDeviceMatching(_manager, NULL);
		IOHIDManagerRegisterDeviceMatchingCallback(_manager, &HIDManagerDeviceMatchCallback, (__bridge void *)self);
		IOHIDManagerRegisterDeviceRemovalCallback(_manager, &HIDManagerDeviceRemovedCallback, (__bridge void *)self);
		IOHIDManagerScheduleWithRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		if (IOHIDManagerOpen(_manager, kIOHIDOptionsTypeNone) != kIOReturnSuccess)
		{
			return nil;
		}
	}
	return self;
}

- (void)dealloc
{
	if (_manager)
	{
		IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
		CFRelease(_manager);
		_manager = NULL;
	}
}


//------------------------------------------------------------------------------
#pragma mark Retrieving Devices
//------------------------------------------------------------------------------
+ (NSArray *)devices
{
	CFSetRef rawDevices = IOHIDManagerCopyDevices([HIDManager sharedManager].manager);
	CFIndex deviceCount = CFSetGetCount(rawDevices);
	
	IOHIDDeviceRef *deviceArray = calloc(deviceCount, sizeof(IOHIDDeviceRef));
	CFSetGetValues(rawDevices, (const void **)deviceArray);
	
	NSMutableArray *devices = [NSMutableArray array];
	for (int i = 0; i < deviceCount; i++)
	{
		HIDDevice *device = [[HIDDevice alloc] initWithDeviceRef:deviceArray[i]];
		
		if (device)
		{
			[devices addObject:device];
		}
	}
	
	CFRelease(rawDevices);
	free(deviceArray);
	deviceArray = NULL;
	
	return [devices copy];
}

+ (NSArray *)devicesMatchingDictionary:(NSDictionary *)criteria
{
	NSMutableArray *devices = [[[self class] devices] mutableCopy];
	
	// TODO: Implement me!
	
	return [devices copy];
}


@end
