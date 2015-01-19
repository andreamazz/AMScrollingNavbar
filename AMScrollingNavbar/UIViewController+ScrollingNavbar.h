//
//  UIViewController+ScrollingNavbar.h
//  ScrollingNavbarDemo
//
//  Created by Andrea on 24/03/14.
//  Copyright (c) 2014 Andrea Mazzini. All rights reserved.
//

@import Foundation;
@import UIKit;

/**-----------------------------------------------------------------------------
 * @name AMScrollingNavbarDelegate
 * -----------------------------------------------------------------------------
 */

@protocol AMScrollingNavbarDelegate <NSObject>
@optional

/** Navbar collapsed
 *
 * Called when the navbar change its state to collapsed
 */
- (void)navigationBarDidChangeToCollapsed:(BOOL)collapsed;

/** Navbar expanded
 *
 * Called when the navbar change its state to expanded
 */
- (void)navigationBarDidChangeToExpanded:(BOOL)expanded;

@end

@interface UIViewController (ScrollingNavbar) <UIGestureRecognizerDelegate>

/**-----------------------------------------------------------------------------
 * @name UIViewController+ScrollingNavbar
 * -----------------------------------------------------------------------------
 */

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Also sets the value (in points) that needs to scroll through beofre the navbar is moved back into scene
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param delay The delay of the downward scroll gesture
 */
- (void)followScrollView:(UIView *)scrollableView withDelay:(float)delay;

/** Scrolling init method with Autolayout
 *
 * Enables the scrolling on a generic UIView.
 * It requires the top constraint of the first view below the navbar.
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param constraint The top constraint of the first view below the navbar
 */
- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint;

/** Scrolling init method with Autolayout
 *
 * Enables the scrolling on a generic UIView.
 * It requires the top constraint of the first view below the navbar.
 * Also sets the value (in points) that needs to scroll through beofre the navbar is moved back into scene
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param constraint The top constraint of the first view below the navbar
 * @param delay The delay of the downward scroll gesture
 */
- (void)followScrollView:(UIView *)scrollableView usingTopConstraint:(NSLayoutConstraint *)constraint withDelay:(float)delay;

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Remember to call showNavbar or showNavBarAnimated: in your viewDidDisappear.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 */
- (void)followScrollView:(UIView *)scrollableView;

/** Navbar slide down
 *
 * Manually show the navbar
 */
- (void)showNavbar;

/** Navbar slide down
 *
 * Manually show the navbar
 *
 * @param animated Animates the navbar scrolling
 */
- (void)showNavBarAnimated:(BOOL)animated;

/** Navbar slide down
 *
 * Manually show the navbar
 */
- (void)hideNavbar;

/** Navbar slide up
 *
 * Manually hide the navbar
 *
 * @param animated Animates the navbar scrolling
 */
- (void)hideNavbarAnimated:(BOOL)animated;

/** Remove the scrollview tracking
 *
 * Use this method to stop following the navbar
 */
- (void)stopFollowingScrollView;

/** Enable or disable the scrolling
 *
 * Set this property to NO to disable the scrolling of the navbar.
 */
- (void)setScrollingEnabled:(BOOL)enabled;

/** Enable or disable the scrolling when the content size is smaller than the bounds
 *
 * Set this property to YES to enable the scrolling of the navbar even when the
 * content size of the scroll view is smaller than its height.
 */
- (void)setShouldScrollWhenContentFits:(BOOL)enabled;

/** Add scrolling to a custom view
 *
 * Enables the scrolling of a generic UIView placed underneath the navbar (e.g.: a custom header)
 * It requires the top constraint of the first view below the navbar.
 *
 * @param constraint The top constraint of the first view below the navbar
 * @param delay The height of the custom view
 */
- (void)setScrollableViewConstraint:(NSLayoutConstraint *)constraint withOffset:(CGFloat)offset;

/** AMScrollingNavbarDelegate setter
 *
 * Sets the AMScrollingNavbarDelegate
 *
 * @param scrollingNavbarDelegate The delegate
 */
- (void)setScrollingNavbarDelegate:(id <AMScrollingNavbarDelegate>)scrollingNavbarDelegate;

/** Use superview as container view
 *
 * Set the scrollable view's superview as main container.
 * Default to YES, set it to NO when using a UITableViewController or a UICollectionViewController
 *
 * @param useSuperview The BOOL flag.
 */
- (void)setUseSuperview:(BOOL)useSuperview;

@end

