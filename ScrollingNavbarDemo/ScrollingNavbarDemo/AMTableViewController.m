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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation AMTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    
	[self setTitle:@"Table View"];
	
    self.data = @[@"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content", @"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content"];
	
    if (self.tabBarController) {
        [self.tabBarController.tabBar setHidden:YES];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -44, 0);
    }
    
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav"]];

    // Just call this line to enable the scrolling navbar
	[self followScrollView:self.tableView usingTopConstraint:self.topConstraint withDelay:65];
    [self setShouldScrollWhenContentFits:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AMTableViewController"] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self showNavBarAnimated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self showNavBarAnimated:NO];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	// Call this after a small delay, or it won't work
	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.2];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
//	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.1];  // Use a delay if needed (pre iOS8)
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

@end
