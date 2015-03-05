//
//  BKSBaseBeerViewController.h
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Beer;
@class BeerStyle;

@protocol BKSBaseBeerViewControllerDelegate;

@interface BKSBaseBeerViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) id<BKSBaseBeerViewControllerDelegate> delegate;
@property (strong, nonatomic) Beer *beerSelected;
@property (strong, nonatomic) BeerStyle *styleSelected;

@end

@protocol BKSBaseBeerViewControllerDelegate <NSObject>

- (void)baseBeerViewControllerDidPressLogoutButton:(BKSBaseBeerViewController *)vc;

@end
