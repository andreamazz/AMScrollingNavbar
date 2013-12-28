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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Table View"];
	
	[self.collectionView setDelegate:self];
	[self.collectionView setDataSource:self];
    
    // Set the barTintColor (if available). This will determine the overlay that fades in and out upon scrolling.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:60.0/255.0 green:1 blue:150.0/255.0 alpha:1]];
    }
	
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.collectionView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 40;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"exampleCell" forIndexPath:indexPath];
    return cell;
}
@end
