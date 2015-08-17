/*
The MIT License (MIT)

Copyright (c) 2015 Andrea Mazzini

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit

/**
    A custom `UINavigationController` that enables the scrolling of the navigation bar alongside the
    scrolling of an observed content view
*/
public class ScrollingNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    /**
        Returns true if the navbar is fully collapsed
    */
    public private(set) var collapsed = false

    /**
        Returns true if the navbar is fully expanded
    */
    public private(set) var expanded = true

    /**
        Determines wether the scrollbar should scroll when the content inside the scrollview fits
        the view's size. Defaults to `false`
    */
    public var shouldScrollWhenContentFits = false

    /**
        Determines if the scrollbar should expand once the application becomes active after entering background
        Defaults to `true`
    */
    public var expandOnActive = true

    var delayDistance: CGFloat = 0
    var maxDelay: CGFloat = 0
    var gestureRecognizer: UIPanGestureRecognizer?
    var scrollableView: UIView?
    var lastContentOffset = CGFloat(0.0)

    /**
        Start scrolling
    
        Enables the scrolling by observing a view

        :param: scrollableView The view with the scrolling content that will be observed
        :param: delay The delay expressed in points that determines the scrolling resistance. Defaults to `0`
    */
    public func followScrollView(scrollableView: UIView, delay: Double = 0) {
        self.scrollableView = scrollableView

        gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        gestureRecognizer?.maximumNumberOfTouches = 1
        gestureRecognizer?.delegate = self
        scrollableView.addGestureRecognizer(gestureRecognizer!)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didBecomeActive:"), name: UIApplicationDidBecomeActiveNotification, object: nil)

        maxDelay = CGFloat(delay)
        delayDistance = CGFloat(delay)
    }

    /**
        Hide the navigation bar

        :param: animated If true the scrolling is animated. Defaults to `true`
    */
    public func hideNavbar(animated: Bool = true) {
        if let scrollableView = self.scrollableView {
            if expanded {
                UIView.animateWithDuration(animated ? 0.1 : 0, animations: { () -> Void in
                    self.scrollWithDelta(self.fullNavbarHeight())
                    self.visibleViewController.view.setNeedsLayout()
                    if self.navigationBar.translucent {
                        let currentOffset = self.contentOffset()
                        self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + self.navbarHeight())
                    }
                })
            } else {
                updateNavbarAlpha()
            }
        }
    }

    /**
        Show the navigation bar

        :param: animated If true the scrolling is animated. Defaults to `true`
    */
    public func showNavbar(animated: Bool = true) {
        if let scrollableView = self.scrollableView {
            let tracking = gestureRecognizer?.state == .Began || gestureRecognizer?.state == .Changed
            if collapsed || tracking {
                gestureRecognizer?.enabled = false
                UIView.animateWithDuration(animated ? 0.1 : 0, animations: { () -> Void in
                    self.lastContentOffset = 0;
                    self.delayDistance = -self.fullNavbarHeight()
                    self.scrollWithDelta(-self.fullNavbarHeight())
                    self.visibleViewController.view.setNeedsLayout()
                    if self.navigationBar.translucent {
                        let currentOffset = self.contentOffset()
                        self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y - self.navbarHeight())
                    }
                    }) { _ in
                        gestureRecognizer?.enabled = true
                }
            } else {
                updateNavbarAlpha()
            }
        }
    }

    /**
    Stop observing the view and reset the navigation bar
    */
    public func stopFollowingScrollView() {
        showNavbar(animated: false)
        if let gesture = gestureRecognizer {
            scrollableView?.removeGestureRecognizer(gesture)
        }
        scrollableView = .None
        gestureRecognizer = .None
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    // MARK: - Gesture recognizer

    func handlePan(gesture: UIPanGestureRecognizer) {
        if let scrollableView = scrollableView, let superview = scrollableView.superview {
            let translation = gesture.translationInView(superview)
            let delta = lastContentOffset - translation.y
            lastContentOffset = translation.y

            if shouldScrollWithDelta(delta) {
                scrollWithDelta(delta)
            }
        }

        if gesture.state == .Ended || gesture.state == .Cancelled {
            checkForPartialScroll()
            lastContentOffset = 0
        }
    }

    // MARK: - Notification handler

    func didBecomeActive(notification: NSNotification) {
        if expandOnActive {
            showNavbar(animated: false)
        }
    }

    // MARK: - Scrolling functions

    func shouldScrollWithDelta(delta: CGFloat) -> Bool {
        // Check for rubberbanding
        if delta < 0 {
            if let scrollableView = scrollableView {
                if contentOffset().y + scrollableView.frame.size.height > contentSize().height {
                    if scrollableView.frame.size.height < contentSize().height {
                        // Only if the content is big enough
                        return false
                    }
                }
            }
        } else {
            if contentOffset().y < 0 {
                return false
            }
        }
        return true
    }

    func scrollWithDelta(var delta: CGFloat) {
        let frame = navigationBar.frame

        // View scrolling up, hide the navbar
        if delta > 0 {
            // No need to scroll if the content fits
            if !shouldScrollWhenContentFits && !collapsed {
                if scrollableView?.frame.size.height >= contentSize().height {
                    return
                }
            }

            expanded = false

            // Compute the bar position
            if frame.origin.y - delta < -deltaLimit() {
                delta = frame.origin.y + deltaLimit()
            }

            // Detect when the bar is completely collapsed
            if frame.origin.y == -deltaLimit() {
                collapsed = true
                delayDistance = maxDelay
            }
        }

        if delta < 0 {
            collapsed = false

            // Update the delay
            delayDistance += delta

            // Skip if the delay is not over yet
            if delayDistance > 0 && self.maxDelay < contentOffset().y {
                return
            }

            // Compute the bar position
            if frame.origin.y - delta > statusBar() {
                delta = frame.origin.y - statusBar()
            }

            // Detect when the bar is completely expanded
            if frame.origin.y == statusBar() {
                expanded = true
            }
        }

        updateSizing(delta)
        updateNavbarAlpha()
        restoreContentOffset(delta)
    }

    func updateSizing(delta: CGFloat) {
        var frame = navigationBar.frame

        // Move the navigation bar
        frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - delta)
        navigationBar.frame = frame

        // Resize the view if the navigation bar is not translucent
        if !navigationBar.translucent {
            let navBarY = navigationBar.frame.origin.y + navigationBar.frame.size.height
            frame = visibleViewController.view.frame
            frame.origin = CGPoint(x: frame.origin.x, y: navBarY)
            frame.size = CGSize(width: frame.size.width, height: view.frame.size.height - (navBarY))
            visibleViewController.view.frame = frame
        }
    }

    func restoreContentOffset(delta: CGFloat) {
        if navigationBar.translucent {
            return
        }

        // Hold the scroll steady until the navbar appears/disappears
        let offset = contentOffset()
        if let scrollView = scrollView() {
            if scrollView.translatesAutoresizingMaskIntoConstraints() {
                scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y - delta), animated: false)
            } else {
                if delta > 0 {
                    scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y - delta - 1), animated: false)
                } else {
                    scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y - delta + 1), animated: false)
                }
            }
        }
    }

    func checkForPartialScroll() {
        let position = navigationBar.frame.origin.y
        var frame = navigationBar.frame

        // Scroll back down
        if position >= (statusBar() - (frame.size.height / 2)) {
            let delta = frame.origin.y - statusBar()
            let duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))

            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.expanded = true
                self.collapsed = false

                self.updateSizing(delta)
                self.updateNavbarAlpha()
            }, completion: nil)
        } else {
            // Scroll up
            let delta = frame.origin.y + deltaLimit()
            let duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))

            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                self.expanded = false
                self.collapsed = true

                self.updateSizing(delta)
                self.updateNavbarAlpha()
                }, completion: nil)
        }
    }

    func updateNavbarAlpha() {
        let frame = navigationBar.frame

        // Change the alpha channel of every item on the navbr
        let alpha = (frame.origin.y + deltaLimit()) / frame.size.height

        // Hide all the possible titles
        navigationItem.titleView?.alpha = alpha
        navigationBar.tintColor = navigationBar.tintColor.colorWithAlphaComponent(alpha)
        if let titleColor = navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor {
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleColor.colorWithAlphaComponent(alpha)]
        } else {
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(alpha)]
        }

        // Hide the left items
        visibleViewController.navigationItem.leftBarButtonItem?.customView?.alpha = alpha
        if let leftItems = visibleViewController.navigationItem.leftBarButtonItems as? [UIBarButtonItem] {
            leftItems.map({ $0.customView?.alpha = alpha })
        }

        // Hide the right items
        visibleViewController.navigationItem.rightBarButtonItem?.customView?.alpha = alpha
        if let leftItems = visibleViewController.navigationItem.rightBarButtonItems as? [UIBarButtonItem] {
            leftItems.map({ $0.customView?.alpha = alpha })
        }
    }

    func deltaLimit() -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .Pad || UIScreen.mainScreen().scale == 3 {
            return portraitNavbar() - statusBar()
        } else {
            return (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ?
                portraitNavbar() - statusBar() :
                landscapeNavbar() - statusBar())
        }
    }

    // MARK: - Utilities

    func scrollView() -> UIScrollView? {
        if let webView = self.scrollableView as? UIWebView {
            return webView.scrollView
        } else {
            return scrollableView as? UIScrollView
        }
    }

    func contentOffset() -> CGPoint {
        if let scrollView = scrollView() {
            return scrollView.contentOffset
        }
        return CGPointZero
    }

    func contentSize() -> CGSize {
        if let scrollView = scrollView() {
            return scrollView.contentSize
        }
        return CGSizeZero
    }

    // MARK: - View sizing

    func fullNavbarHeight() -> CGFloat {
        return navbarHeight() + statusBar()
    }

    func navbarHeight() -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .Pad || UIScreen.mainScreen().scale == 3 {
            return portraitNavbar()
        } else {
            return (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ?
                portraitNavbar() :
                landscapeNavbar());
        }
    }

    func portraitNavbar() -> CGFloat {
         return 44 + ((self.topViewController.navigationItem.prompt != nil) ? 30 : 0)
    }

    func landscapeNavbar() -> CGFloat {
        return 32 + ((self.topViewController.navigationItem.prompt != nil) ? 22 : 0)
    }

    func statusBar() -> CGFloat {
        return UIApplication.sharedApplication().statusBarHidden ? 0 : 20
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.gestureRecognizer
    }

}
