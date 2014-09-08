//
//  HIDDevice+DeviceProperties.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"


//------------------------------------------------------------------------------
#pragma mark Function Prototypes
//------------------------------------------------------------------------------
static BOOL HIDDevice_GetUInt32Property(IOHIDDeviceRef device, CFStringRef key, uint32_t * outValue);
static void HIDDevice_SetUInt32Property(IOHIDDeviceRef device, CFStringRef key, uint32_t value);


//------------------------------------------------------------------------------
#pragma mark Category Implementation
//------------------------------------------------------------------------------

@implementation HIDDevice (DeviceProperties)

@dynamic transport;
- (NSString *)transport
{
	return (NSString *)CFBridgingRelease(IOHIDDeviceGetProperty(self.device, CFSTR(kIOHIDTransportKey) ) );
}

@dynamic vendorID;
- (NSUInteger)vendorID
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDVendorIDKey), &result);
	return result;
}

@dynamic vendorIDSource;
- (NSUInteger)vendorIDSource
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDVendorIDSourceKey), &result);
	return result;
}

@dynamic productID;
- (NSUInteger)productID
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDProductIDKey), &result);
	return result;
}

@dynamic locationID;
- (NSUInteger)locationID
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDLocationIDKey), &result);
	return result;
}

@dynamic versionNumber;
- (NSUInteger)versionNumber
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDVersionNumberKey), &result);
	return result;
}

@dynamic manufacturer;
- (NSString *)manufacturer
{
	return (NSString *)CFBridgingRelease(IOHIDDeviceGetProperty(self.device, CFSTR(kIOHIDManufacturerKey) ) );
}

@dynamic product;
- (NSString *)product
{
	return (NSString *)CFBridgingRelease(IOHIDDeviceGetProperty(self.device, CFSTR(kIOHIDProductKey) ) );
}

@dynamic serialNumber;
- (NSString *)serialNumber
{
	return (NSString *)CFBridgingRelease(IOHIDDeviceGetProperty(self.device, CFSTR(kIOHIDSerialNumberKey) ) );
}

@dynamic countryCode;
- (NSUInteger)countryCode
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDCountryCodeKey), &result);
	return result;
}

@dynamic deviceUsage;
- (NSUInteger)deviceUsage
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDDeviceUsageKey), &result);
	return result;
}

@dynamic deviceUsagePage;
- (NSUInteger)deviceUsagePage
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDDeviceUsagePageKey), &result);
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
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDPrimaryUsageKey), &result);
	return result;
}

@dynamic primaryUsagePage;
- (NSUInteger)primaryUsagePage
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDPrimaryUsagePageKey), &result);
	return result;
}

@dynamic maxInputReportSize;
- (NSUInteger)maxInputReportSize
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDMaxInputReportSizeKey), &result);
	return result;
}

@dynamic maxOutputReportSize;
- (NSUInteger)maxOutputReportSize
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDMaxOutputReportSizeKey), &result);
	return result;
}

@dynamic maxFeatureReportSize;
- (NSUInteger)maxFeatureReportSize
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDMaxFeatureReportSizeKey), &result);
	return result;
}

@dynamic maxResponseLatency;
- (NSUInteger)maxResponseLatency
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDMaxResponseLatencyKey), &result);
	return result;
}

@dynamic reportInterval;
- (NSUInteger)reportInterval
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDReportIntervalKey), &result);
	return result;
}

@dynamic sampleInterval;
- (NSUInteger)sampleInterval
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDSampleIntervalKey), &result);
	return result;
}

@dynamic requestTimeout;
- (NSUInteger)requestTimeout
{
	uint32_t result;
	HIDDevice_GetUInt32Property(self.device, CFSTR(kIOHIDRequestTimeoutKey), &result);
	return result;
}



@end



//------------------------------------------------------------------------------
#pragma mark Convenience Functions
//------------------------------------------------------------------------------
// These are simple convenience functions to get/set UInt32 properties on an HID
// device. They were rewritten from Apple's HID Dumper sample project.


static BOOL HIDDevice_GetUInt32Property(IOHIDDeviceRef device, CFStringRef key, uint32_t * outValue)
{
	Boolean result = NO;
	
	if (device)
	{
		assert(IOHIDDeviceGetTypeID() == CFGetTypeID(device) );
		
		CFTypeRef tCFTypeRef = IOHIDDeviceGetProperty(device, key);
		if (tCFTypeRef)
		{
			if (CFNumberGetTypeID() == CFGetTypeID(tCFTypeRef) )
			{
				result = CFNumberGetValue( (CFNumberRef)tCFTypeRef, kCFNumberSInt32Type, outValue);
			}
		}
	}
	
	return result;
}

static void HIDDevice_SetUInt32Property(IOHIDDeviceRef device, CFStringRef key, uint32_t value)
{
	CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &value);
	
	if (numberRef)
	{
		IOHIDDeviceSetProperty(device, key, numberRef);
		CFRelease(numberRef);
	}
}

