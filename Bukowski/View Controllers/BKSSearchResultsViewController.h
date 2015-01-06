//
//  BKSSearchResultsViewController.h
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//



#import <UIKit/UIKit.h>

@protocol BKSSearchResultsViewControllerDelegate;

@interface BKSSearchResultsViewController : UIViewController

@property (strong, nonatomic) NSArray *allBeers;
@property (weak, nonatomic) id <BKSSearchResultsViewControllerDelegate> delegate;

@end

@protocol BKSSearchResultsViewControllerDelegate <NSObject>

@end