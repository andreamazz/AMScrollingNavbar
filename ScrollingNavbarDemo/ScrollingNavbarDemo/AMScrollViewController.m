//
//  AMScrollViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMScrollViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface AMScrollViewController () <UIScrollViewDelegate, AMScrollingNavbarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerConstraint;

@end

@implementation AMScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Scroll View"];
    [self fakeContent];

    // Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];

    // Prompt support is available, but the pop action is glitchy.
//    self.navigationItem.prompt = @"Prompt text";

    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.scrollView withDelay:60];

    // Set it to YES if the scrollview being watched is contained in the main view
    // Set it to NO if the scrollview IS the main view (e.g.: subclasses of UITableViewController)
    [self setUseSuperview:YES];

    // Enable the autolayout-friendly handling of the view
    [self setScrollableViewConstraint:self.headerConstraint withOffset:60];

    // Stops the scrolling if the content fits inside the frame
    [self setShouldScrollWhenContentFits:NO];
    
    [self.scrollView setDelegate:self];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stopScroll)];

    [self setScrollingNavbarDelegate:self];
}

- (void)navigationBarDidChangeToExpanded:(BOOL)expanded {
    if (expanded) {
        NSLog(@"Nav changed to expanded");
    }
}

- (void)navigationBarDidChangeToCollapsed:(BOOL)collapsed {
    if (collapsed) {
        NSLog(@"Nav changed to collapsed");
    }
}

- (void)stopScroll {
    [self setScrollingEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:animated];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
    
    return YES;
}

- (void)dealloc {
    [self stopFollowingScrollView];
}

- (void)fakeContent {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 40)];
    [label setText:@"My content"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Futura" size:24]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:label];
    [self.view setBackgroundColor:UIColorFromRGB(0x08245d)];
    [self.scrollView setBackgroundColor:UIColorFromRGB(0x08245d)];

    // Fake some content
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 800)];
}

@end
