//
//  UIViewController+ScrollingNavbar.m
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

#define IS_IPHONE_6_PLUS [UIScreen mainScreen].scale == 3
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "UIViewController+ScrollingNavbar.h"
#import <objc/runtime.h>

@implementation UIViewController (ScrollingNavbar)

- (void)setUseSuperview:(BOOL)useSuperview { objc_setAssociatedObject(self, @selector(useSuperview), [NSNumber numberWithBool:useSuperview], OBJC_ASSOCIATION_RETAIN);}
- (BOOL)useSuperview { return [objc_getAssociatedObject(self, @selector(useSuperview)) boolValue]; }

- (void)setExpandOnActive:(BOOL)expandOnActive { objc_setAssociatedObject(self, @selector(expandOnActive), [NSNumber numberWithBool:expandOnActive], OBJC_ASSOCIATION_RETAIN);}
- (BOOL)expandOnActive { return [objc_getAssociatedObject(self, @selector(expandOnActive)) boolValue]; }

- (void)setScrollingNavbarDelegate:(id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { objc_setAssociatedObject(self, @selector(scrollingNavbarDelegate), scrollingNavbarDelegate, OBJC_ASSOCIATION_ASSIGN); }
- (id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate { return objc_getAssociatedObject(self, @selector(scrollingNavbarDelegate)); }

- (void)setScrollableViewConstraint:(NSLayoutConstraint *)scrollableViewConstraint { objc_setAssociatedObject(self, @selector(scrollableViewConstraint), scrollableViewConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableViewConstraint { return objc_getAssociatedObject(self, @selector(scrollableViewConstraint)); }

- (void)setScrollableHeaderConstraint:(NSLayoutConstraint *)scrollableHeaderConstraint { objc_setAssociatedObject(self, @selector(scrollableHeaderConstraint), scrollableHeaderConstraint, OBJC_ASSOCIATION_RETAIN); }
- (NSLayoutConstraint *)scrollableHeaderConstraint { return objc_getAssociatedObject(self, @selector(scrollableHeaderConstraint)); }

- (void)setScrollableHeaderOffset:(float)scrollableHeaderOffset { objc_setAssociatedObject(self, @selector(scrollableHeaderOffset), [NSNumber numberWithFloat:scrollableHeaderOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)scrollableHeaderOffset { return [objc_getAssociatedObject(self, @selector(scrollableHeaderOffset)) floatValue]; }

- (void)setPanGesture:(UIPanGestureRecognizer *)panGesture { objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN); }
- (UIPanGestureRecognizer*)panGesture {	return objc_getAssociatedObject(self, @selector(panGesture)); }

- (void)setScrollableView:(UIView *)scrollableView { objc_setAssociatedObject(self, @selector(scrollableView), scrollableView, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)scrollableView { return objc_getAssociatedObject(self, @selector(scrollableView)); }

- (void)setOverlay:(UIView *)overlay { objc_setAssociatedObject(self, @selector(overlay), overlay, OBJC_ASSOCIATION_RETAIN); }
- (UIView *)overlay { return objc_getAssociatedObject(self, @selector(overlay)); }

- (void)setCollapsed:(BOOL)collapsed {
    if (collapsed != self.collapsed) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToCollapsed:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToCollapsed:collapsed];
        }
    }
    objc_setAssociatedObject(self, @selector(collapsed), [NSNumber numberWithBool:collapsed], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)collapsed {	return [objc_getAssociatedObject(self, @selector(collapsed)) boolValue]; }

- (void)setExpanded:(BOOL)expanded {
    if (expanded != self.expanded) {
        if ([self.scrollingNavbarDelegate respondsToSelector:@selector(navigationBarDidChangeToExpanded:)]) {
            [self.scrollingNavbarDelegate navigationBarDidChangeToExpanded:expanded];
        }
    }
    objc_setAssociatedObject(self, @selector(expanded), [NSNumber numberWithBool:expanded], OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)expanded { return [objc_getAssociatedObject(self, @selector(expanded)) boolValue]; }

- (void)setLastContentOffset:(float)lastContentOffset { objc_setAssociatedObject(self, @selector(lastContentOffset), [NSNumber numberWithFloat:lastContentOffset], OBJC_ASSOCIATION_RETAIN); }
- (float)lastContentOffset { return [objc_getAssociatedObject(self, @selector(lastContentOffset)) floatValue]; }

- (void)setMaxDelay:(float)maxDelay { objc_setAssociatedObject(self, @selector(maxDelay), [NSNumber numberWithFloat:maxDelay], OBJC_ASSOCIATION_RETAIN); }
- (float)maxDelay { return [objc_getAssociatedObject(self, @selector(maxDelay)) floatValue]; }

- (void)setDelayDistance:(float)delayDistance { objc_setAssociatedObject(self, @selector(delayDistance), [NSNumber numberWithFloat:delayDistance], OBJC_ASSOCIATION_RETAIN); }
- (float)delayDistance { return [objc_getAssociatedObject(self, @selector(delayDistance)) floatValue]; }

- (void)setShouldScrollWhenContentFits:(BOOL)shouldScrollWhenContentFits { objc_setAssociatedObject(self, @selector(shouldScrollWhenContentFits), [NSNumber numberWithBool:shouldScrollWhenContentFits], OBJC_ASSOCIATION_RETAIN); }
- (BOOL)shouldScrollWhenContentFits {	return [objc_getAssociatedObject(self, @selector(shouldScrollWhenContentFits)) boolValue]; }

- (void)setScrollableViewConstraint:(NSLayoutConstraint *)constraint withOffset:(CGFloat)offset {
    self.scrollableHeaderConstraint = constraint;
    self.scrollableHeaderOffset = offset;
}

- (void)followScrollView:(UIView *)scrollableView {
    [self followScrollView:scrollableView withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay {
    [self followScrollView:scrollableView usingTopConstraint:nil withDelay:delay];
}

- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint {
    [self followScrollView:scrollableView usingTopConstraint:constraint withDelay:0];
}

- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint withDelay:(float)delay {
    self.scrollableView = scrollableView;
    self.scrollableViewConstraint = constraint;

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];

    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];

    self.expanded = YES;

    self.expandOnActive = YES;

    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.size = CGSizeMake(frame.size.width, [self navbarHeight] - [self statusBar]);
    frame.origin = CGPointZero;

    if (!self.overlay) {
        self.overlay = [[UIView alloc] initWithFrame:frame];

        if (self.navigationController.navigationBar.barTintColor) {
            [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
        } else if ([UINavigationBar appearance].barTintColor) {
            [self.overlay setBackgroundColor:[UINavigationBar appearance].barTintColor];
        } else {
            NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: no bar tint color set");
        }

        if ([self.navigationController.navigationBar isTranslucent]) {
            NSLog(@"[%s]: %@", __PRETTY_FUNCTION__, @"[AMScrollingNavbarViewController] Warning: the navigation bar should not be translucent");
        }

        [self.overlay setUserInteractionEnabled:NO];
        [self.overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.navigationController.navigationBar addSubview:self.overlay];
        [self.overlay setAlpha:0];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    self.maxDelay = delay;
    self.delayDistance = delay;
    self.shouldScrollWhenContentFits = NO;
}

- (void)stopFollowingScrollView {
    [self showNavBarAnimated:NO];
    [self.scrollableView removeGestureRecognizer:self.panGesture];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    self.scrollableView = nil;
    self.panGesture = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didBecomeActive:(id)sender {
    // This works fine in iOS8 without the ugly delay. Oh well.
    NSTimeInterval time = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? 0 : 0.1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.expandOnActive) {
            [self showNavbar];
        }
    });
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect frame = self.overlay.frame;
    frame.size.height = self.navigationController.navigationBar.frame.size.height;
    self.overlay.frame = frame;

    [self updateSizingWithDelta:0];
}

- (float)deltaLimit {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || IS_IPHONE_6_PLUS) {
        return [self portraitNavbar] - [self statusBar];
    } else {
        return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ?
                [self portraitNavbar] - [self statusBar]:
                [self landscapeNavbar] - [self statusBar]);
    }
}

- (float)portraitNavbar {
    return 44 + ((self.navigationItem.prompt != nil) ? 30 : 0);
}

- (float)landscapeNavbar {
    return 32 + ((self.navigationItem.prompt != nil) ? 22 : 0);
}

- (float)statusBar {
    return ([[UIApplication sharedApplication] isStatusBarHidden]) ? 0 : 20;
}

- (float)navbarHeight {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || IS_IPHONE_6_PLUS) {
        return [self portraitNavbar] + [self statusBar];
    } else {
        return (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ?
                [self portraitNavbar] + [self statusBar] :
                [self landscapeNavbar] + [self statusBar]);
    }
}

- (void)hideNavbar {
    [self hideNavbarAnimated:YES];
}

- (void)hideNavbarAnimated:(BOOL)animated {
    if (self.scrollableView != nil) {
        if (self.expanded) {
            if (!self.scrollableViewConstraint) {
                // Frame version
                CGRect rect = [self scrollView].frame;
                rect.origin.y = self.navbarHeight;
                [self scrollView].frame = rect;
            }
            [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                [self scrollWithDelta:self.navbarHeight];
                [self.view setNeedsLayout];
            }];
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)showNavBarAnimated:(BOOL)animated {
    if (self.scrollableView != nil) {
        BOOL isTracking = (self.panGesture.state == UIGestureRecognizerStateBegan ||
                           self.panGesture.state == UIGestureRecognizerStateChanged);
        if (self.collapsed || isTracking) {
            self.panGesture.enabled = NO;
            if (!self.scrollableViewConstraint) {
                // Frame version
                CGRect rect = [self scrollView].frame;
                rect.origin.y = 0;
                [self scrollView].frame = rect;
            }
            [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
                self.scrollableHeaderConstraint.constant = 0;
                self.lastContentOffset = 0;
                self.delayDistance = -self.navbarHeight;
                [self scrollWithDelta:-self.navbarHeight];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.panGesture.enabled = YES;
            }];
        } else {
            [self updateNavbarAlpha:self.navbarHeight];
        }
    }
}

- (void)showNavbar {
    [self showNavBarAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)setScrollingEnabled:(BOOL)enabled {
    self.panGesture.enabled = enabled;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (self.scrollableView != nil) {
        [self.navigationController.navigationBar bringSubviewToFront:self.overlay];
    }

    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;

    if ([self checkRubberbanding:delta]) {
        [self scrollWithDelta:delta];
    }

    if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
        // Reset the nav bar if the scroll is partial
        [self checkForPartialScroll];
        [self checkForHeaderPartialScroll];
        self.lastContentOffset = 0;
    }
}

- (BOOL)checkRubberbanding:(CGFloat)delta {
    // Prevents the navbar from moving during the 'rubberband' scroll
    if (delta < 0) {
        if ([self contentoffset].y + self.scrollableView.frame.size.height > [self contentSize].height) {
            if (self.scrollableView.frame.size.height < [self contentSize].height) { // Only if the content is big enough
                return NO;
            }
        }
    } else {
        if ([self contentoffset].y < 0) {
            return NO;
        }
    }
    return YES;
}

- (void)scrollWithDelta:(CGFloat)delta
{
    CGRect frame = self.navigationController.navigationBar.frame;

    // Scrolling the view up, hiding the navbar
    if (delta > 0) {
        if (!self.shouldScrollWhenContentFits && !self.collapsed) {
            if (self.scrollableView.frame.size.height >= [self contentSize].height) {
                return;
            }
        }
        if (self.collapsed) {
            if (self.scrollableHeaderConstraint.constant > -self.scrollableHeaderOffset) {
                self.scrollableHeaderConstraint.constant -= delta;
                if (self.scrollableHeaderConstraint.constant < -self.scrollableHeaderOffset) {
                    self.scrollableHeaderConstraint.constant = -self.scrollableHeaderOffset;
                }
                [self.view setNeedsLayout];
            }
            return;
        }

        if (self.expanded) {
            self.expanded = NO;
        }

        if (frame.origin.y - delta < -self.deltaLimit) {
            delta = frame.origin.y + self.deltaLimit;
        }

        frame.origin.y = MAX(-self.deltaLimit, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;

        if (frame.origin.y == -self.deltaLimit) {
            self.collapsed = YES;
            self.expanded = NO;
            self.delayDistance = self.maxDelay;
        }

        [self updateSizingWithDelta:delta];
        [self restoreContentoffset:delta];
    }

    // Scrolling the view down, revealing the navbar
    if (delta < 0) {
        if (self.expanded) {
            if (self.scrollableHeaderConstraint.constant < 0) {
                self.scrollableHeaderConstraint.constant -= delta;
                if (self.scrollableHeaderConstraint.constant > 0) {
                    self.scrollableHeaderConstraint.constant = 0;
                }
                [self.view setNeedsLayout];
            }
            return;
        }

        if (self.collapsed) {
            self.collapsed = NO;
        }

        self.delayDistance += delta;

        if (self.delayDistance > 0 && self.maxDelay < [self scrollView].contentOffset.y) {
            return;
        }

        if (frame.origin.y - delta > self.statusBar) {
            delta = frame.origin.y - self.statusBar;
        }
        frame.origin.y = MIN(20, frame.origin.y - delta);
        self.navigationController.navigationBar.frame = frame;

        if (frame.origin.y == self.statusBar) {
            self.expanded = YES;
            self.collapsed = NO;
        }

        [self updateSizingWithDelta:delta];
        [self restoreContentoffset:delta];
    }
}

- (UIScrollView *)scrollView {
    UIScrollView *scroll;
    if ([self.scrollableView respondsToSelector:@selector(scrollView)]) {
        scroll = [self.scrollableView performSelector:@selector(scrollView)];
    } else if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
        scroll = (UIScrollView *)self.scrollableView;
    }
    return scroll;
}

- (void)restoreContentoffset:(float)delta {
    // Hold the scroll steady until the navbar appears/disappears
    CGPoint offset = [[self scrollView] contentOffset];

    if ([[self scrollView] respondsToSelector:@selector(translatesAutoresizingMaskIntoConstraints)] && [self scrollView].translatesAutoresizingMaskIntoConstraints) {
        [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta}];
    } else {
        if (delta > 0) {
            [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta - 1}];
        } else {
            [[self scrollView] setContentOffset:(CGPoint){offset.x, offset.y - delta + 1}];
        }
    }
}

- (CGPoint)contentoffset {
    return [[self scrollView] contentOffset];
}

- (CGSize)contentSize {
    return [[self scrollView] contentSize];
}

- (void)checkForHeaderPartialScroll {
    CGFloat offset = 0;
    if (self.scrollableHeaderConstraint.constant <= -self.scrollableHeaderOffset / 2) {
        offset = -self.scrollableHeaderOffset;
    } else {
        offset = 0;
    }
    NSTimeInterval duration = ABS((self.scrollableHeaderConstraint.constant - self.scrollableHeaderOffset) * 0.2);
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollableHeaderConstraint.constant = offset;
        [self.view setNeedsLayout];
    } completion:nil];
}

- (void)checkForPartialScroll {
    CGFloat pos = self.navigationController.navigationBar.frame.origin.y;
    __block CGRect frame = self.navigationController.navigationBar.frame;

    // Get back down
    if (pos >= (self.statusBar - frame.size.height / 2)) {
        CGFloat delta = frame.origin.y - self.statusBar;
        NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            frame.origin.y = self.statusBar;
            self.navigationController.navigationBar.frame = frame;

            self.expanded = YES;
            self.collapsed = NO;

            [self updateSizingWithDelta:delta];
        } completion:nil];
    } else {
        // And back up
        CGFloat delta = frame.origin.y + self.deltaLimit;
        NSTimeInterval duration = ABS((delta / (frame.size.height / 2)) * 0.2);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            frame.origin.y = -self.deltaLimit;
            self.navigationController.navigationBar.frame = frame;

            self.expanded = NO;
            self.collapsed = YES;

            [self updateSizingWithDelta:delta];
        } completion:nil];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta {
    [self updateNavbarAlpha:delta];

    // At this point the navigation bar is already been placed in the right position, it'll be the reference point for the other views'sizing
    CGRect frameNav = self.navigationController.navigationBar.frame;

    // Move and expand (or shrink) the superview of the given scrollview
    CGRect frame = self.useSuperview ? self.scrollableView.superview.frame : self.scrollableView.frame;
    frame.origin.y = frameNav.origin.y + frameNav.size.height;

    if (self.scrollableViewConstraint) {
        // properly handle constraint commutativity
        // (when programmatically constraining the topLayoutGuide, it may be either the first or second view in the relation)
        CGFloat directionMultiplier = -1;
        if ([self.scrollableViewConstraint.firstItem conformsToProtocol:@protocol(UILayoutSupport)]) {
            directionMultiplier = 1;
        }

        self.scrollableViewConstraint.constant = directionMultiplier * ([self navbarHeight] - frame.origin.y);
    } else {
        frame.size.height = [UIScreen mainScreen].bounds.size.height - frame.origin.y;
        if (self.useSuperview) {
            self.scrollableView.superview.frame = frame;
        } else {
            self.scrollableView.frame = frame;
        }
    }

    [self.view setNeedsLayout];
}

- (void)updateNavbarAlpha:(CGFloat)delta {
    CGRect frame = self.navigationController.navigationBar.frame;

    // Change the alpha channel of every item on the navbr. The overlay will appear, while the other objects will disappear, and vice versa
    float alpha = (frame.origin.y + self.deltaLimit) / frame.size.height;
    [self.overlay setAlpha:1 - alpha];
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        obj.customView.alpha = alpha;
    }];
    self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

@end
