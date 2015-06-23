//
//  AMCollectionViewController.m
//  ScrollingNavbarDemo
//
//  Created by David on 28/12/2013.
//  Copyright (c) 2013 Andrea Mazzini. All rights reserved.
//

#import "AMCollectionViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface AMCollectionViewController ()

@end

@implementation AMCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Table View"];
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setTitle:@"Demo"];

    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    // Just call this line to enable the scrolling navbar
    [self setUseSuperview:YES];


}

- (void)viewDidLayoutSubviews {
    [self followScrollView:self.collectionView];
    [self.collectionView scrollsToTop];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat side = [UIScreen mainScreen].bounds.size.width / 2 - 8;
    return (CGSize){ side, side };
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

- (void)dealloc {
    [self stopFollowingScrollView];
}

@end
