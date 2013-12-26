//
//  MTZViewController.m
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"

#import "MTZActionSheet.h"

@interface MTZViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	MTZActionSheet *as = [[MTZActionSheet alloc] initWithTitle:@"Change the Photo's Aspect Ratio"];
	
	// Add buttons to action sheet
	[as addButtonWithTitle:@"Original" andBlock:^{
		[self changeAspectRatio:CGSizeZero];
	}];
	[as addButtonWithTitle:@"Square"   andBlock:^{
		[self changeAspectRatio:(CGSize){1, 1}];
	}];
	[as addButtonWithTitle:@"3 × 2"    andBlock:^{
		[self changeAspectRatio:(CGSize){3, 2}];
	}];
	[as addButtonWithTitle:@"3 × 5"    andBlock:^{
		[self changeAspectRatio:(CGSize){3, 5}];
	}];
	[as addButtonWithTitle:@"4 × 3"    andBlock:^{
		[self changeAspectRatio:(CGSize){4, 3}];
	}];
	[as addButtonWithTitle:@"4 × 6"    andBlock:^{
		[self changeAspectRatio:(CGSize){4, 6}];
	}];
	[as addButtonWithTitle:@"5 × 7"    andBlock:^{
		[self changeAspectRatio:(CGSize){5, 7}];
	}];
	[as addButtonWithTitle:@"8 × 10"   andBlock:^{
		[self changeAspectRatio:(CGSize){8, 10}];
	}];
	[as addButtonWithTitle:@"16 × 9"   andBlock:^{
		[self changeAspectRatio:(CGSize){16, 9}];
	}];
	as.cancelButtonTitle = @"Cancel";
	
	// Show action sheet
	[as showFromToolbar:self.toolbar];
}

#pragma mark Change Aspect Ratio
- (void)changeAspectRatio:(CGSize)aspectRatio
{
	// Handle Original
	if ( CGSizeEqualToSize(aspectRatio, CGSizeZero) ) {
#warning Handle Original Aspect Ratio
		return;
	}
	
	NSLog(@"%@", NSStringFromCGSize(aspectRatio));
}


#pragma mark UIImagePickerControllerDelgate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Dismiss the picker view
	[picker dismissViewControllerAnimated:YES completion:^{}];
	
	/*
	 Info Dictionary Keys:
	 NSString *const UIImagePickerControllerMediaType;
	 NSString *const UIImagePickerControllerOriginalImage;
	 NSString *const UIImagePickerControllerEditedImage;
	 NSString *const UIImagePickerControllerCropRect;
	 NSString *const UIImagePickerControllerMediaURL;
	 NSString *const UIImagePickerControllerReferenceURL;
	 NSString *const UIImagePickerControllerMediaMetadata;
	 */
	
	UIImage *editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
