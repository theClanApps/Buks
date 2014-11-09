//
//  BKSMyFavoritesCollectionViewController.m
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BKSMyFavoritesCollectionViewController.h"
#import "BeerObject.h"
#import "BKSBeerDetailViewController.h"

@interface BKSMyFavoritesCollectionViewController ()

@property (nonatomic, strong) BeerObject *beerSelected;

@end

@implementation BKSMyFavoritesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.beerSelected = [self.beers objectAtIndex:indexPath.item];
    [self performSegueWithIdentifier:@"beerDetailSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beerDetailSegue"]) {
        BKSBeerDetailViewController *detailVC = (BKSBeerDetailViewController *)segue.destinationViewController;
        detailVC.beer = self.beerSelected;
    }
    
}


@end
