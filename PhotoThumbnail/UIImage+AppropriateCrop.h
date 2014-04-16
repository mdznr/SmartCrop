//
//  UIImage+AppropriateCrop.h
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CGAspectRatio.h"

@interface UIImage (AppropriateCrop)

#warning Rename methods to more closely match each other?
// Consider method name of `appropriateCropForAspectRatio:` or
// changing method name to `appropriatelyCroppedThumbnailOfSize:`

#warning TODO: Full Method Documentation

/// Returns an image that's an appropriately cropped version of the receiver at the specified aspect ratio
/// @param aspectRatio
/// @return
- (UIImage *)appropriatelyCroppedImageForAspectRatio:(CGAspectRatio)aspectRatio NS_AVAILABLE_IOS(5_0);

/// Get the rectangle for the best crop for the specified aspect ratio
/// @param aspectRatio
/// @return
- (CGRect)appropriateCropRegionForAspectRatio:(CGAspectRatio)aspectRatio NS_AVAILABLE_IOS(5_0);

/// Automatically gets aspect ratio and scales down to size (points)
/// @param thumbnailSize
/// @return
- (UIImage *)appropriateThumbnailOfSize:(CGSize)thumbnailSize NS_AVAILABLE_IOS(5_0);

@end
