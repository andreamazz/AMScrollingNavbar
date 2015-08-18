//
//  ScrollingNavigationViewController.swift
//  AMScrollingNavbar
//
//  Created by Andrea Mazzini on 18/08/15.
//
//

import UIKit

public class ScrollingNavigationViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - ScrollView config

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }

    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }

    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }

}