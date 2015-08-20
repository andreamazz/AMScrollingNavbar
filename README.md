<p align="center">
  <img width="640" height="240" src="assets/logo.png"/>
</p>

[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/AMScrollingNavbar/badge.svg)](http://www.cocoapods.org/?q=amscrollingnavbar)
[![Build Status](https://travis-ci.org/andreamazz/AMScrollingNavbar.svg)](https://travis-ci.org/andreamazz/AMScrollingNavbar)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Join the chat at https://gitter.im/andreamazz/AMScrollingNavbar](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/andreamazz/AMScrollingNavbar?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A custom UINavigationController that enables the scrolling of the navigation bar alongside the
scrolling of an observed content view  

Version `2.x` is written as a subclass of `UINavigationController`, in Swift. 
If you are looking for the category implementation in Objective-C, make sure to checkout version `1.x` and prior, although the `2.x` is recomended.

#Screenshot

![AMScrollingNavbar](https://raw.githubusercontent.com/andreamazz/AMScrollingNavbar/master/assets/screenshot.gif)

#Setup with Cocoapods

```
pod 'AMScrollingNavbar', `~> 2.0.0`

use_frameworks!
```

#Setup with Carthage

```
github "andreamazz/AMScrollingNavbar"
```

##Usage

Make sure to use a subclass of `ScrollingNavigationController` for your `UINavigationController`.

Use `followScrollView(_: delay:)` to start following the scrolling of a scrollable view (e.g.: a `UIScrollView` or `UITableView`).
```swift
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
        navigationController.followScrollView(tableView, delay: 50.0)
    }
}
```

Use `stopFollowingScrollview()` to stop the behaviour. Remember to call this function on disappear:
```swift
override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
        navigationController.stopFollowingScrollView()
    }
}
```

##ScrollingNavigationViewController
To DRY things up you can let your view controller subclass `ScrollingNavigationViewController`, which provides the base setup implementation. You will just need to call `followScrollView(_: delay:)`:
```swift
override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
        navigationController.followScrollView(tableView, delay: 50.0)
    }
}
```

Check out the sample project for more details.

#MIT License
    The MIT License (MIT)

    Copyright (c) 2015 Andrea Mazzini

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


