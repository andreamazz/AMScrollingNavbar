//
//  AMScrollViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMScrollViewController.h"

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
	[label setTextColor:[UIColor whiteColor]];
	[self.scrollView addSubview:label];
	[self.view setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:110.0/255.0 blue:130.0/255.0 alpha:1]];
	[self.scrollView setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:110.0/255.0 blue:130.0/255.0 alpha:1]];
	
	// Let's fake some content
	[self.scrollView setContentSize:CGSizeMake(320, 840)];
	
	// Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
	[self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
	
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.scrollView];
	
	[self.scrollView setDelegate:self];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}

@end
