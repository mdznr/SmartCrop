//
//  CGRectManipulation.m
//
//  Created by Matt Zanchelli on 9/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "CGRectManipulation.h"

#import "CGAspectRatio.h"

CGRect CGRectOffsetRectToFitInRect(CGRect rect, CGRect inRect)
{
	// Ensure it is possible.
	if ( rect.size.width > inRect.size.width || rect.size.height > inRect.size.height ) {
		// It is not possible to fit.
		return CGRectZero;
	}
	
	// Already fits, return early.
	if ( CGRectContainsRect(inRect, rect) ) {
		return rect;
	}
	
	// No offset by default.
	CGFloat dx = 0;
	CGFloat dy = 0;
	
	// Handle x overflow.
	if ( CGRectGetMaxX(rect) > CGRectGetMaxX(inRect) ) {
		dx = CGRectGetMaxX(inRect) - CGRectGetMaxX(rect);
	} else if ( CGRectGetMinX(rect) < CGRectGetMinX(inRect) ) {
		dx = CGRectGetMinX(inRect) - CGRectGetMinX(rect);
	}
	
	// Handle y overflow.
	if ( CGRectGetMaxY(rect) > CGRectGetMaxY(inRect) ) {
		dy = CGRectGetMaxY(inRect) - CGRectGetMaxY(rect);
	} else if ( CGRectGetMinY(rect) < CGRectGetMinY(inRect) ) {
		dy = CGRectGetMinY(inRect) - CGRectGetMinY(rect);
	}
	
	return CGRectOffset(rect, dx, dy);
}

CGRect CGRectScale(CGRect rect, CGFloat scale)
{
	return CGRectMake(rect.origin.x    * scale,
					  rect.origin.y    * scale,
					  rect.size.width  * scale,
					  rect.size.height * scale);
}

CGRect CGRectScaledRectToFitInRect(CGRect rect, CGRect inRect)
{
	CGAspectRatio ratio1 = CGAspectRatioFromSize(rect.size);
	CGAspectRatioRelation rel1 = CGAspectRatioRelationForAspectRatio(ratio1);
	
	CGAspectRatio ratio2 = CGAspectRatioFromSize(inRect.size);
	CGAspectRatioRelation rel2 = CGAspectRatioRelationForAspectRatio(ratio2);
	
	CGAspectRatioRelation scaleRelation;
	CGFloat scale;
	if ( rel1 == rel2 ) {
		// The inner and outer rect ratios are the same relation
		// Find which ratio is greater
		NSComparisonResult ratioComparison = CGAspectRatioComparison(ratio1, ratio2);
		if ( ratioComparison == NSOrderedDescending ) {
			// Inner rect is greater
			// Scale larger side of inner to same side of outer
			if ( rel1 == CGAspectRatioRelationTall ) {
				scale = rect.size.height / inRect.size.height;
			} else {
				scale = rect.size.width / inRect.size.width;
			}
		} else if ( ratioComparison == NSOrderedAscending ) {
			// Outer rect is greater
			// Scale smaller side of inner to same side of outer
			if ( rel1 == CGAspectRatioRelationTall ) {
				scale = inRect.size.width / rect.size.width;
			} else {
				scale = inRect.size.height / rect.size.height;
			}
		} else {
			// NSOrderedSame
			// Equal, doesn't matter which dimension.
			scale = inRect.size.width / rect.size.width;
		}
	} else {
		// The inner and outer aspect ratios conflict
		// Scale the larger side of the inner to the smaller side of the outer
		scaleRelation = rel1;
		
		if ( rel1 == CGAspectRatioRelationTall ) {
			scale = inRect.size.height / rect.size.height;
		} else {
			scale = inRect.size.width / rect.size.width;
		}
	}
	
	CGRect newRect = CGRectScale(rect, scale);
	
	newRect = CGRectCenterRectInRect(newRect, inRect);
	
	return newRect;
}

CGRect CGRectCenterRectInRect(CGRect rect, CGRect inRect)
{
	CGFloat dWidth = inRect.size.width - rect.size.width;
	CGFloat dHeight = inRect.size.height - rect.size.height;
	CGFloat dx = inRect.origin.x - rect.origin.x + (dWidth/2);
	CGFloat dy = inRect.origin.y - rect.origin.y + (dHeight/2);
	CGRect newRect = CGRectOffset(rect, dx, dy);
	return newRect;
}

CGRect CGRectMakeWithSize(CGSize size)
{
	return (CGRect){CGPointZero, size};
}
