import UIKit
//import Quick
//import Nimble
//import Nimble_Snapshots

import AMScrollingNavbar

// NOTE: tests disabled until Quick and Nimble Swift 3 branch is complete

//func isRecording() -> Bool {
//    return false
//}
//
//extension UIViewController {
//    func preloadView() {
//        let _ = self.view
//    }
//}
//
//class TableController: UITableViewController, ScrollingNavigationControllerDelegate {
//    var called = false
//    var status = NavigationBarState.expanded
//
//    func scrollingNavigationController(_ controller: ScrollingNavigationController, didChangeState state: NavigationBarState) {
//        called = true
//        status = state
//    }
//}
//
//class DataSource: NSObject, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "Row \((indexPath as NSIndexPath).row)"
//        if (indexPath as NSIndexPath).row % 2 == 0 {
//            cell.backgroundColor = UIColor(white: 0.8, alpha: 1)
//        } else {
//            cell.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        }
//        return cell
//    }
//}
//
//class ScrollingNavbarDemoTests: QuickSpec {
//
//    override func spec() {
//
//        var subject: ScrollingNavigationController!
//        let dataSource = DataSource()
//        var tableController: TableController?
//
//        beforeEach {
//            tableController = TableController(style: .Plain)
//            tableController?.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
//            tableController?.tableView.dataSource = dataSource
//            subject = ScrollingNavigationController(rootViewController: tableController!)
//            subject.scrollingNavbarDelegate = tableController
//            UIApplication.sharedApplication().keyWindow!.rootViewController = subject
//            subject.preloadView()
//            tableController?.tableView.reloadData()
//            subject.followScrollView(tableController!.tableView, delay: 0)
//        }
//
//        describe("hideNavbar") {
//            it("should hide the navigation bar") {
//                subject.hideNavbar(animated: false)
//                if isRecording() {
//                    expect(subject.view).to(recordSnapshot())
//                } else {
//                    expect(subject.view).to(haveValidSnapshot())
//                }
//            }
//        }
//
//        describe("showNavbar") {
//            it("should show the navigation bar") {
//                subject.hideNavbar(animated: false)
//                subject.showNavbar(animated: false)
//                if isRecording() {
//                    expect(subject.view).toEventually(recordSnapshot(), timeout: 2, pollInterval: 1)
//                } else {
//                    expect(subject.view).toEventually(haveValidSnapshot(), timeout: 2, pollInterval: 1)
//                }
//            }
//        }
//
//        describe("ScrollingNavigationControllerDelegate") {
//            it("should call the delegate with the new state of scroll") {
//                subject.hideNavbar(animated: false)
//                expect(tableController?.called).to(beTrue())
//                expect(tableController?.status).to(equal(NavigationBarState.Scrolling))
//                expect(tableController?.status).toEventually(equal(NavigationBarState.Collapsed), timeout: 2, pollInterval: 1)
//            }
//        }
//    }
//
//}
