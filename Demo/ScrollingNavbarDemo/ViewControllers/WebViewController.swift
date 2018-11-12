//
//  WebViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 18/08/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import WebKit
import AMScrollingNavbar

class WebViewController: ScrollingNavigationViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "WebView"

    view.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.32, alpha:1)
    webView.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.32, alpha:1)
    navigationController?.navigationBar.barTintColor = UIColor(red:0.2, green:0.28, blue:0.37, alpha:1)

    // Load some content
    webView.load(URLRequest(url: URL(string: "https://www.fancypixel.it")!))
    
    // Or try with some local content:
//    let url = Bundle.main.url(forResource: "index", withExtension: "html")!
//    webView.loadFileURL(url, allowingReadAccessTo: url)

    // Enable the scrollToTop
    webView.scrollView.delegate = self
  }

  // Enable the navbar scrolling
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(webView, delay: 50.0)
    }
  }

}
