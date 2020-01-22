//
//  TableViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 18/08/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class TableViewController: ScrollingNavigationViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var toolbar: UIToolbar!
  
  var data: [Int] = Array(0...100)

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "TableView"
    tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 100, right: 0)
    toolbar.barTintColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
    toolbar.tintColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    navigationController?.navigationBar.barTintColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
    navigationItem.searchController = UISearchController(searchResultsController: nil)
  }

  // Enable the navbar scrolling
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(tableView, delay: 0.0, followers: [NavigationBarFollower(view: toolbar, direction: .scrollUp)])
      navigationController.scrollingNavbarDelegate = self
    }
  }
  
  @IBAction func segmentChange() {
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.showNavbar(animated: true, duration: 0.2, scrollToTop: true) {
        let last = self.data.last ?? 0
        self.data = Array(last...last + 100)
        self.tableView.reloadData()
      }
    }
  }

  // MARK: - UITableView data source

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Row \(data[indexPath.row])"
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Header"
  }

}

extension TableViewController: ScrollingNavigationControllerDelegate {
  func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
    view.needsUpdateConstraints()
  }
}
