import UIKit
import WebKit

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
    return UIApplication.shared.statusBarFrame.size.height
  }

  var tabBarOffset: CGFloat {
    // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
    if let tabBarController = tabBarController {
      return tabBarController.tabBar.isTranslucent ? 0 : tabBarController.tabBar.frame.height
    }
    return 0
  }

  func scrollView() -> UIScrollView? {
    if let webView = self.scrollableView as? UIWebView {
      return webView.scrollView
    } else if let wkWebView = self.scrollableView as? WKWebView {
      return wkWebView.scrollView
    } else {
      return scrollableView as? UIScrollView
    }
  }

  var contentOffset: CGPoint {
    return scrollView()?.contentOffset ?? CGPoint.zero
  }

  var contentSize: CGSize {
    return scrollView()?.contentSize ?? CGSize.zero
  }

  var deltaLimit: CGFloat {
    return navbarHeight - statusBarHeight
  }
}
