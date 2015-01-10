//
//  ViewController.h
//  CollectionViewInTableCell
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBeerObject.h"
#import "BeerStyle.h"

@protocol BKSBeerListsViewControllerDelegate;

@interface BKSBeerListsViewController : UIViewController

@property (strong, nonatomic) NSArray *allBeers;
@property (weak, nonatomic) id <BKSBeerListsViewControllerDelegate> delegate;

@end

@protocol BKSBeerListsViewControllerDelegate <NSObject>

- (void)beerListsViewControllerDidPushProgressButton:(BKSBeerListsViewController *)beerListsVC;

- (void)beerListsViewControllerDidSelectBeer:(BKSBeerListsViewController *)beerListsVC beerSelected:(UserBeerObject *)beerSelected;

- (void)beerListsViewControllerDidPushRandomButton:(BKSBeerListsViewController *)beerListsVC randomBeer:(UserBeerObject *)beer;

- (void)beerListsViewControllerDidSelectStyle:(BKSBeerListsViewController *)beerListsVC styleSelected:(BeerStyle *)styleSelected;

@end