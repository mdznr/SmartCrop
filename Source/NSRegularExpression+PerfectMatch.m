//
//  NSRegularExpression+PerfectMatch.m
//  SmartCrop
//
//  Created by Matt Zanchelli on 4/22/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSRegularExpression+PerfectMatch.h"

@implementation NSRegularExpression (PerfectMatch)

- (BOOL)perfectlyMatchesString:(NSString *)string options:(NSMatchingOptions)options
{
	// The range of the whole string.
	NSRange range = NSMakeRange(0, string.length);
	
	// The range of the regular expression match.
	NSRange matchRange = [self rangeOfFirstMatchInString:string options:0 range:range];
	
	// Ensure the match is the whole string.
	if ( matchRange.location == range.location && matchRange.length == range.length ) {
		return YES;
	} else {
		return NO;
	}
}

@end
