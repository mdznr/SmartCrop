//
//  UIImage+AppropriateCrop.m
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/CGImageProperties.h>

#import "UIImage+AppropriateCrop.h"

#import "CGRectManipulation.h"
#import "UIImage+Crop.h"

typedef CGFloat(^Scoring)(CGFloat percentInclusion);

@implementation UIImage (AppropriateCrop)

const NSDictionary *scoringForFeatureTypes;

+ (void)load
{
	// Scoring for faces
	CGFloat (^scoringForFace)(CGFloat) = ^CGFloat(CGFloat percentInclusion) {
		return sqrt(percentInclusion);
	};
	
	// Dictionary of feature type to scoring blocks
	scoringForFeatureTypes = @{CIFeatureTypeFace: scoringForFace};
}


#pragma mark Public API

- (UIImage *)appropriatelyCroppedImageForAspectRatio:(CGAspectRatio)aspectRatio
{
	// Handle original aspect ratio
	if ( CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioZero) ) {
		return self;
	}
	
	CGRect cropRect = [self appropriateCropRegionForAspectRatio:aspectRatio];
	return [self croppedImageWithRect:cropRect];
}

- (CGRect)appropriateCropRegionForAspectRatio:(CGAspectRatio)aspectRatio
{
	CGSize size = [self largestCropSizeForAspectRatio:aspectRatio];
	CGRect rect = [self appropriateCropRegionForCropSize:size];
	return rect;
}

- (UIImage *)appropriateThumbnailOfSize:(CGSize)thumbnailSize
{
	CGAspectRatio ratio = CGAspectRatioMake(thumbnailSize.width, thumbnailSize.height);
	UIImage *fullImage = [self appropriatelyCroppedImageForAspectRatio:ratio];
#warning TODO: scale image down to size.
	return fullImage;
}


#pragma mark Private API

/// An array of CIFeature containing information about bounds and type of features in an image
- (NSArray *)features
{
	CIImage *myImage = [[CIImage alloc] initWithCGImage:self.CGImage];
	
	// Create face detector
	// Low accuracy is much faster, but still not fast enough
	NSDictionary *detectorOpts = @{CIDetectorAccuracy: CIDetectorAccuracyLow};
	CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
											  context:nil
											  options:detectorOpts];
	
	// Get features
	//	NSNumber *orientation = [NSNumber numberWithInt:self.imageOrientation+1];
	//	NSDictionary *featuresOpts = @{CIDetectorImageOrientation: orientation};
	//	NSArray *features = [detector featuresInImage:myImage options:featuresOpts];
	
/* TIME BEGIN *************/ NSDate *d = [NSDate date];
	NSArray *features = [detector featuresInImage:myImage];
/* TIME END ***************/ NSTimeInterval elapsedTime = [d timeIntervalSinceNow]; NSLog(@"%f", elapsedTime);
	
	return features;
}

/// The relative score for a particular crop and set of features.
- (CGFloat)scoreForCrop:(CGRect)rect andFeatures:(NSArray *)features
{
	// See what features are in the crop and their scores.
	CGFloat score = 0;
	for ( CIFeature *feature in features ) {
#warning TODO: get percentage of feature
		CGRect featureBounds = feature.bounds;
		// Flip bounds.
		featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
		if ( CGRectContainsRect(rect, featureBounds) ) {
			score++;
		}
	}
	return score;
}

/// Find the largest crop size for the specified aspect ratio
#warning Test this method, will likely have to handle rounding
- (CGSize)largestCropSizeForAspectRatio:(CGAspectRatio)aspectRatio
{
	// Handle original aspect ratio.
	if ( CGAspectRatioEqualToAspectRatio(aspectRatio, CGAspectRatioZero) ) {
		return self.size;
	}
	
	CGSize size;
	
	// The crop aspect ratio.
	aspectRatio = CGAspectRatioReduce(aspectRatio);
	CGAspectRatioRelation cropRelation = CGAspectRatioRelationForAspectRatio(aspectRatio);
	
	CGFloat largerCropDimension = MAX(aspectRatio.width, aspectRatio.height);
	
	// The image aspect ratio
	CGAspectRatio imageRatio = CGAspectRatioMake(self.size.width, self.size.height);
	CGAspectRatioRelation imageRelation = CGAspectRatioRelationForAspectRatio(imageRatio);
	
	if ( cropRelation == imageRelation ) {
		// Aspect ratios in agreement
		// Scale larger dimension of crop to fit larger dimension of image
		CGFloat largerImageDimension = MAX(self.size.width, self.size.height);
		CGFloat scale = largerImageDimension / largerCropDimension;
		size = CGSizeMake(aspectRatio.width * scale, aspectRatio.height * scale);
	} else {
		// Aspect ratios conflict
		// Scale larger dimension of crop to fit smaller dimension of image
		CGFloat smallerImageDimension = MIN(self.size.width, self.size.height);
		CGFloat scale = smallerImageDimension / largerCropDimension;
		size = CGSizeMake(aspectRatio.width * scale, aspectRatio.height * scale);
	}
	
	return size;
}

/// Finds the appropriate crop regision for a particular crop size
/// Note: Assumes cropSize fits to either the height or width of the image
- (CGRect)appropriateCropRegionForCropSize:(CGSize)cropSize
{
	// Determine whether needs to shift horizontally or vertically
	// Shift in the opposite direction of longest dimension of crop
	// Get the opposite relation by flipping size
	CGAspectRatioRelation shiftRelation = CGAspectRatioRelationForAspectRatio( CGAspectRatioFromSize(CGSizeMake(cropSize.height, cropSize.width)) );
	
	// No real relation for squares, use image relation
	if ( shiftRelation == CGAspectRatioRelationSquare ) {
		shiftRelation = CGAspectRatioRelationForAspectRatio( CGAspectRatioFromSize(self.size) );
		
		// Both are squares, no option for crop.
		if ( shiftRelation == CGAspectRatioRelationSquare ) {
			return CGRectMake(0, 0, cropSize.width, cropSize.height);
		}
	}
	
	NSArray *features = [self features];
	
	// No features
	if ( features.count == 0 ) {
#warning where to crop for no features? Middle?
		NSLog(@"No features found");
		return CGRectMake(0, 0, cropSize.width, cropSize.height);
	}
	
	NSUInteger bestCropIndex = 0;
	NSInteger bestCropScore = 0;
	
	for ( NSUInteger i=0; i<features.count; ++i ) {
		CIFeature *feature = features[i];
#warning should be able to work for all features (in the future...)?
		// Only account for some features
		CGFloat (^scoringBlock)(CGFloat) = [scoringForFeatureTypes valueForKey:feature.type];
		if ( scoringBlock == nil ) {
			// Do not account for this feature
			continue;
		} else {
			// Crop to this rectangle
			CGRect cropRect;
			
			CGRect featureBounds = feature.bounds;
			featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
			
			// Handle Wide & Tall (Square not possible at this point)
			if ( shiftRelation == CGAspectRatioRelationWide ) {
				// Use to crop to right of feature
				CGFloat maxX = CGRectGetMaxX(featureBounds);
				cropRect = (CGRect){maxX - cropSize.width, 0, cropSize.width, cropSize.height};
			} else {
				// Use to crop to bottom of feature
				CGFloat maxY = CGRectGetMaxY(featureBounds);
				cropRect = (CGRect){0, maxY - cropSize.height, cropSize.width, cropSize.height};
			}
			
			// Ensure crop fits
			cropRect = CGRectOffsetRectToFitInRect(cropRect, (CGRect){0, 0, self.size.width, self.size.height});
			
			CGFloat score = [self scoreForCrop:cropRect andFeatures:features];
			if ( score > bestCropScore ) {
				bestCropScore = score;
				bestCropIndex = i;
			}
		}
	}
	
	// Best crop to return
	CGRect bestCrop = CGRectMake(0, 0, cropSize.width, cropSize.height);
	
	// Move crop right to center leftmost and rightmost features in crop
	if ( shiftRelation == CGAspectRatioRelationWide ) {
		CGRect featureBounds = ((CIFeature *)features[bestCropIndex]).bounds;
		featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
		CGRect initialCrop = (CGRect){CGRectGetMaxX(featureBounds) - cropSize.width, 0, cropSize.width, cropSize.height};
		CGFloat currentLeftMostPoint = CGRectGetMinX(featureBounds);
		CGFloat minPossibleX = CGRectGetMinX(initialCrop);
		for ( CIFeature *feature in features ) {
			CGFloat minX = CGRectGetMinX(feature.bounds);
			if ( minX > minPossibleX && minX < currentLeftMostPoint ) {
				currentLeftMostPoint = minX;
			}
		}
		CGFloat delta = currentLeftMostPoint - minPossibleX;
		bestCrop = CGRectOffset(initialCrop, delta/2, 0);
		bestCrop = CGRectOffsetRectToFitInRect(bestCrop, (CGRect){0, 0, self.size.width, self.size.height});
	}
	
	// Move crop down to center topmost and bottommost features in crop
	else {
		CGRect featureBounds = ((CIFeature *)features[bestCropIndex]).bounds;
		featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
		CGRect initialCrop = (CGRect){0, CGRectGetMaxY(featureBounds) - cropSize.height, cropSize.width, cropSize.height};
		CGFloat currentTopMostPoint = CGRectGetMinY(featureBounds);
		CGFloat minPossibleY = CGRectGetMinY(initialCrop);
		for ( CIFeature *feature in features ) {
			CGFloat minY = CGRectGetMinY(feature.bounds);
			if ( minY > minPossibleY && minY < currentTopMostPoint ) {
				currentTopMostPoint = minY;
			}
		}
		CGFloat delta = currentTopMostPoint - minPossibleY;
		bestCrop = CGRectOffset(initialCrop, 0, delta/2);
		bestCrop = CGRectOffsetRectToFitInRect(bestCrop, (CGRect){0, 0, self.size.width, self.size.height});
	}
	
	return bestCrop;
}

///
/*
- (CGRect)featureBoundsForBestCropOfAspectRatio:(CGAspectRatio)aspectRatio
{
	CGSize cropSize = [self largestCropSizeForAspectRatio:aspectRatio];
	
	// Determine whether needs to shift horizontally or vertically
	// Shift in the opposite direction of longest dimension of crop
	// Get the opposite relation by flipping size
	CGAspectRatioRelation shiftRelation = CGAspectRatioRelationForAspectRatio( CGAspectRatioFromSize(CGSizeMake(cropSize.height, cropSize.width)) );
	
	// No real relation for squares, use image relation
	if ( shiftRelation == CGAspectRatioRelationSquare ) {
		shiftRelation = CGAspectRatioRelationForAspectRatio( CGAspectRatioFromSize(self.size) );
		
		// Both are squares, no option for crop.
		if ( shiftRelation == CGAspectRatioRelationSquare ) {
			return CGRectMake(0, 0, cropSize.width, cropSize.height);
		}
	}
	
	NSArray *features = [self features];
	
	// No features
	if ( features.count == 0 ) {
		NSLog(@"No features found");
		return CGRectMake(0, 0, cropSize.width, cropSize.height);
	}
	
	NSUInteger bestCropIndex = 0;
	NSInteger bestCropScore = 0;
	
	for ( NSUInteger i=0; i<features.count; ++i ) {
		CIFeature *feature = features[i];
#warning should be able to work for all features (in the future...)?
		// Only account for some features
		CGFloat (^scoringBlock)(CGFloat) = [scoringForFeatureTypes valueForKey:feature.type];
		if ( scoringBlock == nil ) {
			// Do not account for this feature
			continue;
		} else {
			// Crop to this rectangle
			CGRect cropRect;
			
			CGRect featureBounds = feature.bounds;
			featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
			
			// Handle Wide & Tall (Square not possible at this point)
			if ( shiftRelation == CGAspectRatioRelationWide ) {
				// Use to crop to right of feature
				CGFloat maxX = CGRectGetMaxX(featureBounds);
				cropRect = (CGRect){maxX - cropSize.width, 0, cropSize.width, cropSize.height};
			} else {
				// Use to crop to bottom of feature
				CGFloat maxY = CGRectGetMaxY(featureBounds);
				cropRect = (CGRect){0, maxY - cropSize.height, cropSize.width, cropSize.height};
			}
			
			// Ensure crop fits
			cropRect = CGRectOffsetRectToFitInRect(cropRect, (CGRect){0, 0, self.size.width, self.size.height});
			
			CGFloat score = [self scoreForCrop:cropRect andFeatures:features];
			if ( score > bestCropScore ) {
				bestCropScore = score;
				bestCropIndex = i;
			}
		}
	}
	
	CGRect featureBounds = ((CIFeature *)features[bestCropIndex]).bounds;
	featureBounds = flipCGRectVerticallyInRect(featureBounds, (CGRect){0, 0, self.size.width, self.size.height});
	
	return featureBounds;
}
 */


#pragma mark Helper Functions

/// Vertically flip a rectangle located within another rectangle
CGRect flipCGRectVerticallyInRect(CGRect rect, CGRect inRect)
{
	return CGRectMake(rect.origin.x,
					  CGRectGetMaxY(inRect) - rect.origin.y,
					  rect.size.width,
					  rect.size.height);
}

@end
