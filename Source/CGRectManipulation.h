//
//  CGRectManipulation.h
//
//  Created by Matt Zanchelli on 9/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

@import UIKit;

/*
 Advanced manipulation of Core Graphics rectangle structures
 */

/// Returns an offset rectangle to fit inside another rectangle.
/// @param rect The rectangle to offset.
/// @param inRect The rectangle to move into.
/// @return A rectangle that has been offset as little as possible to fit inside the given rectangle.
/// @discussion Returns @c CGRectZero if the rectangle cannot fit within the given rectangle.
CGRect CGRectOffsetRectToFitInRect(CGRect rect, CGRect inRect);

/// Returns a rectangle with an origin that is offset from that of the source rectangle.
/// @param rect The source rectangle.
/// @param scale The scale value to multiply the origin and dimensions of the rect.
/// @return A rectangle that has been scaled by a multiplier.
/// @discussion Both the origin and dimensions are multiplied by the scale
CGRect CGRectScale(CGRect rect, CGFloat scale);

/// Scales up or down a rectangle to fit (centered) inside another rectangle.
/// @param rect The rectangle to scale.
/// @param inRect The rectangle to fit to.
/// @return A core graphics rectangle structure with the same aspect ratio as @c rect that is centered within @c inRect.
CGRect CGRectScaledRectToFitInRect(CGRect rect, CGRect inRect);

/// Centers a rectangle inside another rectangle by offsetting it.
/// @param rect The rectangle to center.
/// @param inRect The rectangle to center to.
/// @return A core graphics rectangle structure that has been offset to center within @c inRect.
CGRect CGRectCenterRectInRect(CGRect rect, CGRect inRect);

///	Centers a rectangle around a point.
/// @param rect The rectangle to center.
///	@param centerPoint The point to center the rectangle around.
///	@return A core graphcis rectangle structure that has been offset to center around @c centerPoint.
CGRect CGRectCenterAroundPoint(CGRect rect, CGPoint centerPoint);

///	Create a core graphics rectangle structure with a core graphics size structure.
///	@param size The size of the rect.
///	@return A rectangle with the correct size and the origin at @c CGPointZero.
CGRect CGRectMakeWithSize(CGSize size);
