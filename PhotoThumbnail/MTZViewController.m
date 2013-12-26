//
//  MTZViewController.m
//  PhotoThumbnail
//
//  Created by Matt on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"

@interface MTZViewController ()

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Title
	self.title = @"Thumbnails";
	
	// Image Picker Navigation Item
	UIBarButtonItem *photos = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(didTapPhotosButton:)];
	self.navigationItem.rightBarButtonItem = photos;
	
	// Show Navigation Bar
	self.navigationController.navigationBarHidden = NO;
}

// Present Image Picker View Controller
- (void)didTapPhotosButton:(id)sender
{
	UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
	[self presentViewController:imgPicker animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
