//
//  BKSFlowStepDelegate.h
//  Bukowski
//
//  Created by Nick.Servidio on 3/2/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BKSFlowStepDelegate <NSObject>

- (void)didFinishFlowStepWithViewController:(UIViewController *)viewController;
//- (void)didCancelFlowStepWithViewController:(UIViewController *)viewController;
//
//- (BOOL)shouldDisplayBackButtonForFlowStepWithViewController:(UIViewController *)viewController;

@end
