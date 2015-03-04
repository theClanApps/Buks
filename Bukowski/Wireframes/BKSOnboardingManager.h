//
//  BKSOnboardingManager.h
//  Bukowski
//
//  Created by Nick.Servidio on 3/2/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BKSOnboardingFlowDelegate.h"
#import "BKSFlowStepDelegate.h"

@interface BKSOnboardingManager : NSObject <BKSFlowStepDelegate>

@property (nonatomic, assign) id<BKSOnboardingFlowDelegate> delegate;

- (UIViewController *)createInitialOnboardingViewController;
+ (BOOL)isOnboardingComplete;

@end
