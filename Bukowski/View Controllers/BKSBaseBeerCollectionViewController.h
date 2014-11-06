//
//  BKSBaseBeerCollectionViewController.h
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeerObject;

@interface BKSBaseBeerCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *beers;

-(void)loadBeers;
-(void)setup;

@end
