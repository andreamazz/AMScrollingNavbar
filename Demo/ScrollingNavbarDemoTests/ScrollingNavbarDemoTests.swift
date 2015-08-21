import UIKit
import Quick
import Nimble
import Nimble_Snapshots

import AMScrollingNavbar

extension UIViewController {
    func preloadView() {
        let _ = self.view
    }
}

class TableController: UITableViewController, ScrollingNavigationControllerDelegate {
    var called = false
    var status = NavigationBarState.Expanded

    func scrollingNavigationController(controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
        called = true
        status = state
    }
}

class DataSource: NSObject, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UITableViewCell {
            cell.textLabel?.text = "Row \(indexPath.row)"
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(white: 0.8, alpha: 1)
            } else {
                cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
            }
            return cell
        }
        return UITableViewCell()
    }
}

class ScrollingNavbarDemoTests: QuickSpec {

    override func spec() {

        var subject: ScrollingNavigationController!
        let dataSource = DataSource()
        var tableController: TableController?

        beforeEach {
            tableController = TableController(style: .Plain)
            tableController?.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
            tableController?.tableView.dataSource = dataSource
            subject = ScrollingNavigationController(rootViewController: tableController!)
            subject.scrollingNavbarDelegate = tableController
            UIApplication.sharedApplication().keyWindow!.rootViewController = subject
            subject.preloadView()
            tableController?.tableView.reloadData()
            subject.followScrollView(tableController!.tableView, delay: 0)
        }

        describe("hideNavbar") {
            it("should hide the navigation bar") {
                subject.hideNavbar(animated: false)
                expect(subject.view).to(haveValidSnapshot())
            }
        }

        describe("showNavbar") {
            it("should show the navigation bar") {
                subject.hideNavbar(animated: false)
                subject.showNavbar(animated: false)
                expect(subject.view).toEventually(haveValidSnapshot(), timeout: 2, pollInterval: 1)
            }
        }

        describe("ScrollingNavigationControllerDelegate") {
            it("should call the delegate with the new state of scroll") {
                subject.hideNavbar(animated: false)
                expect(tableController?.called).to(beTrue())
                expect(tableController?.status).to(equal(NavigationBarState.Scrolling))
                expect(tableController?.status).toEventually(equal(NavigationBarState.Collapsed), timeout: 2, pollInterval: 1)
            }
        }
    }

}
