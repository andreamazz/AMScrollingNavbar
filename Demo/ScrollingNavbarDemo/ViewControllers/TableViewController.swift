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

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TableView"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
    }

    // Enable the navbar scrolling
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
    }

    // MARK: - UITableView data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = "Row \((indexPath as NSIndexPath).row + 1)"
        return cell
    }

}
