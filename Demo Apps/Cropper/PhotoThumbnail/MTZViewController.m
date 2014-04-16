//
//  MTZViewController.m
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"

#import "CGRectManipulation.h"
#import "MTZActionSheet.h"
#import "UIImage+AppropriateCrop.h"

@interface MTZViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) CGAspectRatio aspectRatio;
@property (strong, nonatomic) UIImage *image;

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Default aspect ratio
//	_aspectRatio = CGAspectRatioZero;
	_aspectRatio = (CGAspectRatio){0, 0};
}


#pragma mark Change Aspect Ratio / Update Photo Thumbnail

- (void)changeAspectRatio:(CGAspectRatio)aspectRatio
{
	// Return early if value hasn't changed.
	if ( CGAspectRatioEqualToAspectRatio(aspectRatio, _aspectRatio) ) {
		return;
	}
	
	_aspectRatio = aspectRatio;
	
	// Update the photo thumbnail with the new aspect ratio
//	[self performSelectorInBackground:@selector(updatePhotoThumbnail) withObject:nil];
	
	// Update overlay mask with the crop region
	[self performSelectorInBackground:@selector(updatePhotoOverlay) withObject:nil];
}

- (void)updatePhotoOverlay
{
	CGRect crop = [_image appropriateCropRegionForAspectRatio:_aspectRatio];
	CGRect imageRect = (CGRect) {0, 0, _imageView.image.size.width, _imageView.image.size.height};
	CGRect imageFrame = CGRectScaledRectToFitInRect(imageRect, _imageView.bounds);
	imageFrame = CGRectCenterRectInRect(imageFrame, _imageView.bounds);
	crop = CGRectScaledRectToFitInRect(crop, imageFrame);
	NSLog(@"%@", NSStringFromCGRect(crop) );
	
	dispatch_async(dispatch_get_main_queue(), ^{
//		UIBezierPath *outer = [UIBezierPath bezierPathWithRect:CGRectInfinite];
		UIBezierPath *inner = [UIBezierPath bezierPathWithRect:crop];
//		[outer appendPath:inner];
		
		CAShapeLayer *mask = [CAShapeLayer layer];
		mask.path = inner.CGPath;
		
		_overlayView.layer.mask= mask;
	});
}

- (void)updatePhotoThumbnail
{
/** TIME BEGIN **/ NSDate *d = [NSDate date];
	UIImage *croppedImage = [_image appropriatelyCroppedImageForAspectRatio:_aspectRatio];
/*** TIME END ***/ NSTimeInterval elapsedTime = [d timeIntervalSinceNow]; NSLog(@"%f", elapsedTime);
	
	// Update image on main thread
	dispatch_async(dispatch_get_main_queue(), ^{
		_imageView.image = croppedImage;
	});
}


#pragma mark Toolbar Actions

// Present Image Picker View Controller
- (IBAction)didTapPhotosButton:(id)sender
{
	UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.delegate = self;
#warning TODO: configure picker for demo application
	[self presentViewController:imgPicker animated:YES completion:^{}];
}

// Present Action Sheet for Aspect Ratios
- (IBAction)didTapActionButton:(id)sender
{
	// Create action sheet with title
	MTZActionSheet *as = [[MTZActionSheet alloc] init];
	as.title = @"Change the Thumbnail's Aspect Ratio";
	
	// Add buttons to action sheet
	[as addButtonWithTitle:@"Original" andBlock:^{
//		[self changeAspectRatio:CGAspectRatioZero];
		[self changeAspectRatio:CGAspectRatioMake(0, 0)];
	}];
	[as addButtonWithTitle:@"Square"   andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(1, 1)];
	}];
	[as addButtonWithTitle:@"3 × 2"    andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(3, 2)];
	}];
	[as addButtonWithTitle:@"3 × 5"    andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(3, 5)];
	}];
	[as addButtonWithTitle:@"4 × 3"    andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(4, 3)];
	}];
	[as addButtonWithTitle:@"4 × 6"    andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(4, 6)];
	}];
	[as addButtonWithTitle:@"5 × 7"    andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(5, 7)];
	}];
	[as addButtonWithTitle:@"8 × 10"   andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(8, 10)];
	}];
	[as addButtonWithTitle:@"16 × 9"   andBlock:^{
		[self changeAspectRatio:CGAspectRatioMake(16, 9)];
	}];
	
	// Add cancel button
	as.cancelButtonTitle = @"Cancel";
	
	// Show action sheet
	[as showFromBarButtonItem:sender animated:YES];
}


#pragma mark UIImagePickerControllerDelgate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Dismiss the picker view
	[picker dismissViewControllerAnimated:YES completion:^{}];
	
	UIImage *image;
	
	// Get edited and cropped image
	image = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
	
	// Otherwise get the original image
	if ( !image ) {
		image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
	}
	
	_image = image;
	
	// Update the photo thumbnail with the new image
	[self performSelectorInBackground:@selector(updatePhotoOverlay) withObject:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark UIViewController Misc.

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
