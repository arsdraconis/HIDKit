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
NSString * const HIDManagerDeviceConnectedNotification = @"HIDManagerDeviceConnected";
NSString * const HIDManagerDeviceRemovedNotification = @"HIDManagerDeviceRemoved";



//------------------------------------------------------------------------------
#pragma mark Device Callback Functions
//------------------------------------------------------------------------------
static void HIDManagerDeviceMatchCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceConnectedNotification object:(__bridge id)context];
}

static void HIDManagerDeviceRemovedCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceRemovedNotification object:(__bridge id)context];
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
		if (!_manager)
		{
			return nil;
		}
		else if (CFGetTypeID(_manager) != IOHIDManagerGetTypeID())
		{
			CFRelease(_manager);
			return nil;
		}
		
		IOHIDManagerSetDeviceMatching(_manager, NULL);
		IOHIDManagerRegisterDeviceMatchingCallback(_manager, &HIDManagerDeviceMatchCallback, (__bridge void *)self);
		IOHIDManagerRegisterDeviceRemovalCallback(_manager, &HIDManagerDeviceRemovedCallback, (__bridge void *)self);
		IOHIDManagerScheduleWithRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		if (IOHIDManagerOpen(_manager, kIOHIDOptionsTypeNone) != kIOReturnSuccess)
		{
			IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
			CFRelease(_manager);
			return nil;
		}
	}
	return self;
}

- (void)dealloc
{
	if (_manager)
	{
		IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
		IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(_manager);
	}
}


//------------------------------------------------------------------------------
#pragma mark Retrieving Devices
//------------------------------------------------------------------------------
+ (NSArray *)devices
{
	// FIXME: Crashes here when you reset the controller via the reset button.
	NSSet *rawDevices = (NSSet *)CFBridgingRelease(IOHIDManagerCopyDevices([HIDManager sharedManager].manager));
	
	NSMutableArray *devices = [NSMutableArray new];
	for (id deviceRef in rawDevices)
	{
		HIDDevice *device = [[HIDDevice alloc] initWithDeviceRef:(__bridge IOHIDDeviceRef)deviceRef];
		[devices addObject:device];
	}
	
	return [devices copy];
}

+ (NSArray *)devicesMatchingDictionary:(NSDictionary *)criteria
{
	NSMutableArray *devices = [[[self class] devices] mutableCopy];
	
	// TODO: Implement me!
	
	return [devices copy];
}


@end
