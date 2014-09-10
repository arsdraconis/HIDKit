//
//  HIDQueue.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIDDevice;
@class HIDElement;
@class HIDValue;

/**
	HIDQueue defines an object used to queue values from input parsed items
	contained within an HIDDevice. This is useful when you need to keep track of
	all values of an input element, not just the most recent one.
 
	HIDQueue should be considered optional and is only useful for working with
	complex input elements. These elements include those whose length are greater
	than sizeof(CFIndex) or elements that are duplicate items.
 
	Note: Absolute element values (based on a fixed origin) will only be placed
	on a queue if there is a change in value.
 */
@interface HIDQueue : NSObject

- (instancetype)initWithDevice:(HIDDevice *)device;
- (instancetype)initWithDevice:(HIDDevice *)device depth:(NSUInteger)depth;

- (void)addElement:(HIDElement *)element;
- (void)removeElement:(HIDElement *)element;
- (BOOL)containsElement:(HIDElement *)element;

- (HIDValue *)nextValue;
- (HIDValue *)nextValueWithTimeout:(CFTimeInterval)timeout;

- (void)start;
- (void)stop;


@property NSUInteger depth;



@end
