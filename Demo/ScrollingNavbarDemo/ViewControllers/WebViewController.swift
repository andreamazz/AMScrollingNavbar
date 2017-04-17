//
//  WebViewController.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 18/08/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class WebViewController: ScrollingNavigationViewController, UIWebViewDelegate {

  @IBOutlet weak var webView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "WebView"

    view.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.32, alpha:1)
    webView.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.32, alpha:1)
    navigationController?.navigationBar.barTintColor = UIColor(red:0.2, green:0.28, blue:0.37, alpha:1)

    // Load some content
    webView.loadHTMLString("<html><body style='background-color:#34495e; color:white; font-family:Heiti SC, sans-serif'><h2>There's an old joke - um... two elderly women are at a Catskill mountain resort, and one of 'em says:<br/><br/> 'Boy, the food at this place is really terrible.'<br/><br/> The other one says: <br/><br/>'Yeah, I know; and such small portions.'<br/><br/> Well, that's essentially how I feel about life - full of loneliness, and misery, and suffering, and unhappiness, and it's all over much too quickly.<br/><br/> The... the other important joke, for me, is one that's usually attributed to Groucho Marx, but I think it appears originally in Freud's 'Wit and Its Relation to the Unconscious,' and it goes like this - I'm paraphrasing <br/><br/> 'I would never want to belong to any club that would have someone like me for a member.' <br/><br/> That's the key joke of my adult life, in terms of my relationships with women.</h2><i>Woody Allen</i></body></html>", baseURL: nil)

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
