//
//  AMTableViewController.m
//  ScrollingNavbarDemo
//
//  Created by Andrea Mazzini on 09/11/13.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMTableViewController.h"

@interface AMTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AMTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setTitle:@"Table View"];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
		
	// Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:60.0/255.0 green:1 blue:150.0/255.0 alpha:1]];
	
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
	}
	
	cell.textLabel.text = @[@"Awesome content", @"Great content", @"Amazing content", @"Ludicrous content"][arc4random()%4];
	
	return cell;
}

@end
