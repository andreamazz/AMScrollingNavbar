//
//  AMWebViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMWebViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface AMWebViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AMWebViewController

- (void)viewDidLoad
{
	[self setTitle:@"Web View"];
	[self.webView setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
	[self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]];
	NSMutableString* html = [@"<html><head></head><body style='background-color:#eee; color:#444; font-family: Futura;'>" mutableCopy];
	
	[html appendString:@"<h1>The content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>Other content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>My content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>My content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>My content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"</body></html>"];

	[self.webView loadHTMLString:html baseURL:nil];
	
//    [self followScrollView:self.webView usingTopConstraint:self.topConstraint];
    [self followScrollView:self.webView];
	
	// We need to set self as delegate of the inner scrollview of the webview to override scrollViewShouldScrollToTop
	self.webView.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}

@end
