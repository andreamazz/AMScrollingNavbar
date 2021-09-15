//
//  AppDelegate.swift
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 24/07/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func applicationDidFinishLaunching(_ application: UIApplication) {
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.buttonAppearance.normal.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      appearance.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      UINavigationBar.appearance().standardAppearance = appearance
      UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
    } else {
      UINavigationBar.appearance().tintColor = .white
      UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
      UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
  }
}
