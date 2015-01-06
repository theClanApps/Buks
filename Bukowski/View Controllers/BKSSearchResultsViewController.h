//
//  BKSSearchResultsViewController.h
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKSBeersFilteredCollection.h"

@protocol BKSSearchResultsViewControllerDelegate;

@interface BKSSearchResultsViewController : UIViewController

@property (strong, nonatomic) NSArray *allBeers;
@property (strong, nonatomic) NSMutableString *searchString;
@property (strong, nonatomic) BKSBeersFilteredCollection *beersFilteredCollection;
@property (weak, nonatomic) id <BKSSearchResultsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;

@end

@protocol BKSSearchResultsViewControllerDelegate <NSObject>

@end