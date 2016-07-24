import UIKit

/**
    Implements the main functions providing constants values and computed ones
*/
extension ScrollingNavigationController {

    // MARK: - View sizing

    var fullNavbarHeight: CGFloat {
        return navbarHeight + statusBarHeight
    }

    var navbarHeight: CGFloat {
        return navigationBar.frame.size.height
    }

    var statusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height - self.view.convertRect(self.view.bounds, toView: nil).minY
    }

    var tabBarOffset: CGFloat {
        // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
        if let tabBarController = tabBarController {
            return tabBarController.tabBar.translucent ? 0 : tabBarController.tabBar.frame.height
        }
        return 0
    }

    func scrollView() -> UIScrollView? {
        if let webView = self.scrollableView as? UIWebView {
            return webView.scrollView
        } else {
            return scrollableView as? UIScrollView
        }
    }

    var contentOffset: CGPoint {
        return scrollView()?.contentOffset ?? CGPointZero
    }

    var contentSize: CGSize {
        return scrollView()?.contentSize ?? CGSizeZero
    }

    var deltaLimit: CGFloat {
        return navbarHeight - statusBarHeight
    }
}
