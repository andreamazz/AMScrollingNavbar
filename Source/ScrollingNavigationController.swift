import UIKit

/**
 Scrolling Navigation Bar delegate protocol
 */
@objc public protocol ScrollingNavigationControllerDelegate: NSObjectProtocol {
  /// Called when the state of the navigation bar changes
  ///
  /// - Parameters:
  ///   - controller: the ScrollingNavigationController
  ///   - state: the new state
  @objc optional func scrollingNavigationController(_ controller: ScrollingNavigationController, didChangeState state: NavigationBarState)
  
  /// Called when the state of the navigation bar is about to change
  ///
  /// - Parameters:
  ///   - controller: the ScrollingNavigationController
  ///   - state: the new state
  @objc optional func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState)
}

/**
 The state of the navigation bar

 - collapsed: the navigation bar is fully collapsed
 - expanded: the navigation bar is fully visible
 - scrolling: the navigation bar is transitioning to either `Collapsed` or `Scrolling`
 */
@objc public enum NavigationBarState: Int {
  case collapsed, expanded, scrolling
}

/**
 The direction of scrolling that the navigation bar should be collapsed.
 The raw value determines the sign of content offset depending of collapse direction.
 
 - scrollUp: scrolling up direction
 - scrollDown: scrolling down direction
 */
@objc public enum NavigationBarCollapseDirection: Int {
  case scrollUp = -1
  case scrollDown = 1
}

/**
 A custom `UINavigationController` that enables the scrolling of the navigation bar alongside the
 scrolling of an observed content view
 */
@objcMembers
open class ScrollingNavigationController: UINavigationController, UIGestureRecognizerDelegate {

  /**
   Returns the `NavigationBarState` of the navigation bar
   */
  open fileprivate(set) var state: NavigationBarState = .expanded {
    willSet {
      if state != newValue {
        scrollingNavbarDelegate?.scrollingNavigationController?(self, willChangeState: newValue)
      }
    }
    didSet {
      navigationBar.isUserInteractionEnabled = (state == .expanded)
      if state != oldValue {
        scrollingNavbarDelegate?.scrollingNavigationController?(self, didChangeState: state)
      }
    }
  }

  /**
   Determines whether the navbar should scroll when the content inside the scrollview fits
   the view's size. Defaults to `false`
   */
  open var shouldScrollWhenContentFits = false

  /**
   Determines if the navbar should expand once the application becomes active after entering background
   Defaults to `true`
   */
  open var expandOnActive = true

  /**
   Determines if the navbar scrolling is enabled.
   Defaults to `true`
   */
  open var scrollingEnabled = true

  /**
   The delegate for the scrolling navbar controller
   */
  open weak var scrollingNavbarDelegate: ScrollingNavigationControllerDelegate?

  /**
   An array of `UIView`s that will follow the navbar
   */
  open var followers: [UIView] = []
  
  /// Stores some metadata of a UITabBar if one is passed in the followers array
  internal struct TabBarMock {
    var isTranslucent: Bool = false
    var origin: CGPoint = .zero
    
    init(origin: CGPoint, translucent: Bool) {
      self.origin = origin
      self.isTranslucent = translucent
    }
  }

  open fileprivate(set) var gestureRecognizer: UIPanGestureRecognizer?
  fileprivate var sourceTabBar: TabBarMock?
  fileprivate var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
  var delayDistance: CGFloat = 0
  var maxDelay: CGFloat = 0
  var scrollableView: UIView?
  var lastContentOffset = CGFloat(0.0)
  var scrollSpeedFactor: CGFloat = 1
  var collapseDirectionFactor: CGFloat = 1 // Used to determine the sign of content offset depending of collapse direction
  var previousState: NavigationBarState = .expanded // Used to mark the state before the app goes in background

  /**
   Start scrolling

   Enables the scrolling by observing a view

   - parameter scrollableView: The view with the scrolling content that will be observed
   - parameter delay: The delay expressed in points that determines the scrolling resistance. Defaults to `0`
   - parameter scrollSpeedFactor : This factor determines the speed of the scrolling content toward the navigation bar animation
   - parameter collapseDirection : The direction of scrolling that the navigation bar should be collapsed
   - parameter followers: An array of `UIView`s that will follow the navbar
   */
  open func followScrollView(_ scrollableView: UIView, delay: Double = 0, scrollSpeedFactor: Double = 1, collapseDirection: NavigationBarCollapseDirection = .scrollDown, followers: [UIView] = []) {
    self.scrollableView = scrollableView

    gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ScrollingNavigationController.handlePan(_:)))
    gestureRecognizer?.maximumNumberOfTouches = 1
    gestureRecognizer?.delegate = self
    scrollableView.addGestureRecognizer(gestureRecognizer!)

    previousOrientation = UIDevice.current.orientation
    NotificationCenter.default.addObserver(self, selector: #selector(ScrollingNavigationController.willResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ScrollingNavigationController.didBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ScrollingNavigationController.didRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    maxDelay = CGFloat(delay)
    delayDistance = CGFloat(delay)
    scrollingEnabled = true

    // Save TabBar state (the state is changed during the transition and restored on compeltion)
    if let tab = followers.first(where: { $0 is UITabBar }) as? UITabBar {
      self.sourceTabBar = TabBarMock(origin: CGPoint(x: tab.frame.origin.x, y: CGFloat(round(tab.frame.origin.y))), translucent: tab.isTranslucent)
    }
    self.followers = followers
    self.scrollSpeedFactor = CGFloat(scrollSpeedFactor)
    self.collapseDirectionFactor = CGFloat(collapseDirection.rawValue)
  }

  /**
   Hide the navigation bar

   - parameter animated: If true the scrolling is animated. Defaults to `true`
   - parameter duration: Optional animation duration. Defaults to 0.1
   */
  open func hideNavbar(animated: Bool = true, duration: TimeInterval = 0.1) {
    guard let _ = self.scrollableView, let visibleViewController = self.visibleViewController else { return }

    if state == .expanded {
      self.state = .scrolling
      UIView.animate(withDuration: animated ? duration : 0, animations: { () -> Void in
        self.scrollWithDelta(self.fullNavbarHeight)
        visibleViewController.view.setNeedsLayout()
        if self.navigationBar.isTranslucent {
          let currentOffset = self.contentOffset
          self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + self.navbarHeight)
        }
      }) { _ in
        self.state = .collapsed
      }
    } else {
      updateNavbarAlpha()
    }
  }

  /**
   Show the navigation bar

   - parameter animated: If true the scrolling is animated. Defaults to `true`
   - parameter duration: Optional animation duration. Defaults to 0.1
   */
  open func showNavbar(animated: Bool = true, duration: TimeInterval = 0.1) {
    guard let _ = self.scrollableView, let visibleViewController = self.visibleViewController else { return }

    guard state == .collapsed else {
      updateNavbarAlpha()
      return
    }

    gestureRecognizer?.isEnabled = false
    let animations = {
      self.lastContentOffset = 0;
      self.scrollWithDelta(-self.fullNavbarHeight, ignoreDelay: true)
      visibleViewController.view.setNeedsLayout()
      if self.navigationBar.isTranslucent {
        let currentOffset = self.contentOffset
        self.scrollView()?.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y - self.navbarHeight)
      }
    }
    if animated {
      state = .scrolling
      UIView.animate(withDuration: duration, animations: animations) { _ in
        self.state = .expanded
        self.gestureRecognizer?.isEnabled = true
      }
    } else {
      animations()
      state = .expanded
      gestureRecognizer?.isEnabled = true
    }
  }

  /**
   Stop observing the view and reset the navigation bar

   - parameter showingNavbar: If true the navbar is show, otherwise it remains in its current state. Defaults to `true`
   */
  open func stopFollowingScrollView(showingNavbar: Bool = true) {
    if showingNavbar {
      showNavbar(animated: true)
    }
    if let gesture = gestureRecognizer {
      scrollableView?.removeGestureRecognizer(gesture)
    }
    scrollableView = .none
    gestureRecognizer = .none
    scrollingNavbarDelegate = .none
    scrollingEnabled = false

    let center = NotificationCenter.default
    center.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    center.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }

  // MARK: - Gesture recognizer

  func handlePan(_ gesture: UIPanGestureRecognizer) {
    if let superview = scrollableView?.superview {
      let translation = gesture.translation(in: superview)
      let delta = (lastContentOffset - translation.y) / scrollSpeedFactor
      
      if !checkSearchController(delta) {
        lastContentOffset = translation.y
        return
      }
      
      if gesture.state != .failed {
        lastContentOffset = translation.y
        if shouldScrollWithDelta(delta) {
          scrollWithDelta(delta)
        }
      }
    }
    
    if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
      checkForPartialScroll()
      lastContentOffset = 0
    }
  }

  // MARK: - Rotation handler

  func didRotate(_ notification: Notification) {
    let newOrientation = UIDevice.current.orientation
    if (previousOrientation.isPortrait && newOrientation.isLandscape) || (previousOrientation.isLandscape && newOrientation.isPortrait) {
      showNavbar()
    }
    previousOrientation = newOrientation
  }

  /**
   UIContentContainer protocol method.
   Will show the navigation bar upon rotation or changes in the trait sizes.
   */
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    showNavbar()
  }

  // MARK: - Notification handler

  func didBecomeActive(_ notification: Notification) {
    if expandOnActive {
      showNavbar(animated: false)
    } else {
      if previousState == .collapsed {
        hideNavbar(animated: false)
      }
    }
  }

  func willResignActive(_ notification: Notification) {
    previousState = state
  }

  /// Handles when the status bar changes
  func willChangeStatusBar() {
    showNavbar(animated: true)
  }

  // MARK: - Scrolling functions

  private func shouldScrollWithDelta(_ delta: CGFloat) -> Bool {
    let scrollDelta = delta
    // Check for rubberbanding
    if scrollDelta < 0 {
      if let scrollableView = scrollableView , contentOffset.y + scrollableView.frame.size.height > contentSize.height && scrollableView.frame.size.height < contentSize.height {
        // Only if the content is big enough
        return false
      }
    }
    return true
  }

  private func scrollWithDelta(_ delta: CGFloat, ignoreDelay: Bool = false) {
    var scrollDelta = delta
    let frame = navigationBar.frame

    // View scrolling up, hide the navbar
    if scrollDelta > 0 {
      // Update the delay
      if !ignoreDelay {
        delayDistance -= scrollDelta

        // Skip if the delay is not over yet
        if delayDistance > 0 {
          return
        }
      }

      // No need to scroll if the content fits
      if !shouldScrollWhenContentFits && state != .collapsed &&
        (scrollableView?.frame.size.height)! >= contentSize.height {
        return
      }

      // Compute the bar position
      if frame.origin.y - scrollDelta < -deltaLimit {
        scrollDelta = frame.origin.y + deltaLimit
      }

      // Detect when the bar is completely collapsed
      if frame.origin.y <= -deltaLimit {
        state = .collapsed
        delayDistance = maxDelay
      } else {
        state = .scrolling
      }
    }

    if scrollDelta < 0 {
      // Update the delay
      if !ignoreDelay {
        delayDistance += scrollDelta

        // Skip if the delay is not over yet
        if delayDistance > 0 && maxDelay < contentOffset.y {
          return
        }
      }

      // Compute the bar position
      if frame.origin.y - scrollDelta > statusBarHeight {
        scrollDelta = frame.origin.y - statusBarHeight
      }

      // Detect when the bar is completely expanded
      if frame.origin.y >= statusBarHeight {
        state = .expanded
        delayDistance = maxDelay
      } else {
        state = .scrolling
      }
    }

    updateSizing(scrollDelta)
    updateNavbarAlpha()
    restoreContentOffset(scrollDelta)
    updateFollowers(scrollDelta)
    updateContentInset(scrollDelta)
  }

  /// Adjust the top inset (useful when a table view has floating headers, see issue #219
  private func updateContentInset(_ delta: CGFloat) {
    if let contentInset = scrollView()?.contentInset, let scrollInset = scrollView()?.scrollIndicatorInsets {
      scrollView()?.contentInset = UIEdgeInsets(top: contentInset.top - delta, left: contentInset.left, bottom: contentInset.bottom, right: contentInset.right)
      scrollView()?.scrollIndicatorInsets = UIEdgeInsets(top: scrollInset.top - delta, left: scrollInset.left, bottom: scrollInset.bottom, right: scrollInset.right)
    }
  }

  private func updateFollowers(_ delta: CGFloat) {
    followers.forEach {
      guard let tabBar = $0 as? UITabBar else {
        $0.transform = $0.transform.translatedBy(x: 0, y: -delta)
        return
      }
      tabBar.isTranslucent = true
      tabBar.frame.origin.y += delta * (tabBar.frame.height / navigationBar.frame.height)

      // Set the bar to its original state if it's in its original position
      if let originalTabBar = sourceTabBar, originalTabBar.origin.y == round(tabBar.frame.origin.y){
        tabBar.isTranslucent = originalTabBar.isTranslucent
      }
    }
  }

  private func updateSizing(_ delta: CGFloat) {
    guard let topViewController = self.topViewController else { return }

    var frame = navigationBar.frame

    // Move the navigation bar
    frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - delta)
    navigationBar.frame = frame

    // Resize the view if the navigation bar is not translucent
    if !navigationBar.isTranslucent {
      let navBarY = navigationBar.frame.origin.y + navigationBar.frame.size.height
      frame = topViewController.view.frame
      frame.origin = CGPoint(x: frame.origin.x, y: navBarY)
      frame.size = CGSize(width: frame.size.width, height: view.frame.size.height - (navBarY) - tabBarOffset)
      topViewController.view.frame = frame
    }
  }

  private func restoreContentOffset(_ delta: CGFloat) {
    if navigationBar.isTranslucent || delta == 0 {
      return
    }

    // Hold the scroll steady until the navbar appears/disappears
    if let scrollView = scrollView() {
      scrollView.setContentOffset(CGPoint(x: contentOffset.x, y: contentOffset.y - delta), animated: false)
    }
  }

  private func checkForPartialScroll() {
    let frame = navigationBar.frame
    var duration = TimeInterval(0)
    var delta = CGFloat(0.0)

    // Scroll back down
    let threshold = statusBarHeight - (frame.size.height / 2)
    if navigationBar.frame.origin.y >= threshold {
      delta = frame.origin.y - statusBarHeight
      let distance = delta / (frame.size.height / 2)
      duration = TimeInterval(abs(distance * 0.2))
      state = .expanded
    } else {
      // Scroll up
      delta = frame.origin.y + deltaLimit
      let distance = delta / (frame.size.height / 2)
      duration = TimeInterval(abs(distance * 0.2))
      state = .collapsed
    }

    delayDistance = maxDelay
    
    UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
      self.updateSizing(delta)
      self.updateFollowers(delta)
      self.updateNavbarAlpha()
      self.updateContentInset(delta)
    }, completion: nil)
  }

  private func updateNavbarAlpha() {
    guard let navigationItem = topViewController?.navigationItem else { return }

    let frame = navigationBar.frame

    // Change the alpha channel of every item on the navbr
    let alpha = (frame.origin.y + deltaLimit) / frame.size.height

    // Hide all the possible titles
    navigationItem.titleView?.alpha = alpha
    navigationBar.tintColor = navigationBar.tintColor.withAlphaComponent(alpha)
    navigationItem.leftBarButtonItem?.tintColor = navigationItem.leftBarButtonItem?.tintColor?.withAlphaComponent(alpha)
    navigationItem.rightBarButtonItem?.tintColor = navigationItem.rightBarButtonItem?.tintColor?.withAlphaComponent(alpha)
    navigationItem.leftBarButtonItems?.forEach { $0.tintColor = $0.tintColor?.withAlphaComponent(alpha) }
    navigationItem.rightBarButtonItems?.forEach { $0.tintColor = $0.tintColor?.withAlphaComponent(alpha) }
    if let titleColor = navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor {
      navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] = titleColor.withAlphaComponent(alpha)
    } else {
      navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] = UIColor.black.withAlphaComponent(alpha)
    }

    // Hide all possible button items and navigation items
    func shouldHideView(_ view: UIView) -> Bool {
      let className = view.classForCoder.description().replacingOccurrences(of: "_", with: "")
      var viewNames = ["UINavigationButton", "UINavigationItemView", "UIImageView", "UISegmentedControl"]
      if #available(iOS 11.0, *) {
        viewNames.append(navigationBar.prefersLargeTitles ? "UINavigationBarLargeTitleView" : "UINavigationBarContentView")
      } else {
        viewNames.append("UINavigationBarContentView")
      }
      return viewNames.contains(className)
    }

    func setAlphaOfSubviews(view: UIView, alpha: CGFloat) {
      view.alpha = alpha
      view.subviews.forEach { setAlphaOfSubviews(view: $0, alpha: alpha) }
    }

    navigationBar.subviews
      .filter(shouldHideView)
      .forEach { setAlphaOfSubviews(view: $0, alpha: alpha) }

    // Hide the left items
    navigationItem.leftBarButtonItem?.customView?.alpha = alpha
    navigationItem.leftBarButtonItems?.forEach { $0.customView?.alpha = alpha }

    // Hide the right items
    navigationItem.rightBarButtonItem?.customView?.alpha = alpha
    navigationItem.rightBarButtonItems?.forEach { $0.customView?.alpha = alpha }
  }
  
  private func checkSearchController(_ delta: CGFloat) -> Bool {
    if #available(iOS 11.0, *) {
      if let searchController = topViewController?.navigationItem.searchController, delta > 0 {
        if searchController.searchBar.frame.height != 0 {
          return false
        }
      }
    }
    return true
  }

  // MARK: - UIGestureRecognizerDelegate

  /**
   UIGestureRecognizerDelegate function. Begin scrolling only if the direction is vertical (prevents conflicts with horizontal scroll views)
   */
  open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
    let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
    return fabs(velocity.y) > fabs(velocity.x)
  }

  /**
   UIGestureRecognizerDelegate function. Enables the scrolling of both the content and the navigation bar
   */
  open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

  /**
   UIGestureRecognizerDelegate function. Only scrolls the navigation bar with the content when `scrollingEnabled` is true
   */
  open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return scrollingEnabled
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}
