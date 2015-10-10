import UIKit

/**
Scrolling Navigation Bar delegate protocol
*/
@objc public protocol ScrollingNavigationControllerDelegate {
    /**
    Called when the state of the navigation bar changes
    */
    optional func scrollingNavigationController(controller: ScrollingNavigationController, didChangeState state: NavigationBarState)
}

/**
The state of the navigation bar
*/
@objc public enum NavigationBarState: Int {
    case Collapsed, Expanded, Scrolling
}

/**
A custom `UINavigationController` that enables the scrolling of the navigation bar alongside the
scrolling of an observed content view
*/
public class ScrollingNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    /**
    Returns the `NavigationBarState` of the navigation bar
    */
    public private(set) var state: NavigationBarState = .Expanded {
        didSet {
            if state != oldValue {
                scrollingNavbarDelegate?.scrollingNavigationController?(self, didChangeState: state)
            }
        }
    }

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

    /**
    The delegate for the scrolling navbar controller
    */
    public var scrollingNavbarDelegate: ScrollingNavigationControllerDelegate?

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didRotate:"), name: UIDeviceOrientationDidChangeNotification, object: nil)

        maxDelay = CGFloat(delay)
        delayDistance = CGFloat(delay)
    }

    /**
    Hide the navigation bar

    :param: animated If true the scrolling is animated. Defaults to `true`
    */
    public func hideNavbar(animated animated: Bool = true) {
        guard let _ = self.scrollableView, visibleViewController = self.visibleViewController else {
            return
        }

        if state == .Expanded {
            self.state = .Scrolling
            UIView.animateWithDuration(animated ? 0.1 : 0, animations: { () -> Void in
                self.scrollWithDelta(self.fullNavbarHeight())
                visibleViewController.view.setNeedsLayout()
                if self.navigationBar.translucent {
                    let currentOffset = self.contentOffset()
                    self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + self.navbarHeight())
                }
                }) { _ in
                    self.state = .Collapsed
            }
        } else {
            updateNavbarAlpha()
        }
    }

    /**
    Show the navigation bar

    :param: animated If true the scrolling is animated. Defaults to `true`
    */
    public func showNavbar(animated animated: Bool = true) {
        guard let _ = self.scrollableView, visibleViewController = self.visibleViewController else {
            return
        }

        if state == .Collapsed {
            gestureRecognizer?.enabled = false
            self.state = .Scrolling
            UIView.animateWithDuration(animated ? 0.1 : 0, animations: {
                self.lastContentOffset = 0;
                self.delayDistance = -self.fullNavbarHeight()
                self.scrollWithDelta(-self.fullNavbarHeight())
                visibleViewController.view.setNeedsLayout()
                if self.navigationBar.translucent {
                    let currentOffset = self.contentOffset()
                    self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y - self.navbarHeight())
                }
                }) { _ in
                    self.state = .Expanded
                    self.gestureRecognizer?.enabled = true
            }
        } else {
            updateNavbarAlpha()
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
        scrollingNavbarDelegate = .None
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

    // MARK: - Rotation handler

    func didRotate(notification: NSNotification) {
        showNavbar()
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
            if !shouldScrollWhenContentFits && state != .Collapsed {
                if scrollableView?.frame.size.height >= contentSize().height {
                    return
                }
            }

            // Compute the bar position
            if frame.origin.y - delta < -deltaLimit() {
                delta = frame.origin.y + deltaLimit()
            }

            // Detect when the bar is completely collapsed
            if frame.origin.y == -deltaLimit() {
                state = .Collapsed
                delayDistance = maxDelay
            } else {
                state = .Scrolling
            }
        }

        if delta < 0 {
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
                state = .Expanded
            } else {
                state = .Scrolling
            }
        }

        updateSizing(delta)
        updateNavbarAlpha()
        restoreContentOffset(delta)
    }

    func updateSizing(delta: CGFloat) {
        guard let visibleViewController = self.visibleViewController else {
            return
        }

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
        if navigationBar.translucent || delta == 0 {
            return
        }

        // Hold the scroll steady until the navbar appears/disappears
        let offset = contentOffset()
        if let scrollView = scrollView() {
            scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y - delta), animated: false)
        }
    }

    func checkForPartialScroll() {
        let frame = navigationBar.frame
        var duration = NSTimeInterval(0)
        var delta = CGFloat(0.0)

        // Scroll back down
        if navigationBar.frame.origin.y >= (statusBar() - (frame.size.height / 2)) {
            delta = frame.origin.y - statusBar()
            duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))
            state = .Expanded
        } else {
            // Scroll up
            delta = frame.origin.y + deltaLimit()
            duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))
            state = .Collapsed
        }
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.updateSizing(delta)
            self.updateNavbarAlpha()
            }, completion: nil)
    }

    func updateNavbarAlpha() {
        guard let visibleViewController = self.visibleViewController else {
            return
        }

        let frame = navigationBar.frame

        // Change the alpha channel of every item on the navbr
        let alpha = (frame.origin.y + deltaLimit()) / frame.size.height

        // Hide all the possible titles
        visibleViewController.navigationItem.titleView?.alpha = alpha
        navigationBar.tintColor = navigationBar.tintColor.colorWithAlphaComponent(alpha)
        if let titleColor = navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor {
            navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] = titleColor.colorWithAlphaComponent(alpha)
        } else {
            navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] = UIColor.blackColor().colorWithAlphaComponent(alpha)
        }

        // Hide all possible button items and navigation items
        for view in navigationBar.subviews {
            if view.classForCoder.description() == "UINavigationButton" ||
                view.classForCoder.description() == "UINavigationItemView" ||
                view.classForCoder.description() == "UISegmentedControl" {
                view.alpha = alpha
            }
        }

        // Hide the left items
        visibleViewController.navigationItem.leftBarButtonItem?.customView?.alpha = alpha
        if let leftItems = visibleViewController.navigationItem.leftBarButtonItems {
            _ = leftItems.map({ $0.customView?.alpha = alpha })
        }

        // Hide the right items
        visibleViewController.navigationItem.rightBarButtonItem?.customView?.alpha = alpha
        if let leftItems = visibleViewController.navigationItem.rightBarButtonItems {
            _ = leftItems.map({ $0.customView?.alpha = alpha })
        }
    }

    func deltaLimit() -> CGFloat {
        return navbarHeight() - statusBar()
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

    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
