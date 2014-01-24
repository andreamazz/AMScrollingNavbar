//
//  AMScollingCollectionViewController.m
//  ScrollingNavbarDemo
//
//  Created by David on 28/12/2013.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMScrollingCollectionViewController.h"

@interface AMScrollingCollectionViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;
@property (assign, nonatomic) BOOL isCompatibilityMode;
@property (assign, nonatomic) CGFloat deltaLimit;
@property (assign, nonatomic) CGFloat compatibilityHeight;

@end

@implementation AMScrollingCollectionViewController

- (void)followScrollView:(UIView*)scrollableView
{
    self.isCompatibilityMode = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending);
    [self calculateConstants];
    
	self.scrollableView = scrollableView;
	
	self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[self.panGesture setMaximumNumberOfTouches:1];
	
	[self.panGesture setDelegate:self];
	[self.scrollableView addGestureRecognizer:self.panGesture];
	
	/* The navbar fadeout is achieved using an overlay view with the same barTintColor.
	 this might be improved by adjusting the alpha component of every navbar child */
	CGRect frame = self.navigationController.navigationBar.frame;
	frame.origin = CGPointZero;
	self.overlay = [[UIView alloc] initWithFrame:frame];
    
    // Use tintColor instead of barTintColor on iOS < 7
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        if (!self.navigationController.navigationBar.barTintColor) {
            NSLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
        }
        [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    } else {
        [self.overlay setBackgroundColor:self.navigationController.navigationBar.tintColor];
    }
	
	[self.overlay setUserInteractionEnabled:NO];
	[self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.navigationController.navigationBar addSubview:self.overlay];
	[self.overlay setAlpha:0];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
}

- (void)didBecomeActive:(id)sender
{
	[self showNavbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self showNavbar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshNavbar];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect frame = self.overlay.frame;
	frame.size.height = self.navigationController.navigationBar.frame.size.height;
	self.overlay.frame = frame;
    
    [self calculateConstants]; // Update values depending on orientation
    [self updateSizingWithDelta:0]; // Refresh sizes on rotation
}

- (void)calculateConstants
{
    // Set different values for iPad/iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.deltaLimit = 24;
        self.compatibilityHeight = 64;
    } else {
        self.deltaLimit = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 24 : 12);
        self.compatibilityHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 64 : 52);
    }
}

- (void)showNavbar
{
	if (self.isCollapsed) {
		CGRect rect = self.scrollableView.frame;
		rect.origin.y = -self.compatibilityHeight; // The magic number (navbar standard size + statusbar)
		self.scrollableView.frame = rect;
		[UIView animateWithDuration:0.2 animations:^{
			self.lastContentOffset = 0;
			[self scrollWithDelta:-self.compatibilityHeight];
		}];
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
	CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
	
	float delta = self.lastContentOffset - translation.y;
	self.lastContentOffset = translation.y;
	
	[self scrollWithDelta:delta];
	
	if ([gesture state] == UIGestureRecognizerStateEnded) {
		// Reset the nav bar if the scroll is partial
		self.lastContentOffset = 0;
		[self checkForPartialScroll];
	}
}

- (void)scrollWithDelta:(CGFloat)delta
{
	CGRect frame;
	
	if (delta > 0) {
		if (self.isCollapsed) {
			return;
		}
		
		frame = self.navigationController.navigationBar.frame;
		
		if (frame.origin.y - delta < -self.deltaLimit) {
			delta = frame.origin.y + self.deltaLimit;
		}
		
		frame.origin.y = MAX(-self.deltaLimit, frame.origin.y - delta);
		self.navigationController.navigationBar.frame = frame;
		
		if (frame.origin.y == -self.deltaLimit) {
			self.isCollapsed = YES;
			self.isExpanded = NO;
		}
		
		[self updateSizingWithDelta:delta];
	}
	
	if (delta < 0) {
		if (self.isExpanded) {
			return;
		}
		
		frame = self.navigationController.navigationBar.frame;
		
		if (frame.origin.y - delta > 20) {
			delta = frame.origin.y - 20;
		}
		frame.origin.y = MIN(20, frame.origin.y - delta);
		self.navigationController.navigationBar.frame = frame;
		
		if (frame.origin.y == 20) {
			self.isExpanded = YES;
			self.isCollapsed = NO;
		}
		
		[self updateSizingWithDelta:delta];
	}
}

- (void)checkForPartialScroll
{
	CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
	
	// Get back down
	if (pos >= -2) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame;
			frame = self.navigationController.navigationBar.frame;
			CGFloat delta = frame.origin.y - 20;
			frame.origin.y = MIN(20, frame.origin.y - delta);
			self.navigationController.navigationBar.frame = frame;
			
			self.isExpanded = YES;
			self.isCollapsed = NO;
			
			[self updateSizingWithDelta:delta];
			
			// This line needs tweaking
			// [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta) animated:YES];
		}];
	} else {
		// And back up
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame;
			frame = self.navigationController.navigationBar.frame;
			CGFloat delta = frame.origin.y + 24;
			frame.origin.y = MAX(-self.deltaLimit, frame.origin.y - delta);
			self.navigationController.navigationBar.frame = frame;
			
			self.isExpanded = NO;
			self.isCollapsed = YES;
			
			[self updateSizingWithDelta:delta];
		}];
	}
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
	// At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing
	CGRect frame = self.navigationController.navigationBar.frame;
	
	// Change the alpha channel of every item on the navbr. The overlay will appear, while the other objects will disappear, and vice versa
	float alpha = (frame.origin.y + self.deltaLimit) / frame.size.height;
	[self.overlay setAlpha:1 - alpha];
	[self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* obj, NSUInteger idx, BOOL *stop) {
		obj.customView.alpha = alpha;
	}];
	[self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* obj, NSUInteger idx, BOOL *stop) {
		obj.customView.alpha = alpha;
	}];
	self.navigationItem.titleView.alpha = alpha;
	self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
	
	// Move and expand (or shrink) the superview of the given scrollview
	frame = self.scrollableView.superview.frame;
    frame.origin.y -= delta;
	frame.size.height += delta;
	self.scrollableView.superview.frame = frame;
	
	// Changing the layer's frame avoids UIWebView's glitchiness
	frame = self.scrollableView.frame;
	frame.size.height = self.scrollableView.superview.frame.size.height - frame.origin.y;
	
	// if the scrolling view is a UIWebView, we need to adjust its scrollview's frame.
	if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
		((UIWebView*)self.scrollableView).scrollView.frame = frame;
	} else {
		self.scrollableView.frame = frame;
	}
	
	// Keeps the view's scroll position steady until the navbar is gone
	if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
		[(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
	} else if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
		[((UIWebView*)self.scrollableView).scrollView setContentOffset:CGPointMake(((UIWebView*)self.scrollableView).scrollView.contentOffset.x, ((UIWebView*)self.scrollableView).scrollView.contentOffset.y - delta)];
	}
}

- (void)refreshNavbar
{
	[self.navigationController.navigationBar bringSubviewToFront:self.overlay];
}

#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}


@end
