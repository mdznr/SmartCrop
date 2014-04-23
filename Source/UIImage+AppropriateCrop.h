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

/// Returns an image that's an appropriately cropped version of the receiver at the specified aspect ratio.
/// @param aspectRatio The aspect ratio to crop the image to.
/// @return A new instance of @c UIImage that is an appropriately cropped version of the receiver.
- (UIImage *)appropriatelyCroppedImageForAspectRatio:(CGAspectRatio)aspectRatio NS_AVAILABLE_IOS(5_0);

/// Get the rectangle for the best crop for the specified aspect ratio.
/// @param aspectRatio The aspect ratio for the crop region.
/// @return A core graphics rectangle structure representing an appropriate crop region of the image for the specified aspect ratio.
- (CGRect)appropriateCropRegionForAspectRatio:(CGAspectRatio)aspectRatio NS_AVAILABLE_IOS(5_0);

/// Crop and resize image for use at a specific thumbnail size.
/// @param thumbnailSize The size (and consequently the aspect ratio) dictating the size of the returned image.
/// @return A new instance of @c UIImage that is an appropriately cropped and sized version of the receiver.
- (UIImage *)appropriateThumbnailOfSize:(CGSize)thumbnailSize NS_AVAILABLE_IOS(5_0);

@end
