//
//  HIDDevice+DeviceProperties.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"


@implementation HIDDevice (DeviceProperties)

@dynamic transport;
- (NSString *)transport
{
	return [self getStringProperty:CFSTR(kIOHIDTransportKey)];
}

@dynamic vendorID;
- (NSUInteger)vendorID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVendorIDKey)];
	return result;
}

@dynamic vendorIDSource;
- (NSUInteger)vendorIDSource
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVendorIDSourceKey)];
	return result;
}

@dynamic productID;
- (NSUInteger)productID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDProductIDKey)];
	return result;
}

@dynamic locationID;
- (NSUInteger)locationID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDLocationIDKey)];
	return result;
}

@dynamic versionNumber;
- (NSUInteger)versionNumber
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVersionNumberKey)];
	return result;
}

@dynamic manufacturer;
- (NSString *)manufacturer
{
	return [self getStringProperty:CFSTR(kIOHIDManufacturerKey)];
}

@dynamic product;
- (NSString *)product
{
	return [self getStringProperty:CFSTR(kIOHIDProductKey)];
}

@dynamic serialNumber;
- (NSString *)serialNumber
{
	return [self getStringProperty:CFSTR(kIOHIDSerialNumberKey)];
}

@dynamic countryCode;
- (NSUInteger)countryCode
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDCountryCodeKey)];
	return result;
}

@dynamic deviceUsage;
- (NSUInteger)deviceUsage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDDeviceUsageKey)];
	return result;
}

@dynamic deviceUsagePage;
- (NSUInteger)deviceUsagePage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDDeviceUsagePageKey)];
	return result;
}

@dynamic deviceUsagePairs;
- (NSArray *)deviceUsagePairs
{
	// TODO: Write me!
	NSLog(@"Method unimplemented.");
	return [NSArray new];
}

@dynamic primaryUsage;
- (NSUInteger)primaryUsage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDPrimaryUsageKey)];
	return result;
}

@dynamic primaryUsagePage;
- (NSUInteger)primaryUsagePage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDPrimaryUsagePageKey)];
	return result;
}

@dynamic maxInputReportSize;
- (NSUInteger)maxInputReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxInputReportSizeKey)];
	return result;
}

@dynamic maxOutputReportSize;
- (NSUInteger)maxOutputReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxOutputReportSizeKey)];
	return result;
}

@dynamic maxFeatureReportSize;
- (NSUInteger)maxFeatureReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxFeatureReportSizeKey)];
	return result;
}

@dynamic maxResponseLatency;
- (NSUInteger)maxResponseLatency
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxResponseLatencyKey)];
	return result;
}

@dynamic reportInterval;
- (NSUInteger)reportInterval
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDReportIntervalKey)];
	return result;
}

@dynamic sampleInterval;
- (NSUInteger)sampleInterval
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDSampleIntervalKey)];
	return result;
}

@dynamic requestTimeout;
- (NSUInteger)requestTimeout
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDRequestTimeoutKey)];
	return result;
}


@end
