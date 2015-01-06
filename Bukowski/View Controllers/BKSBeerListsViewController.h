//
//  ViewController.h
//  CollectionViewInTableCell
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKSBeerListsViewControllerDeleagate;

@interface BKSBeerListsViewController : UIViewController

@property (strong, nonatomic) NSArray *allBeers;
@property (weak, nonatomic) id <BKSBeerListsViewControllerDeleagate> delegate;

@end

@protocol BKSBeerListsViewControllerDeleagate <NSObject>

- (void)beerListsViewControllerDidPushProgressButton:(BKSBeerListsViewController *)beerListsVC;

@end