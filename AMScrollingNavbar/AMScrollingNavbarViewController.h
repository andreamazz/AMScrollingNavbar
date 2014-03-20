//
//  AMScrollingNavbarViewController.h
//  AMScrollingNavbar
//
//  Created by Andrea on 08/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMScrollingNavbarViewController : UIViewController

/**-----------------------------------------------------------------------------
 * @name AMScrollingNavbarViewController
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

/** Navbar refresh
 *
 * Use this method when you manually change the navbar items to re-enable the fadeout
 */
- (void)refreshNavbar;

/**-----------------------------------------------------------------------------
 * @name AMScrollingNavbarViewController Properties
 * -----------------------------------------------------------------------------
 */

/** Enable or disable the scrolling
 *
 * Set this property to NO to disable the scrolling of the navbar.
 */
@property (nonatomic, assign) BOOL scrollingEnabled;

@end
