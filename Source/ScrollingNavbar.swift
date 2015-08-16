
import UIKit

public class ScrollingNavigationController: UINavigationController, UIGestureRecognizerDelegate {

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
            if frame.origin.y - delta < -deltaLimit() {
                delta = frame.origin.y + deltaLimit()
            }
        }

        if delta < 0 {
            if frame.origin.y - delta > statusBar() {
                delta = frame.origin.y - statusBar()
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
        }
        visibleViewController.view.frame = frame
    }

    func deltaLimit() -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .Pad || UIScreen.mainScreen().scale == 3 {
            return portraitNavbar() - statusBar()
        } else {
            return (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ?
                portraitNavbar() - statusBar() :
                landscapeNavbar() - statusBar());
        }
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
