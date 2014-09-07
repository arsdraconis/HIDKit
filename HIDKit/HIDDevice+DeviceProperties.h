//
//  HIDDevice+DeviceProperties.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"

@interface HIDDevice (DeviceProperties)

@property (readonly) NSString *transport;

@property (readonly) NSUInteger vendorID;
@property (readonly) NSUInteger vendorIDSource;
@property (readonly) NSUInteger productID;
@property (readonly) NSUInteger versionNumber;
@property (readonly) NSString *manufacturer;
@property (readonly) NSString *product;
@property (readonly) NSString *serialNumber;
@property (readonly) NSUInteger countryCode;

@property (readonly) NSUInteger deviceUsage;
@property (readonly) NSUInteger deviceUsagePage;
@property (readonly) NSArray *deviceUsagePairs;
@property (readonly) NSUInteger primaryUsage;
@property (readonly) NSUInteger primaryUsagePage;

@property (readonly) NSUInteger maxInputReportSize;
@property (readonly) NSUInteger maxOutputReportSize;
@property (readonly) NSUInteger maxFeatureReportSize;
@property (readonly) NSUInteger maxResponseLatency;
//@property (readonly) NSUInteger reportDescriptor;
@property (readonly) NSUInteger reportInterval;
@property (readonly) NSUInteger sampleInterval;
@property (readonly) NSUInteger requestTimeout;

// Do I even care about these?
//@property (readonly) NSString *standardType;
//@property (readonly) NSUInteger locationID;
//@property (readonly) NSString *productIDMask;
//@property (readonly) NSString *productIDArray;
//@property (readonly) NSString *category;
//@property (readonly) NSString *reset;
//@property (readonly) NSString *keyboardLanguage;
//@property (readonly) NSString *altHandlerID;
//@property (readonly) NSString *isBuiltIn;
//@property (readonly) NSString *displayIntegrated;
//@property (readonly) NSString *powerOnDelayNS;


@end
