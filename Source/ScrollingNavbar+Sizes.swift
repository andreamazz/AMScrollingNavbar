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
    var appHeight = view.bounds.height
    var nextView = view
    while let superView = nextView?.superview {
      appHeight = superView.bounds.height
      nextView = superView.superview
    }
    return abs(appHeight - (UIApplication.shared.delegate?.window??.frame.size.height ?? UIScreen.main.bounds.height))
  }
  
  var tabBarOffset: CGFloat {
    // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
    if let tabBarController = tabBarController, !(topViewController?.hidesBottomBarWhenPushed ?? false) {
      return tabBarController.tabBar.isTranslucent ? 0 : tabBarController.tabBar.frame.height
    }
    return 0
  }
  
  func scrollView() -> UIScrollView? {
    if let wkWebView = self.scrollableView as? WKWebView {
      return wkWebView.scrollView
    } else {
      return scrollableView as? UIScrollView
    }
  }
  
  var contentOffset: CGPoint {
    return scrollView()?.contentOffset ?? CGPoint.zero
  }
  
  var contentSize: CGSize {
    guard let scrollView = scrollView() else {
      return CGSize.zero
    }
    
    let verticalInset = scrollView.contentInset.top + scrollView.contentInset.bottom
    return CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + verticalInset)
  }
  
  var navbarFullHeight: CGFloat {
    return navbarHeight - statusBarHeight + additionalOffset
  }
  
  var followersHeight: CGFloat {
      return self.followers.filter { $0.direction == .scrollUp }.compactMap { $0.view?.frame.height }.reduce(0, +)
  }
}
