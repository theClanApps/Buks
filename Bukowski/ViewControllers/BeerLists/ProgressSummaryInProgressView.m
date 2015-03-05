//
//  ProgressSummaryInProgressView.m
//  Bukowski
//
//  Created by Ezra on 1/18/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "ProgressSummaryInProgressView.h"

@implementation ProgressSummaryInProgressView

+ (id)progressSummaryInProgressView {
    ProgressSummaryInProgressView *progressSummaryInProgressView = [[[NSBundle mainBundle] loadNibNamed:@"ProgressSummaryInProgressView" owner:nil options:nil] lastObject];
    
    if ([progressSummaryInProgressView isKindOfClass:[ProgressSummaryInProgressView class]]) {
        progressSummaryInProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        return progressSummaryInProgressView;
    } else {
        return nil;
    }
}



//-(void)drawRect:(CGRect)rect{
//    [[UIColor redColor] setFill];
//    UIRectFill(CGRectInset(self.bounds, 100, 100));
//}

@end
