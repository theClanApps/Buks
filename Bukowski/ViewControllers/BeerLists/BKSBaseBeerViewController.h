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

@interface BKSBaseBeerViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) Beer *beerSelected;
@property (strong, nonatomic) BeerStyle *styleSelected;

@end
