//
//  AMCollectionViewController.m
//  ScrollingNavbarDemo
//
//  Created by David on 28/12/2013.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMCollectionViewController.h"

@interface AMCollectionViewController ()

@end

@implementation AMCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Table View"];
	
	[self.collectionView setDelegate:self];
	[self.collectionView setDataSource:self];
    
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.collectionView];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"exampleCell" forIndexPath:indexPath];
    return cell;
}

@end
