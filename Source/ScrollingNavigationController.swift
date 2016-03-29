import UIKit

/**
Scrolling Navigation Bar delegate protocol
*/
@objc public protocol ScrollingNavigationControllerDelegate: NSObjectProtocol {
    /**
    Called when the state of the navigation bar changes
    */
    optional func scrollingNavigationController(controller: ScrollingNavigationController, didChangeState state: NavigationBarState)
}

/**
The state of the navigation bar

 - Collapsed: the navigation bar is fully collapsed
 - Expanded: the navigation bar is fully visible
 - Scrolling: the navigation bar is transitioning to either `Collapsed` or `Scrolling`
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
    Determines whether the navbar should scroll when the content inside the scrollview fits
    the view's size. Defaults to `false`
    */
    public var shouldScrollWhenContentFits = false

    /**
    Determines if the navbar should expand once the application becomes active after entering background
    Defaults to `true`
     */
    public var expandOnActive = true

    /**
     Determines if the navbar scrolling is enabled.
     Defaults to `true`
     */
    public var scrollingEnabled = true

    /**
    The delegate for the scrolling navbar controller
    */
    public weak var scrollingNavbarDelegate: ScrollingNavigationControllerDelegate?

    public private(set) var gestureRecognizer: UIPanGestureRecognizer?
    var delayDistance: CGFloat = 0
    var maxDelay: CGFloat = 0
    var scrollableView: UIView?
    var lastContentOffset = CGFloat(0.0)

    /**
    Start scrolling

    Enables the scrolling by observing a view

     - parameter scrollableView: The view with the scrolling content that will be observed
     - parameter delay: The delay expressed in points that determines the scrolling resistance. Defaults to `0`
    */
    public func followScrollView(scrollableView: UIView, delay: Double = 0) {
        self.scrollableView = scrollableView

        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ScrollingNavigationController.handlePan(_:)))
        gestureRecognizer?.maximumNumberOfTouches = 1
        gestureRecognizer?.delegate = self
        scrollableView.addGestureRecognizer(gestureRecognizer!)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScrollingNavigationController.didBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScrollingNavigationController.didRotate(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)

        maxDelay = CGFloat(delay)
        delayDistance = CGFloat(delay)
        scrollingEnabled = true
    }

    /**
    Hide the navigation bar

     - parameter animated: If true the scrolling is animated. Defaults to `true`
    */
    public func hideNavbar(animated animated: Bool = true) {
        guard let _ = self.scrollableView, visibleViewController = self.visibleViewController else { return }

        if state == .Expanded {
            self.state = .Scrolling
            UIView.animateWithDuration(animated ? 0.1 : 0, animations: { () -> Void in
                self.scrollWithDelta(self.fullNavbarHeight)
                visibleViewController.view.setNeedsLayout()
                if self.navigationBar.translucent {
                    let currentOffset = self.contentOffset
                    self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + self.navbarHeight)
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

     - parameter animated: If true the scrolling is animated. Defaults to `true`
    */
    public func showNavbar(animated animated: Bool = true) {
        guard let _ = self.scrollableView, visibleViewController = self.visibleViewController else { return }

        if state == .Collapsed {
            gestureRecognizer?.enabled = false
            self.state = .Scrolling
            UIView.animateWithDuration(animated ? 0.1 : 0, animations: {
                self.lastContentOffset = 0;
                self.delayDistance = -self.fullNavbarHeight
                self.scrollWithDelta(-self.fullNavbarHeight)
                visibleViewController.view.setNeedsLayout()
                if self.navigationBar.translucent {
                    let currentOffset = self.contentOffset
                    self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y - self.navbarHeight)
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
        scrollingEnabled = false

        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        center.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    // MARK: - Gesture recognizer

    func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state != .Failed {
            if let superview = scrollableView?.superview {
                let translation = gesture.translationInView(superview)
                let delta = lastContentOffset - translation.y
                lastContentOffset = translation.y
                
                if shouldScrollWithDelta(delta) {
                    scrollWithDelta(delta)
                }
            }
        }

        if gesture.state == .Ended || gesture.state == .Cancelled || gesture.state == .Failed {
            checkForPartialScroll()
            lastContentOffset = 0
        }
    }

    // MARK: - Rotation handler

    func didRotate(notification: NSNotification) {
        showNavbar()
    }

    /** 
     UIContentContainer protocol method. 
     Will show the navigation bar upon rotation or changes in the trait sizes.
     */
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        showNavbar()
    }

    // MARK: - Notification handler

    func didBecomeActive(notification: NSNotification) {
        if expandOnActive {
            showNavbar(animated: false)
        }
    }

    // MARK: - Scrolling functions

    private func shouldScrollWithDelta(delta: CGFloat) -> Bool {
        // Check for rubberbanding
        if delta < 0 {
            if let scrollableView = scrollableView where contentOffset.y + scrollableView.frame.size.height > contentSize.height && scrollableView.frame.size.height < contentSize.height {
                // Only if the content is big enough
                return false
            }
        } else {
            if contentOffset.y < 0 {
                return false
            }
        }
        return true
    }

    private func scrollWithDelta(delta: CGFloat) {
        var scrollDelta = delta
        let frame = navigationBar.frame

        // View scrolling up, hide the navbar
        if scrollDelta > 0 {
            // Update the delay
            delayDistance -= scrollDelta

            // Skip if the delay is not over yet
            if delayDistance > 0 {
                return
            }

            // No need to scroll if the content fits
            if !shouldScrollWhenContentFits && state != .Collapsed &&
                scrollableView?.frame.size.height >= contentSize.height {
                return
            }

            // Compute the bar position
            if frame.origin.y - scrollDelta < -deltaLimit {
                scrollDelta = frame.origin.y + deltaLimit
            }

            // Detect when the bar is completely collapsed
            if frame.origin.y <= -deltaLimit {
                state = .Collapsed
                delayDistance = maxDelay
            } else {
                state = .Scrolling
            }
        }

        if scrollDelta < 0 {
            // Update the delay
            delayDistance += scrollDelta
            
            // Skip if the delay is not over yet
            if delayDistance > 0 && maxDelay < contentOffset.y {
                return
            }

            // Compute the bar position
            if frame.origin.y - scrollDelta > statusBarHeight {
                scrollDelta = frame.origin.y - statusBarHeight
            }

            // Detect when the bar is completely expanded
            if frame.origin.y >= statusBarHeight {
                state = .Expanded
                delayDistance = maxDelay
            } else {
                state = .Scrolling
            }
        }

        updateSizing(scrollDelta)
        updateNavbarAlpha()
        restoreContentOffset(scrollDelta)
    }

    private func updateSizing(delta: CGFloat) {
        guard let topViewController = self.topViewController else { return }

        var frame = navigationBar.frame

        // Move the navigation bar
        frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - delta)
        navigationBar.frame = frame

        // Resize the view if the navigation bar is not translucent
        if !navigationBar.translucent {
            let navBarY = navigationBar.frame.origin.y + navigationBar.frame.size.height
            frame = topViewController.view.frame
            frame.origin = CGPoint(x: frame.origin.x, y: navBarY)
            frame.size = CGSize(width: frame.size.width, height: view.frame.size.height - (navBarY) - tabBarOffset)
            topViewController.view.frame = frame
        } else {
            adjustContentInsets()
        }
    }

    private func adjustContentInsets() {
        if let view = scrollView() as? UICollectionView {
            view.contentInset.top = navigationBar.frame.origin.y + navigationBar.frame.size.height
            // When this is called by `hideNavbar(_:)` or `showNavbar(_:)`, the sticky header reamins still
            // even if the content inset changed. This triggers a fake scroll, fixing the header's position
            view.setContentOffset(CGPoint(x: contentOffset.x, y: contentOffset.y - 0.1), animated: false)
        }
    }

    private func restoreContentOffset(delta: CGFloat) {
        if navigationBar.translucent || delta == 0 {
            return
        }

        // Hold the scroll steady until the navbar appears/disappears
        if let scrollView = scrollView() {
            scrollView.setContentOffset(CGPoint(x: contentOffset.x, y: contentOffset.y - delta), animated: false)
        }
    }

    private func checkForPartialScroll() {
        let frame = navigationBar.frame
        var duration = NSTimeInterval(0)
        var delta = CGFloat(0.0)

        // Scroll back down
        if navigationBar.frame.origin.y >= (statusBarHeight - (frame.size.height / 2)) {
            delta = frame.origin.y - statusBarHeight
            duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))
            state = .Expanded
        } else {
            // Scroll up
            delta = frame.origin.y + deltaLimit
            duration = NSTimeInterval(abs((delta / (frame.size.height / 2)) * 0.2))
            state = .Collapsed
        }

        delayDistance = maxDelay

        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            self.updateSizing(delta)
            self.updateNavbarAlpha()
            }, completion: nil)
    }

    private func updateNavbarAlpha() {
        guard let navigationItem = visibleViewController?.navigationItem else { return }

        let frame = navigationBar.frame

        // Change the alpha channel of every item on the navbr
        let alpha = (frame.origin.y + deltaLimit) / frame.size.height

        // Hide all the possible titles
        navigationItem.titleView?.alpha = alpha
        navigationBar.tintColor = navigationBar.tintColor.colorWithAlphaComponent(alpha)
        if let titleColor = navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor {
            navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] = titleColor.colorWithAlphaComponent(alpha)
        } else {
            navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] = UIColor.blackColor().colorWithAlphaComponent(alpha)
        }

        // Hide all possible button items and navigation items
        func shouldHideView(view: UIView) -> Bool {
            let className = view.classForCoder.description()
            return className == "UINavigationButton" ||
                className == "UINavigationItemView" ||
                className == "UIImageView" ||
                className == "UISegmentedControl"
        }
        navigationBar.subviews
            .filter(shouldHideView)
            .forEach { $0.alpha = alpha }

        // Hide the left items
        navigationItem.leftBarButtonItem?.customView?.alpha = alpha
        if let leftItems = navigationItem.leftBarButtonItems {
            leftItems.forEach { $0.customView?.alpha = alpha }
        }

        // Hide the right items
        navigationItem.rightBarButtonItem?.customView?.alpha = alpha
        if let leftItems = navigationItem.rightBarButtonItems {
            leftItems.forEach { $0.customView?.alpha = alpha }
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    /** 
    UIGestureRecognizerDelegate function. Enables the scrolling of both the content and the navigation bar
    */
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    /**
     UIGestureRecognizerDelegate function. Only scrolls the navigation bar with the content when `scrollingEnabled` is true
     */
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return scrollingEnabled
    }

}
