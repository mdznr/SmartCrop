//
//  SmartCropTests.m
//  SmartCropTests
//
//  Created by Matt Zanchelli on 4/16/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CGAspectRatio.h"

@interface SmartCropTests : XCTestCase

@end

@implementation SmartCropTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCGAspectRatioFromString
{
	NSString *aspectRatioString = @"{2,1}";
	CGAspectRatio aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertEqual(aspectRatio.width, 2, @"Height is incorrect");
	XCTAssertEqual(aspectRatio.height, 1, @"Width is incorrect");
}

- (void)testExample
{
//	XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
