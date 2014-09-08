//
//  HIDElement.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIDDevice.h"
@import IOKit.hid;

@interface HIDElement : NSObject

- (instancetype)initWithElementRef:(IOHIDElementRef)element onDevice:(HIDDevice *)device parent:(HIDElement *)parentElement NS_DESIGNATED_INITIALIZER;

@property (readonly) HIDDevice *parentDevice;
@property (readonly) HIDElement *parent;
@property (readonly) NSArray *children;

@property (readonly) IOHIDElementType type;

@end
