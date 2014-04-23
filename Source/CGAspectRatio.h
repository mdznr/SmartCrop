//
//  CGAspectRatio.h
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Aspect Ratio
typedef struct {
	CGFloat width;  // The relative width dimension of a rect.
	CGFloat height; // The relative height dimension of a rect.
} CGAspectRatio;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

/// Determining if aspect ratio is wide/tall
typedef NS_ENUM(NSInteger, CGAspectRatioRelation) {
    CGAspectRatioRelationWide,  // A wide aspect ratio. The first value is greater than the second value (e.g. 16 × 9)
    CGAspectRatioRelationTall,  // A tall aspect ratio. The second value is greater than the first value (e.g. 3 × 4)
	CGAspectRatioRelationSquare // A square aspect ratio. The values of each relative dimension are equal: (1 × 1)
};

/// Find the CGAspectRatioRelation for a given CGAspectRatio.
/// @param aspectRatio The Core Graphics Aspect Ratio to get the relation of.
/// @return A CGAspectRatioRelation describing the relation of the given aspect ratio.
CGAspectRatioRelation CGAspectRatioRelationForAspectRatio(CGAspectRatio aspectRatio);

///	The "zero" ratio -- equivalent to CGAspectRatioMake(0, 0).
/// This constant is used to represent the original apsect ratio of something.
const CGAspectRatio CGAspectRatioZero;

/// Returns a dictionary representation of the specified aspect ratio.
/// @param aspectratio An aspect ratio.
/// @return The dictionary representation of the aspect ratio.
CFDictionaryRef CGAspectRatioCreateDictionaryRepresentation(CGAspectRatio aspectRatio);

/// Returns whether two aspect ratios are effectively equal.
/// @param aspectRatio1 The first aspect ratio to examine.
/// @param aspectRatio2 The second aspect ratio to examine.
/// @return @c true if the two specified aspect ratios are effectively equal; otherwise, @c false.
bool CGAspectRatioEqualToAspectRatio(CGAspectRatio aspectRatio1, CGAspectRatio aspectRatio2);

/// Compares two aspect ratios for their extremity. This compares the aspect ratios differences against a square aspect ratio thus ignoring the relative orientation of each. This allows the question to be asked: "Is a ratio more wide than the other is tall?" etc.
/// @param aspectRatio1 The first aspect ratio to compare.
/// @param aspectRatio2 The second aspect ratio to compare.
/// @return A comparison result describing the relationship between the value of each ratio.
/// @return @c NSOrderedAscending: The second ratio is greater than the first.
/// @return @c NSOrderedDescending: The first ratio is greater than the second.
/// @return @c NSOrderedSame: The ratios are the same.
NSComparisonResult CGAspectRatioComparison(CGAspectRatio aspectRatio1, CGAspectRatio aspectRatio2);

/// Returns an aspect ratio with the specified relative dimension values.
/// @param width A relative width value.
/// @param height A relative height value.
/// @return Returns a CGAspectRatio structure with the specified width and height.
CGAspectRatio CGAspectRatioMake(CGFloat width, CGFloat height);

/// Fills in an aspect ratio using the contents of the specified dictionary.
/// @param dict A dictionary that was previously returned from the function CGAspectRatioCreateDictionaryRepresentation.
/// @param aspectRatio On return, the aspect ratio created from the specified dictionary.
/// @return @c true if successful; otherwise, @c false.
bool CGAspectRatioMakeWithDictionaryRepresentation(CFDictionaryRef dict, CGAspectRatio *aspectRatio);

/// Returns an aspect ratio from the given structure size.
/// @param size The Core Graphics size structure to convert to aspect ratio.
/// @return A Core Graphics aspect ratio structure created from the specified size structure.
CGAspectRatio CGAspectRatioFromSize(CGSize size);

/// Returns a flipped aspect ratio from the given aspect ratio.
/// @param aspectRatio The original aspect ratio to be flipped.
/// @return A Core Graphics aspect ratio structured with flipped dimensions from the specified aspect ratio structure.
CGAspectRatio CGAspectRatioFlip(CGAspectRatio aspectRatio);

/// Returns a reduced aspect ratio.
/// @param aspectRatio The aspect ratio to reduce.
/// @return A reduced aspect ratio.
CGAspectRatio CGAspectRatioReduce(CGAspectRatio aspectRatio);

/// Returns a Core Graphics aspect ratio structure corresponding to the data in a given string.
/// @param string A string whose contents are of the form “{w, h}”, where w is the width and h is the height. The w and h values can be integer or float values. An example of a valid string is @”{16.0,9.0}”. The string is not localized, so items are always separated with a comma.
/// @return A Core Graphics structure that represents an aspect ratio. If the string is not well-formed, the function returns @c CGAspectRatioZero.
/// @discussion In general, you should use this function only to convert strings that were previously created using the NSStringFromCGAspectRatio function.
CGAspectRatio CGAspectRatioFromString(NSString *string);

/// Returns a string formatted to contain the data from an aspect ratio data structure.
/// @param aspectRatio A Core Graphics structure representing an aspect ratio.
/// @return A string that corresponds to aspect ratio. See CGAspectRatioFromString for a discussion of the string format.
NSString * NSStringFromCGAspectRatio(CGAspectRatio aspectRatio);
