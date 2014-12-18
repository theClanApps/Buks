//
//  BKSRateView.h
//  Bukowski
//
//  Created by Ezra on 12/15/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKSRateView;

@protocol BKSRateViewDelegate
@end

@interface BKSRateView : UIView

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (strong, nonatomic) UIImage *greyImage;
@property (assign, nonatomic) NSNumber *rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray *imageViews;
@property (assign, nonatomic) int numberOfStars;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <BKSRateViewDelegate> delegate;

@end
