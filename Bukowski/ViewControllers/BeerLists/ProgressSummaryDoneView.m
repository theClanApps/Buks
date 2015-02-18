//
//  ProgressSummaryDoneView.m
//  Bukowski
//
//  Created by Ezra on 1/19/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "ProgressSummaryDoneView.h"

@implementation ProgressSummaryDoneView

+ (id)progressSummaryDoneView {
    ProgressSummaryDoneView *progressSummaryDoneView = [[[NSBundle mainBundle] loadNibNamed:@"ProgressSummaryDoneView" owner:nil options:nil] lastObject];
    
    if ([progressSummaryDoneView isKindOfClass:[ProgressSummaryDoneView class]]) {
        return progressSummaryDoneView;
    } else {
        return nil;
    }
}

@end
