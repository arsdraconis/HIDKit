//
//  HIDValue.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import IOKit.hid;

@class HIDElement;

@interface HIDValue : NSObject

- (instancetype)initWithData:(NSData *)data element:(HIDElement *)element;
- (instancetype)initWithBytes:(const uint8_t *)bytes length:(NSUInteger)length element:(HIDElement *)element;
- (instancetype)initWithBytesNoCopy:(const uint8_t *)bytes length:(NSUInteger)length element:(HIDElement *)element;
- (instancetype)initWithInteger:(NSInteger)value element:(HIDElement *)element;

@property (readonly) HIDElement *element;

@property (readonly, nonatomic) const void * bytes;
@property (readonly, nonatomic) NSUInteger length;

@property (readonly, nonatomic) uint64_t timeStamp;

@property (readonly, nonatomic) CGFloat scaledPhysicalValue;
@property (readonly, nonatomic) CGFloat scaledCalibratedValue;


@end
