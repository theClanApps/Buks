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
#import "BKSAccountManager.h"
#import "UserBeerObject.h"

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
    [[BKSAccountManager sharedAccountManager] loadBeersWithSuccess:^(NSArray *beers, NSError *error) {
        if (!error) {
            self.beers = beers;
            [self.collectionView reloadData];
            
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading beers" message:@"Beers were unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

-(void)setupCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(112, 182)];
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
    BeerObject *beer = ((UserBeerObject *)[self.beers objectAtIndex:indexPath.row]).beer;
    [beer fetchIfNeeded];
    cell.beerNameLabel.text =  beer.nickname;
    cell.beerImage.image = [self imageForParseFile:beer.bottleImage];
    
    return cell;
}

- (UIImage*)imageForParseFile:(PFFile *)pffile
{
    PFFile *theImage = pffile;
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}



@end
