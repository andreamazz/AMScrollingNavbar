//
//  AMScrollingNavbarViewController.m
//  AMScrollingNavbar
//
//  Created by Andrea on 08/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMScrollingNavbarViewController.h"

@interface AMScrollingNavbarViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;
@property (assign, nonatomic) BOOL isCompatibilityMode;
@property (assign, nonatomic) CGFloat deltaLimit;
@property (assign, nonatomic) CGFloat statusBar;
@property (assign, nonatomic) CGFloat compatibilityHeight;
@property (nonatomic, assign) float maxDelay;
@property (nonatomic, assign) float delayDistance;

@end

@implementation AMScrollingNavbarViewController

- (void)followScrollView:(UIView*)scrollableView
{
	[self followScrollView:scrollableView withDelay:0];
}

- (void)followScrollView:(UIView*)scrollableView withDelay:(float)delay
{
    self.isCompatibilityMode = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending);
    [self calculateConstants];
    
	self.scrollableView = scrollableView;
	
	self.scrollingEnabled = YES;
	
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
            NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: no bar tint color set");
        }
        [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    } else {
        [self.overlay setBackgroundColor:self.navigationController.navigationBar.tintColor];
    }
	
	if ([self.navigationController.navigationBar isTranslucent]) {
		NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: the navigation bar should not be translucent");
	}
	
	[self.overlay setUserInteractionEnabled:NO];
	[self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.navigationController.navigationBar addSubview:self.overlay];
	[self.overlay setAlpha:0];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	self.maxDelay = delay;
	self.delayDistance = delay;
}

- (void)didBecomeActive:(id)sender
{
	[self showNavbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self showNavBarAnimated:animated];
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
		if ([[UIApplication sharedApplication] isStatusBarHidden]) {
			self.deltaLimit = 44;
			self.compatibilityHeight = 44;
			self.statusBar = 0;
		} else {
			self.deltaLimit = 24;
			self.compatibilityHeight = 64;
			self.statusBar = 20;
		}
    } else {
		if ([[UIApplication sharedApplication] isStatusBarHidden]) {
			self.deltaLimit = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);;
			self.compatibilityHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 44 : 32);
			self.statusBar = 0;
		} else {
			self.deltaLimit = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 24 : 12);
			self.compatibilityHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? 64 : 52);
			self.statusBar = 20;
		}
    }
}

- (void)showNavBarAnimated:(BOOL)animated
{
	NSTimeInterval interval = animated ? 0.2 : 0;
	if (self.scrollableView != nil) {
		if (self.isCollapsed) {
			CGRect rect;
			if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
				rect = ((UIWebView*)self.scrollableView).scrollView.frame;
			} else {
				rect = self.scrollableView.frame;
			}
			rect.origin.y = 0;
			if ([self.scrollableView isKindOfClass:[UIWebView class]]) {
				((UIWebView*)self.scrollableView).scrollView.frame = rect;
			} else {
				self.scrollableView.frame = rect;
			}
			[UIView animateWithDuration:interval animations:^{
				self.lastContentOffset = 0;
				[self scrollWithDelta:-self.compatibilityHeight];
			}];
		} else {
			[self updateNavbarAlpha:self.compatibilityHeight];
		}
	}
}

- (void)showNavbar
{
	[self showNavBarAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
	if (self.scrollingEnabled == NO) {
		return;
	}
    
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
		
		if (self.isExpanded) {
            self.isExpanded = NO;
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
			self.delayDistance = self.maxDelay;
		}
		
		[self updateSizingWithDelta:delta];
	}
	
	if (delta < 0) {
		if (self.isExpanded) {
			return;
		}
		
		if (self.isCollapsed) {
            self.isCollapsed = NO;
        }
		
		self.delayDistance += delta;
        
		if (self.delayDistance > 0) {
			return;
		}
		
		frame = self.navigationController.navigationBar.frame;
		
		if (frame.origin.y - delta > self.statusBar) {
			delta = frame.origin.y - self.statusBar;
		}
		frame.origin.y = MIN(20, frame.origin.y - delta);
		self.navigationController.navigationBar.frame = frame;
		
		if (frame.origin.y == self.statusBar) {
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
			CGFloat delta = frame.origin.y - self.statusBar;
			frame.origin.y = MIN(20, frame.origin.y - delta);
			self.navigationController.navigationBar.frame = frame;
			
			self.isExpanded = YES;
			self.isCollapsed = NO;
			
			[self updateSizingWithDelta:delta];
		}];
	} else {
		// And back up
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame;
			frame = self.navigationController.navigationBar.frame;
			CGFloat delta = frame.origin.y + self.deltaLimit;
			frame.origin.y = MAX(-self.deltaLimit, frame.origin.y - delta);
			self.navigationController.navigationBar.frame = frame;
			
			self.isExpanded = NO;
			self.isCollapsed = YES;
			self.delayDistance = self.maxDelay;
			
			[self updateSizingWithDelta:delta];
		}];
	}
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
	[self updateNavbarAlpha:delta];
	
	// At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing
	CGRect frameNav = self.navigationController.navigationBar.frame;
	
	// Move and expand (or shrink) the superview of the given scrollview
	CGRect frame = self.scrollableView.superview.frame;
    frame.origin.y = frameNav.origin.y + frameNav.size.height;
	frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
	self.scrollableView.superview.frame = frame;
}

- (void)updateNavbarAlpha:(CGFloat)delta
{
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
}

- (void)refreshNavbar
{
	if (self.scrollableView != nil) {
		[self.navigationController.navigationBar bringSubviewToFront:self.overlay];
	}
}

@end
