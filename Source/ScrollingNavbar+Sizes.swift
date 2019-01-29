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
    var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    if #available(iOS 11.0, *) {
      // Account for the notch when the status bar is hidden
      statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
    }
    return max(statusBarHeight - extendedStatusBarDifference, 0)
  }
  
  // Extended status call changes the bounds of the presented view
  var extendedStatusBarDifference: CGFloat {
    return abs(view.bounds.height - (UIApplication.shared.delegate?.window??.frame.size.height ?? UIScreen.main.bounds.height))
  }
  
  var tabBarOffset: CGFloat {
    // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
    if let tabBarController = tabBarController, !(topViewController?.hidesBottomBarWhenPushed ?? false) {
      return tabBarController.tabBar.isTranslucent ? 0 : tabBarController.tabBar.frame.height
    }
    return 0
  }
  
  var followedScrollView: UIScrollView {
    if let webView = self.scrollableView as? UIWebView {
      return webView.scrollView
    } else if let wkWebView = self.scrollableView as? WKWebView {
      return wkWebView.scrollView
    } else if let scrollView = scrollableView as? UIScrollView {
      return scrollView
    }
    fatalError("Make sure to follow a compatible scroll view")
  }
  
  var contentOffset: CGPoint {
    return followedScrollView.contentOffset
  }
  
  var contentSize: CGSize {
    let verticalInset = followedScrollView.contentInset.top + followedScrollView.contentInset.bottom
    return CGSize(width: followedScrollView.contentSize.width, height: followedScrollView.contentSize.height + verticalInset)
  }
  
  var navbarFullHeight: CGFloat {
    return navbarHeight - statusBarHeight + additionalOffset
  }
}
