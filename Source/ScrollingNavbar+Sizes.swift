import Foundation

/**
    Implements the main functions providing constants values and computed ones
*/
extension ScrollingNavigationController {

    // MARK: - View sizing

    func fullNavbarHeight() -> CGFloat {
        return navbarHeight() + statusBarHeight()
    }

    func navbarHeight() -> CGFloat {
        return navigationBar.frame.size.height
    }

    func statusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }

    func tabBarOffset() -> CGFloat {
        // Only account for the tab bar if a tab bar controller is present and the bar is not translucent
        if let tabBarController = tabBarController {
            return tabBarController.tabBar.translucent ? 0 : tabBarController.tabBar.frame.height
        }
        return 0
    }
}
