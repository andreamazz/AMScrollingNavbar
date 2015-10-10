import Foundation

/**
    Implements the main functions providing constants values and computed ones
*/
extension ScrollingNavigationController {

    // MARK: - View sizing

    func fullNavbarHeight() -> CGFloat {
        return navbarHeight() + statusBar()
    }

    func navbarHeight() -> CGFloat {
        return navigationBar.frame.size.height
    }

    func statusBar() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }
}
