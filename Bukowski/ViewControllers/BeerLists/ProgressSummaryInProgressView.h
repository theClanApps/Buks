//
//  ProgressSummaryInProgressView.h
//  Bukowski
//
//  Created by Ezra on 1/18/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressSummaryInProgressView : UIView

@property (weak, nonatomic) IBOutlet UILabel *beerDrankLabel;
@property (weak, nonatomic) IBOutlet UILabel *beersRemainingLabel;
@property (nonatomic) NSUInteger *totalBeers;
@property (nonatomic) NSUInteger *beersDrank;

+ (id)progressSummaryInProgressView;

@end
