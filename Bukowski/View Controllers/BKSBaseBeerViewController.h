//
//  BKSBaseBeerViewController.h
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBeerObject.h"
#import "BeerStyle.h"

@interface BKSBaseBeerViewController : UIViewController

@property (strong, nonatomic) UserBeerObject *beerSelected;
@property (strong, nonatomic) BeerStyle *styleSelected;

@end
