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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = .white()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white()]
        return true
    }

}
