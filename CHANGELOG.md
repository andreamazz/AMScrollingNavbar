# Change Log
All notable changes to this project will be documented in this file.
`AMScrollingNavbar` adheres to [Semantic Versioning](http://semver.org/).

- `3.3.x` Releases - [3.3.0](#330) | [3.3.1](#331)  
- `3.2.x` Releases - [3.2.0](#320)
- `3.1.x` Releases - [3.1.0](#310)
- `3.0.x` Releases - [3.0.0](#300)
- `2.1.x` Releases - [2.1.0](#210) | [2.1.1](#211) | [2.1.2](#212)  
- `2.0.x` Releases - [2.0.0](#200) | [2.0.1](#201) | [2.0.2](#202) | [2.0.3](#203) | [2.0.4](#204) | [2.0.5](#205) | [2.0.6](#206) | [2.0.7](#207) | [2.0.8](#208) | [2.0.9](#209) | [2.0.10](#2010) | [2.0.11](#2011) | [2.0.12](#2012) | [2.0.13](#2013) | [2.0.14](#2014)  
- `2.0.x` Beta Releases - [2.0.0-beta1](#200-beta1) | [2.0.0-beta2](#200-beta2) | [2.0.0-beta3](#200-beta3) | [2.0.0-beta4](#200-beta4) | [2.0.0-beta5](#200-beta5) | [2.0.0-beta6](#200-beta6) | [2.0.0-beta7](#200-beta7)
- `1.5.x` Releases - [1.5](#15) | [1.5.1](#151)

---

## [3.3.1](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/3.3.1)

- Added support for `WKWebView`. See #239  

## [3.3.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/3.3.0)

- Fixed `expandOnActive`
- Added `showingNavbar` optional parameter to `stopFollowingScrollView`
- Fixed #237

## [3.2.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/3.2.0)

Added optional `followers` parameter to `followScrollView`. See [Readme section](https://github.com/andreamazz/AMScrollingNavbar#followers)  

## [3.1.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/3.1.0)

Added optional `scrollSpeedFactor` parameter to `followScrollView`. See #224

## [3.0.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/3.0.0)

Updated to Swift 3 syntax

## [2.1.2](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.1.2)

- Fix status bar handling when in-call

## [2.1.1](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.1.1)

- Merged #197

## [2.1.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.1.0)

Updated to Swift 2.2 syntax  

## [2.0.14](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.14)

###Fixed

- Expose the gesture recognizer #194  

## [2.0.13](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.13)

###Fixed

- Fix Carthage build by setting the demo pod target to 8.0  

## [2.0.12](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.12)

###Fixed

- Fix Carthage build for 8.0 targets  

## [2.0.11](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.11)

###Fixed

- Issue #183  

## [2.0.10](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.10)

###Fixed

- Issue #172  

## [2.0.9](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.9)

Merged #166  

## [2.0.8](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.8)

Updated documentation.  
Minor refactoring.  

## [2.0.7](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.7)

###Fixed

- Issue #135
- Issue #165

## [2.0.6](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.6)

###Fixed

- Refactoring. Removed screen rotation observer when appropriate. [@ikesyo](https://github.com/ikesyo)  

## [2.0.5](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.5)

###Fixed

- Issue #156

Code refactoring. Thanks to [Syo Ikeda](https://github.com/ikesyo)  

## [2.0.4](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.4)

###Fixed

- Fix navbar fadeout. Thanks to [Syo Ikeda](https://github.com/ikesyo)  

## [2.0.3](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.3)

###Fixed

- Issue #159  

## [2.0.2](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.2)

###Fixed

- Fix bug causing titleView alpha property to not update when navbar alpha changes. Thanks to [Erik Ackermann](https://github.com/erikackermann)  

## [2.0.1](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.1)

###Fixed

- Issue #153

## [2.0.0](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0)

###Added

- Support for Swift 2.0 syntax  

## [2.0.0-beta7](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta7)

###Fixed
- Fix the fading of all possible navigation items and buttons. Thanks to [Yunus Eren Guzel](https://github.com/yunuserenguzel)  

## [2.0.0-beta6](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta6)

###Fixed
- Delegate function gets called after `hideNavbar` and `showNavbar` finish.  
- Fixes title attributes being overridden. Thanks to [Jianghua Kuai](https://github.com/joshuakuai)  

## [2.0.0-beta5](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta5)

###Added
- ScrollingNavigationControllerDelegate protocol  

###Fixed
- Issue with the scroll offset

## [2.0.0-beta4](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta4)

###Fixed
- Minor refactoring
- Changed filename for `ScrollingNavigationController`
- Fixed Carthage build. Thanks to [Nicholas T.](https://github.com/NicholasTD07)  

## [2.0.0-beta3](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta3)

###Fixed
- Carthage support restored  

###Added
- Utility class `ScrollingNavigationViewController´  

## [2.0.0-beta2](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta2)

###Fixed
- Issue with interactive gesture

## [2.0.0-beta1](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/2.0.0-beta1)

The library was rewritten in Swift, as a subclass of `UINavigationController`. This version contains breaking changes.
Moving from a category to a subclass cleaned up the code quite a bit, making it more maintainable and hopefully less fragile.
It also fully supports translucent navbars now.

## [1.5.1](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/1.5.1)

#### Added  
- Support to Carthage

## [1.5](https://github.com/andreamazz/AMScrollingNavbar/releases/tag/1.5)
