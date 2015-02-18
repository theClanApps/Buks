//
//  ProgressSummaryDoneView.h
//  Bukowski
//
//  Created by Ezra on 1/19/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressSummaryDoneView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeIsUpTextLabel;

+ (id)progressSummaryDoneView;

@end
