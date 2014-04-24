//
//  CGAspectRatio.m
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "CGAspectRatio.h"

const CGAspectRatio CGAspectRatioZero = (CGAspectRatio){0, 0};

// Implementation via [Wikipedia](https://en.wikipedia.org/wiki/Binary_GCD_algorithm#Iterative_version_in_C).
unsigned int gcd(unsigned int u, unsigned int v)
{
	int shift;
	
	// GCD(0,v) == v; GCD(u,0) == u, GCD(0,0) == 0
	if (u == 0) return v;
	if (v == 0) return u;
	
	// Let shift := lg K, where K is the greatest power of 2 dividing both u and v.
	for (shift = 0; ((u | v) & 1) == 0; ++shift) {
		u >>= 1;
		v >>= 1;
	}
	
	while ((u & 1) == 0) {
		u >>= 1;
	}
	
	// From here on, u is always odd.
	do {
		// Remove all factors of 2 in v -- they are not common
		// Note: v is not zero, so while will terminate */
		while ((v & 1) == 0) {  /* Loop X */
			v >>= 1;
		}
		
		// Now u and v are both odd. Swap if necessary so u <= v,
		// then set v = v - u (which is even). For bignums, the
		// swapping is just pointer movement, and the subtraction
		// can be done in-place.
		if (u > v) {
			// Swap u and v
			unsigned int t = v; v = u; u = t;
		}
		// Here v >= u
		v = v - u;
	} while (v != 0);
	
	// Restore common factors of 2
	return u << shift;
}

CGAspectRatioRelation CGAspectRatioRelationForAspectRatio(CGAspectRatio aspectRatio)
{
	if ( aspectRatio.width > aspectRatio.height ) {
		return CGAspectRatioRelationWide;
	} else if ( aspectRatio.height > aspectRatio.width ) {
		return CGAspectRatioRelationTall;
	} else {
		return CGAspectRatioRelationSquare;
	}
}

CFDictionaryRef CGAspectRatioCreateDictionaryRepresentation(CGAspectRatio aspectRatio)
{
	NSDictionary *dictionary = @{@"w": @(aspectRatio.width),
								 @"h": @(aspectRatio.height)};
	return (__bridge CFDictionaryRef) dictionary;
}

bool CGAspectRatioEqualToAspectRatio(CGAspectRatio aspectRatio1, CGAspectRatio aspectRatio2)
{
	// Reduce ratios.
	aspectRatio1 = CGAspectRatioReduce(aspectRatio1);
	aspectRatio2 = CGAspectRatioReduce(aspectRatio2);
	
	// The width and height for both must be equal.
	return aspectRatio1.width  == aspectRatio2.width &&
		   aspectRatio1.height == aspectRatio2.height;
}

NSComparisonResult CGAspectRatioComparison(CGAspectRatio aspectRatio1, CGAspectRatio aspectRatio2)
{
	// Only want fractions greater than 1.
	CGFloat r1, r2;
	
	if ( aspectRatio1.width > aspectRatio1.height ) {
		r1 = aspectRatio1.width / aspectRatio1.height;
	} else {
		r1 = aspectRatio1.height / aspectRatio1.width;
	}
	
	if ( aspectRatio2.width > aspectRatio2.height ) {
		r2 = aspectRatio2.width / aspectRatio2.height;
	} else {
		r2 = aspectRatio2.height / aspectRatio2.width;
	}
	
	// Return the comparison.
	if ( r1 > r2 ) {
		return NSOrderedDescending;
	} else if ( r1 < r2 ) {
		return NSOrderedAscending;
	}
	
	return NSOrderedSame;
}

CGAspectRatio CGAspectRatioMake(CGFloat width, CGFloat height)
{
	// Must have non-zero dimensions.
	if ( width == 0 || height == 0 ) {
		return CGAspectRatioZero;
	}
	
#warning must they be positive? Return zero or normalize?
	
	return (CGAspectRatio) {width, height};
}

bool CGAspectRatioMakeWithDictionaryRepresentation(CFDictionaryRef dict, CGAspectRatio *aspectRatio)
{
#warning Implement CGAspectRatioMakeWithDictionaryRepresentation
	return NO;
}

CGAspectRatio CGAspectRatioFromSize(CGSize size)
{
	CGAspectRatio aspectRatio = CGAspectRatioMake(size.width, size.height);
	return CGAspectRatioReduce(aspectRatio);
}

CGAspectRatio CGAspectRatioFlip(CGAspectRatio aspectRatio)
{
	return CGAspectRatioMake(aspectRatio.height, aspectRatio.width);
}

CGAspectRatio CGAspectRatioReduce(CGAspectRatio aspectRatio)
{
#warning should this also multiply to get whole numbers first?
	
	// Find the greatest commond divisor.
	unsigned int GCD = gcd((unsigned int)aspectRatio.width, (unsigned int)aspectRatio.height);
	
	if ( GCD == 0 ) {
		return CGAspectRatioMake(aspectRatio.width, aspectRatio.height);
	}
	
	// Divide each by the GCD.
	CGFloat w = aspectRatio.width / GCD;
	CGFloat h = aspectRatio.height / GCD;
	
	// Return the reduced aspect ratio.
	return CGAspectRatioMake(w, h);
}

CGAspectRatio CGAspectRatioFromString(NSString *string)
{
	NSRange first = [string rangeOfString:@","];
	if ( first.location == NSNotFound ) {
		return CGAspectRatioZero;
	}
	NSString *firstNumber = [string substringWithRange:NSMakeRange(1, first.location-1)];
	CGFloat width = [firstNumber floatValue];
	if ( width == 0.0f ) {
		return CGAspectRatioZero;
	}
	
	NSString *secondNumber = [string substringWithRange:NSMakeRange(first.location+1, string.length-1-1-first.location)];
	CGFloat height = [secondNumber floatValue];
	if ( height == 0.0f ) {
		return CGAspectRatioZero;
	}
	
	return CGAspectRatioMake(width, height);
}

NSString * NSStringFromCGAspectRatio(CGAspectRatio aspectRatio)
{
	return [NSString stringWithFormat:@"{%.0f,%.0f}", aspectRatio.width, aspectRatio.height];
}
