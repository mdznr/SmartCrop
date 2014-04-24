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

- (void)testCGAspectRatioRelationForAspectRatio
{
	CGAspectRatioRelation relation;
	
	relation = CGAspectRatioRelationForAspectRatio( CGAspectRatioMake(1, 1) );
	XCTAssertTrue(relation == CGAspectRatioRelationSquare, @"1:1 should be considered square");
	
	relation = CGAspectRatioRelationForAspectRatio( CGAspectRatioMake(2, 2) );
	XCTAssertTrue(relation == CGAspectRatioRelationSquare, @"2:2 should be considered square");
	
	relation = CGAspectRatioRelationForAspectRatio( CGAspectRatioMake(2, 1) );
	XCTAssertTrue(relation == CGAspectRatioRelationWide, @"2:1 should be considered wide");
	
	relation = CGAspectRatioRelationForAspectRatio( CGAspectRatioMake(1, 2) );
	XCTAssertTrue(relation == CGAspectRatioRelationTall, @"1:2 should be considered tall");
}

- (void)testCGAspectRatioFromString
{
	NSString *aspectRatioString;
	CGAspectRatio aspectRatio;
	
	aspectRatioString = @"{2,1}";
	aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioMake(2, 1)), @"Apsect ratio not equivalent.");
	
	aspectRatioString = @"{2.0,1.0}";
	aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioMake(2.0, 1.0)), @"Apsect ratio not equivalent.");
	
	aspectRatioString = @"{2.0, 1.0}";
	aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioMake(2.0, 1.0)), @"Apsect ratio not equivalent.");
	
	aspectRatioString = @"{2.5, 1.0}";
	aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioMake(2.5, 1.0)), @"Apsect ratio not equivalent.");
	
	aspectRatioString = @"{2, 1.5}";
	aspectRatio = CGAspectRatioFromString(aspectRatioString);
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioMake(2, 1.5)), @"Apsect ratio not equivalent.");
}

- (void)testExample
{
//	XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
