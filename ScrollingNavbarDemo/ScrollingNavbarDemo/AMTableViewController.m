//
//  AMTableViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMTableViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface AMTableViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* data;
@property (strong, nonatomic) UIView *topView;

@end

@implementation AMTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setTitle:@"Table View"];
	
	self.data = @[@"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.edgesForExtendedLayout = UIRectEdgeNone;

	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.tableView];
	
	[self refreshNavbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    NSLog(@"aas");
	[self showNavBarAnimated:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	// Call this after a small delay, or it won't work
	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.2];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.data count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
	cell.textLabel.text = self.data[indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.topView = [[UIView alloc] initWithFrame:self.view.frame];
	
    UIButton *dismiss = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    [dismiss setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismiss addTarget:self
                action:@selector(doSomething)
      forControlEvents:UIControlEventTouchUpInside];
	[dismiss setTintColor:[UIColor blackColor]];
    [self.topView addSubview:dismiss];
	[self showNavbar];
    [self.navigationController.view addSubview:self.topView];
	
    [self.topView setAlpha:0.3];
}

- (void)doSomething
{
    [self.topView removeFromSuperview];
}

@end
