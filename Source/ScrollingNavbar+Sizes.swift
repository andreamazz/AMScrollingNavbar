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
        if UI_USER_INTERFACE_IDIOM() == .Pad || UIScreen.mainScreen().scale == 3 {
            return portraitNavbar()
        } else {
            return (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ?
                portraitNavbar() :
                landscapeNavbar());
        }
    }

    func portraitNavbar() -> CGFloat {
        return 44 + ((self.topViewController.navigationItem.prompt != nil) ? 30 : 0)
    }

    func landscapeNavbar() -> CGFloat {
        return 32 + ((self.topViewController.navigationItem.prompt != nil) ? 22 : 0)
    }

    func statusBar() -> CGFloat {
        return UIApplication.sharedApplication().statusBarHidden ? 0 : 20
    }
}
