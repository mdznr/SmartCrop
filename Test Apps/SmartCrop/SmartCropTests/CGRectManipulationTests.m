//
//  CGRectManipulationTests.m
//  SmartCrop
//
//  Created by Matt Zanchelli on 4/24/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CGRectManipulation.h"

@interface CGRectManipulationTests : XCTestCase

@end

@implementation CGRectManipulationTests

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

- (void)testCGRectOffsetRectToFitInRect
{
	
}

- (void)testCGRectScale
{
	CGRect rect, scaledRect;
	
	rect = CGRectMake(0, 0, 20, 20);
	scaledRect = CGRectScale(CGRectMake(0, 0, 10, 10), 2);
	XCTAssertTrue(CGRectEqualToRect(scaledRect, rect), @"Scaled rect not equal to rect");
	
	rect = CGRectMake(20, 20, 20, 20);
	scaledRect = CGRectScale(CGRectMake(10, 10, 10, 10), 2);
	XCTAssertTrue(CGRectEqualToRect(scaledRect, rect), @"Scaled rect not equal to rect");
	
	rect = CGRectMake(-20, -20, 20, 20);
	scaledRect = CGRectScale(CGRectMake(-10, -10, 10, 10), 2);
	XCTAssertTrue(CGRectEqualToRect(scaledRect, rect), @"Scaled rect not equal to rect");
}

- (void)testCGRectScaledRectToFitInRect
{
	
}

- (void)testCGRectCenterRectInRect
{
	
}

@end
