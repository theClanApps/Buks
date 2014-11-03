//
//  BKSMyFavoritesCollectionViewController.m
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BKSMyFavoritesCollectionViewController.h"
#import "BeerObject.h"

@interface BKSMyFavoritesCollectionViewController ()

@end

@implementation BKSMyFavoritesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)loadBeers
{
    self.beers = [BeerObject listOfBeers];
}

@end
