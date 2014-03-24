AMScrollingNavbar
=================

[![Build Status](https://travis-ci.org/andreamazz/AMScrollingNavbar.png)](https://travis-ci.org/andreamazz/AMScrollingNavbar)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/AMScrollingNavbar/badge.png)](http://beta.cocoapods.org/?q=amscrollingnavbar)
[![Analytics](https://ga-beacon.appspot.com/UA-42282237-8/AMScrollingNavbar/README)](https://github.com/igrigorik/ga-beacon)

Scrollable UINavigationBar that follows the scrolling of a UIScrollView or similar view (e.g. UITableView or UIWebView). 
It works like the navigation bar in Chrome or Facebook's app for iOS7.  

I also wrote about this control in [this article](http://andreamazz.github.io/blog/2014/02/01/amscrollingnavbar-creating-a-cocoapod/)

Screenshot
--------------------
![AMScrollingNavbar](http://www.eflatgames.com/github/AMScrollingNavbar3.gif)

Setup with Cocoapods
--------------------
* Add ```pod 'AMScrollingNavbar'``` to your Podfile
* Run ```pod install```
* Run ```open App.xcworkspace```

Setup as a subclass
--------------------
* Import ```AMScrollingNavbar.h``` in your controller's header file
* Subclass ```AMScrollingNavbar``` in your controller

Setup as a category
--------------------
* Import ```UIViewController+ScrollingNavbar.h``` in your controller
* Implement the two following methods:
```objc
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self showNavbar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshNavbar];
}
```

Enable the scrolling
--------------------
To enable the scrolling effect you simply need to call followScrollView: providing the UIView's instance that will be tracked, like this:
```objc
[self followScrollView:self.scrollView];
```
You can also set a delay (in points) for the gesture that reveals the navigation bar.
```objc
[self followScrollView:self.scrollView withDelay:60];
```

Make sure to have a ```barTintColor``` for your ```UINavigationBar```, or you won't see the fade-in and fade-out effects.
Also make sure that you are not using a translucent navigation bar. E.g., in your controller:
```objc
[self.navigationController.navigationBar setTranslucent:NO];
```

Set the view constraints
--------------------
Make sure to set your scrollview's constraint properly. Please note that the library changes the scrollview's superview frame.

![AMScrollingNavbar](http://www.eflatgames.com/github/AMScrollingNavbarLayout.png)

Update the navbar fadeout
--------------------
Call ```[self refreshNavbar]``` whenever you change your navbar items, or they won't fadeout.

Changelog 
==================

0.7
--------------------
- Added UIViewController's category. The support for the subclassed version will be dropped in future releases.

0.6
--------------------
- Full autolayout support

0.5
--------------------
- Enabled UIWebView support
- Minor fixes

0.4
--------------------
- Added iOS5+ support. Thanks to [xzenon](https://github.com/xzenon)

0.3
--------------------
- Added ```showNavbar```
- Fixes

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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/andreamazz/amscrollingnavbar/trend.png)](https://bitdeli.com/free "Bitdeli Badge")