import UIKit

/**
    A custom `UIViewController` that implements the base configuration.
*/
public class ScrollingNavigationViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - ScrollView config

    /**
        On appear calls `showNavbar()` by default
    */
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(true)
        }
    }

    /**
        On disappear calls `stopFollowingScrollView()` to stop observing the current scroll view, and perform the tear down
    */
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }

    /**
        Calls `showNavbar()` when a `scrollToTop` is requested
    */
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(true)
        }
        return true
    }

}