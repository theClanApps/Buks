//
//  BKSBaseBeerCollectionViewController.m
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BKSBaseBeerCollectionViewController.h"
#import "CollectionCell.h"
#import "BeerObject.h"

@interface BKSBaseBeerCollectionViewController ()

@end

@implementation BKSBaseBeerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    
    [self loadBeers];
    [self setupCollectionView];
}

-(void)loadBeers {
    
    self.beers = [BeerObject listOfBeers];
    
}

-(void)setupCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(223, 363)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.beers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cvCell";
    
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    BeerObject *beer = [self.beers objectAtIndex:indexPath.row];
    
    cell.beerImage.image = beer.bottleImage;
    cell.beerNameLabel.text =  beer.nickname;
    
    return cell;
}

@end
