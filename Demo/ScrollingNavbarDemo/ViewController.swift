//
//  ViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 24/07/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class ViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Sampler"

    tableView.tableFooterView = UIView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.barTintColor = UIColor(red:0.1, green:0.1, blue:0.1, alpha:1)
  }

}

