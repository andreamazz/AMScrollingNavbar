//
//  AMScrollingNavbarTableViewController.h
//  AMScrollingNavbarViewController
//
//  Created by Andrea on 04/12/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

@interface AMScrollingNavbarTableViewController : UITableViewController

/**-----------------------------------------------------------------------------
 * @name AMScrollingNavbarTableViewController
 * -----------------------------------------------------------------------------
 */

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 * Also sets the value (in points) that needs to scroll through beofre the navbar is moved back into scene
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * @param delay The delay of the downward scroll gesture
 */
- (void)followScrollView:(UIView*)scrollableView withDelay:(float)delay;

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 */
- (void)followScrollView:(UIView*)scrollableView;

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

/** Navbar refresh
 *
 * Use this method when you manually change the navbar items to re-enable the fadeout
 */
- (void)refreshNavbar;

/**-----------------------------------------------------------------------------
 * @name AMScrollingNavbarTableViewController Properties
 * -----------------------------------------------------------------------------
 */

/** Enable or disable the scrolling
 *
 * Set this property to NO to disable the scrolling of the navbar.
 */
@property (nonatomic, assign) BOOL scrollingEnabled;


@end
