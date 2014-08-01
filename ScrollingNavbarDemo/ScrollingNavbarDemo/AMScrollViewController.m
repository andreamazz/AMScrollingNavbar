//
//  AMScrollViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMScrollViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface AMScrollViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AMScrollViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setTitle:@"Scroll View"];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
	[label setText:@"My content"];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[UIFont fontWithName:@"Futura" size:24]];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[self.scrollView addSubview:label];
	[self.view setBackgroundColor:UIColorFromRGB(0x08245d)];
	[self.scrollView setBackgroundColor:UIColorFromRGB(0x08245d)];
	
	// Let's fake some content
	[self.scrollView setContentSize:CGSizeMake(320, 840)];
	
	// Set the barTintColor (if available). This will determine the overlay that fades in and out upon scrolling.
	if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
		[self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
	}
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.scrollView withDelay:60];
	
	[self.scrollView setDelegate:self];
	
	self.navigationItem.rightBarButtonItem =
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}

@end
