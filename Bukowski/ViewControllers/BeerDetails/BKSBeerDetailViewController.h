//
//  BKSBeerDetailViewController.h
//  Bukowski
//
//  Created by Ezra on 11/5/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKSRateView.h"
@class Beer;

@interface BKSBeerDetailViewController : UIViewController <BKSRateViewDelegate>

@property (nonatomic, strong) Beer *beer;

@end
