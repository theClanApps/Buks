//
//  ViewController.h
//  CollectionViewInTableCell
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Beer;
@class BeerStyle;

extern NSString * const kBKSUserToggleSetting;

@protocol BKSBeerListsViewControllerDelegate;

@interface BKSBeerListsViewController : UIViewController

@property (strong, nonatomic) NSArray *allBeers;
@property (weak, nonatomic) id <BKSBeerListsViewControllerDelegate> delegate;

@end

@protocol BKSBeerListsViewControllerDelegate <NSObject>

- (void)beerListsViewControllerDidPushProgressButton:(BKSBeerListsViewController *)beerListsVC;

- (void)beerListsViewControllerDidSelectBeer:(BKSBeerListsViewController *)beerListsVC beerSelected:(Beer *)beerSelected;

- (void)beerListsViewControllerDidPushRandomButton:(BKSBeerListsViewController *)beerListsVC randomBeer:(Beer *)beer;

- (void)beerListsViewControllerDidSelectStyle:(BKSBeerListsViewController *)beerListsVC styleSelected:(BeerStyle *)styleSelected;

@end