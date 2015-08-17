//
//  ViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 24/07/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 100.0)
        }

        title = "Table"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "left", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "left", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            if let navigationController = self.navigationController as? ScrollingNavigationController {
//                navigationController.showNavbar(animated: true)
//            }
//        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = "Text"
        return cell
    }

}

