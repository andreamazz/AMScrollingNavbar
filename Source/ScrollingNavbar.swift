
import UIKit

public class ScrollingNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    public private(set) var collapsed = false
    public private(set) var expanded = true
    public var shouldScrollWhenContentFits = false
    var delayDistance: CGFloat = 0
    var maxDelay: CGFloat = 0
    var gestureRecognizer: UIPanGestureRecognizer?
    var scrollableView: UIView?
    var lastContentOffset = CGFloat(0.0)

    public func followScrollView(scrollableView: UIView) {
        self.scrollableView = scrollableView

        gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        gestureRecognizer?.maximumNumberOfTouches = 1
        gestureRecognizer?.delegate = self
        scrollableView.addGestureRecognizer(gestureRecognizer!)
    }

    public func hideNavbar(animated: Bool = true) {
        if let scrollableView = self.scrollableView {

        }
    }

    public func showNavbar(animated: Bool = true) {
        if let scrollableView = self.scrollableView {

        }
    }

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
            // checkForPartialScroll()
            // checkForHeaderPartialScroll()
            lastContentOffset = 0
        }
    }

    func shouldScrollWithDelta(delta: CGFloat) -> Bool {
        // TODO: implement
        return true
    }

    func scrollWithDelta(var delta: CGFloat) {
        var frame = navigationBar.frame

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
            if frame.origin.y == deltaLimit() {
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

        // Move the navigation bar
        frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - delta)
        navigationBar.frame = frame

        // Resize the view if the navigation bar is not translucent
        if !navigationBar.translucent {
            frame = visibleViewController.view.frame
            frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - delta)
            frame.size = CGSize(width: frame.size.width, height: frame.size.height + delta)
            visibleViewController.view.frame = frame
        }

        updateNavbar(alpha: delta)
    }

    func updateNavbar(#alpha: CGFloat) {
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
