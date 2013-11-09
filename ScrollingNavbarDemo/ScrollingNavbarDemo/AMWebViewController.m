//
//  AMWebViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMWebViewController.h"

@interface AMWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AMWebViewController

- (void)viewDidLoad
{
	[self setTitle:@"Web View"];
	
	NSMutableString* html = [@"<html><head></head><body>" mutableCopy];
	
	[html appendString:@"<h1>The content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>Other content</h1><p>Long content here</p><p>Some other content here</p>"];
	[html appendString:@"<h1>My content</h1><p>Long content here</p><p>Some other content here</p>"];		
	[html appendString:@"</body></html>"];
	[self.webView loadHTMLString:html baseURL:nil];
	
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1]];

	[self followScrollView:self.webView];
}

@end
