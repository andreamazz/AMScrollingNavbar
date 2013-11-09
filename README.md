AMScrollingNavbar
=================

[![Build Status](https://travis-ci.org/andreamazz/AMScrollingNavbar.png)](https://travis-ci.org/andreamazz/AMScrollingNavbar)

Scrollable UINavigationBar that follows the scrolling of a UIScrollView or similar view (e.g. UITableView or UIWebView). 
It works like the navigation bar in Chrome or Facebook's app for iOS7.

Screenshot
--------------------
![AMScrollingNavbar](http://www.eflatgames.com/github/AMScrollingNavbar.gif)

Setup with Cocoapods
--------------------
* Add ```pod 'AMScrollingNavbar'``` to your Podfile
* Run ```pod install```
* Run ```open App.xcworkspace```
* Import ```AMScrollingNavbar.h``` in your controller's header file
* Subclass ```AMScrollingNavbar``` in your controller

Setup without Cocoapods
--------------------
* Clone this repo
* Add the ```AMScrollingNavbar``` folder to your project
* Import ```AMScrollingNavbar.h``` in your controller's header file
* Subclass ```AMScrollingNavbar``` in your controller
* Start using Cocoapods ;)

Enable the scrolling
--------------------
To enable the scrolling effect you simply need to call followScrollView: providing the UIView's instance that will be tracked, like this:
```objc
[self followScrollView:self.scrollView];
```

Make sure to have a ```barTintColor``` for your ```UINavigationBar```, or you won't see the fade-in and fade-out effects.
Also make sure that you are not using a translucent navigation bar. E.g., in your controller:
```objc
[self.navigationController.navigationBar setTranslucent:NO];
```

Changelog 
==================

0.2
--------------------
- Added support for generic UIViews

0.1
--------------------
- Initial Version.

TODO
--------------------
* Needs testing

MIT License
--------------------
The MIT License (MIT)

Copyright (c) 2013 Andrea Mazzini

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
