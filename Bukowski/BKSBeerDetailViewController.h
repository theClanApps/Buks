//
//  BKSBeerDetailViewController.h
//  Bukowski
//
//  Created by Ezra on 11/5/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKSRateView.h"
@class UserBeerObject;

@interface BKSBeerDetailViewController : UIViewController <BKSRateViewDelegate>

@property (nonatomic, strong) UserBeerObject *beer;


@property (weak, nonatomic) IBOutlet BKSRateView *rateView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rateBarButton;



@end
