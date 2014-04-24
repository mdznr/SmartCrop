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

- (void)testCGAspectRatioZero
{
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioZero, CGAspectRatioMake(0, 0)), @"`CGAspectRatioZero` should be equal to `CGAspectRatioMake(0, 0)`");
}

- (void)testCGAspectRatioCreateDictionaryRepresentation
{
#warning Test once implemented.
}

- (void)testCGAspectRatioEqualToAspectRatio
{
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(1, 1), CGAspectRatioMake(1, 1)), @"Simple equality should be true.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(2, 2), CGAspectRatioMake(2, 2)), @"Simple equality should be true.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(2, 2), CGAspectRatioMake(1, 1)), @"Reduced ratios should be equal.");
}

- (void)testCGAspectRatioComparison
{
	XCTAssertEqual(CGAspectRatioComparison(CGAspectRatioMake(1, 1), CGAspectRatioMake(1, 1)), NSOrderedSame, @"Comparing the same ratio should be the same.");
	XCTAssertEqual(CGAspectRatioComparison(CGAspectRatioMake(1, 1), CGAspectRatioMake(2, 2)), NSOrderedSame, @"Comparing the same ratio to a varation of the same should be the same.");
	XCTAssertEqual(CGAspectRatioComparison(CGAspectRatioMake(2, 1), CGAspectRatioMake(1, 1)), NSOrderedDescending, @"Comparing a larger ratio to a lesser one should be the descending.");
	XCTAssertEqual(CGAspectRatioComparison(CGAspectRatioMake(1, 1), CGAspectRatioMake(2, 1)), NSOrderedAscending, @"Comparing a smaller ratio to a greater one should be the descending.");
}

- (void)testCGAspectRatioMake
{
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(1, 1), (CGAspectRatio) {1, 1}), @"Ratios should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(2, 2), (CGAspectRatio) {2, 2}), @"Ratios should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(2, 1), (CGAspectRatio) {2, 1}), @"Ratios should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(4, 2), (CGAspectRatio) {2, 1}), @"Reduced ratios should be equal.");
}

- (void)testCGAspectRatioMakeWithDictionaryRepresentation
{
#warning Test once implemented.
}

- (void)testCGAspectRatioFromSize
{
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(1, 1), CGAspectRatioFromSize(CGSizeMake(1, 1))), @"Ratios and ratio from size should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(1, 1), CGAspectRatioFromSize(CGSizeMake(2, 2))), @"Ratios and ratio from size should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(2, 1), CGAspectRatioFromSize(CGSizeMake(2, 1))), @"Ratios and ratio from size should be equal.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioMake(1, 2), CGAspectRatioFromSize(CGSizeMake(1, 2))), @"Ratios and ratio from size should be equal.");
}

- (void)testCGAspectRatioFlip
{
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioFlip(CGAspectRatioMake(1, 1)), CGAspectRatioMake(1, 1)), @"Ratio not flipping correctly.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioFlip(CGAspectRatioMake(2, 2)), CGAspectRatioMake(2, 2)), @"Ratio not flipping correctly.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioFlip(CGAspectRatioMake(2, 1)), CGAspectRatioMake(1, 2)), @"Ratio not flipping correctly.");
	XCTAssertTrue(CGAspectRatioEqualToAspectRatio(CGAspectRatioFlip(CGAspectRatioMake(1, 2)), CGAspectRatioMake(2, 1)), @"Ratio not flipping correctly.");
}

- (void)testCGAspectRatioReduce
{
	CGAspectRatio ratio, reducedRatio;
	
	ratio = (CGAspectRatio) {1, 1};
	reducedRatio = CGAspectRatioReduce((CGAspectRatio) {2, 2});
	XCTAssertTrue(ratio.width == reducedRatio.width && ratio.height == reducedRatio.height, @"Ratio not reduced correctly.");
	
	ratio = (CGAspectRatio) {2, 1};
	reducedRatio = CGAspectRatioReduce((CGAspectRatio) {4, 2});
	XCTAssertTrue(ratio.width == reducedRatio.width && ratio.height == reducedRatio.height, @"Ratio not reduced correctly.");
	
	ratio = (CGAspectRatio) {1, 2};
	reducedRatio = CGAspectRatioReduce((CGAspectRatio) {2, 4});
	XCTAssertTrue(ratio.width == reducedRatio.width && ratio.height == reducedRatio.height, @"Ratio not reduced correctly.");
	
#warning this is not yet implemented.
	/*
	ratio = (CGAspectRatio) {1, 2};
	reducedRatio = CGAspectRatioReduce((CGAspectRatio) {2.5, 5});
	XCTAssertTrue(ratio.width == reducedRatio.width && ratio.height == reducedRatio.height, @"Ratio not reduced correctly.");
	 */
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
