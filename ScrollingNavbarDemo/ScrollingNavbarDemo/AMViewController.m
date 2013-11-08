//
//  AMViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea on 08/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMViewController.h"

@interface AMViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AMViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setTitle:@"Title"];

	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
	[label setText:@"My content"];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setTextColor:[UIColor whiteColor]];
	[self.scrollView addSubview:label];
	[self.scrollView setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:110.0/255.0 blue:130.0/255.0 alpha:1]];
	
	// Let's fake some content
	[self.scrollView setContentSize:CGSizeMake(320, 1200)];

	// Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
	[self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.scrollView];
}

@end
