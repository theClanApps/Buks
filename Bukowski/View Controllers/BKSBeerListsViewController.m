//
//  ViewController.m
//  CollectionViewInTableCell
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSBeerListsViewController.h"
#import "BKSBeerCollectionTableViewCell.h"

@interface BKSBeerListsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BKSBeerListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self registerNibs];
}

- (void)registerNibs {
    
}

- (void)setupFlowLayoutForCell:(BKSBeerCollectionTableViewCell *)cell {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(112, 182)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    cell.collectionView.collectionViewLayout = flowLayout;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKSBeerCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [self setupFlowLayoutForCell:cell];
    
    return cell;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    return cell;
}

@end
