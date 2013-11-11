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
 *
 * @param scrollableView The UIView where the scrolling is performed.
 */
- (void)followScrollView:(UIView*)scrollableView;

@end
