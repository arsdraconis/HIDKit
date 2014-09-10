//
//  HIDTransaction.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDTransaction.h"
#import "HIDDevice+Private.h"
#import "HIDValue+Private.h"
#import "HIDElement+Private.h"
@import IOKit.hid;

//------------------------------------------------------------------------------
#pragma mark Class Extension
//------------------------------------------------------------------------------
@interface HIDTransaction ()

@property (readonly) IOHIDTransactionRef transaction;

@end


//------------------------------------------------------------------------------
#pragma mark Callback Function Prototype
//------------------------------------------------------------------------------
void HIDTransactionCallback(void *context, IOReturn result, void *sender);

//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HIDTransaction


//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithDevice:nil];
}

- (instancetype)initWithDevice:(HIDDevice *)device
{
	return [self initWithDevice:device direction:kIOHIDTransactionDirectionTypeOutput];
}

- (instancetype)initWithDevice:(HIDDevice *)device direction:(IOHIDTransactionDirectionType)direction
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(device);
		NSParameterAssert(direction);
		
		_device = device;
		_transaction = IOHIDTransactionCreate(NULL, device.device, direction, kIOHIDOptionsTypeNone);
		if (!_transaction || CFGetTypeID(_transaction) != IOHIDTransactionGetTypeID() )
		{
			return nil;
		}
		
		IOHIDTransactionScheduleWithRunLoop(_transaction, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
	return self;
}

- (void)dealloc
{
	if (_transaction)
	{
		// FIXME: Can we pass something that's already been unscheduled?
		IOHIDTransactionUnscheduleFromRunLoop(_transaction, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(_transaction);
	}
}

//------------------------------------------------------------------------------
#pragma mark Transaction Properties
//------------------------------------------------------------------------------
@dynamic direction;
- (void)setDirection:(IOHIDTransactionDirectionType)direction
{
	IOHIDTransactionSetDirection(_transaction, direction);
}

- (IOHIDTransactionDirectionType)direction
{
	return IOHIDTransactionGetDirection(_transaction);
}

// TODO: Value property.


//------------------------------------------------------------------------------
#pragma mark Managing Elements
//------------------------------------------------------------------------------
- (void)addElement:(HIDElement *)element
{
	IOHIDTransactionAddElement(_transaction, element.element);
}

- (void)removeElement:(HIDElement *)element
{
	IOHIDTransactionRemoveElement(_transaction, element.element);
}

- (BOOL)containsElement:(HIDElement *)element
{
	return (BOOL)IOHIDTransactionContainsElement(_transaction, element.element);
}

//------------------------------------------------------------------------------
#pragma mark Committing and Clearing Values
//------------------------------------------------------------------------------
- (void)clear
{
	IOHIDTransactionClear(_transaction);
}

- (void)commit
{
	IOHIDTransactionCommit(_transaction);
}

- (void)commitWithTimeout:(CFTimeInterval)timeout completionHandler:(HIDTransactionCompletionHandler)handler
{
	IOHIDTransactionCommitWithCallback(_transaction, timeout, &HIDTransactionCallback, (void *)CFBridgingRetain(handler));
}

@end

void HIDTransactionCallback(void *context, IOReturn result, void *sender)
{
	HIDTransactionCompletionHandler block = CFBridgingRelease(context);
	block();
}
