//
//  BKSRootViewController.m
//  Bukowski
//
//  Created by Nick.Servidio on 2/28/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSRootViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "BKSAccountManager.h"

#import "BKSLoginViewController.h"
#import "BKSStartMugClubViewController.h"
#import "BKSBaseBeerViewController.h"
#import "BKSOnboardingManager.h"
#import "BKSBaseBeerViewController.h"

NSString * const kBKSBKSBaseBeerViewController = @"BKSBaseBeerViewController";

@interface BKSRootViewController () <BKSOnboardingFlowDelegate, BKSBaseBeerViewControllerDelegate>
@property (strong, nonatomic) BKSOnboardingManager *onboardingManager;
@property (strong, nonatomic) UIViewController *selectedViewController;
@end

@implementation BKSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([BKSOnboardingManager isOnboardingComplete]) {
        [self loadInitialSection];
    } else {
        [self showOnboardingFlow];
    }
}

- (void)loadInitialSection {
    BKSBaseBeerViewController *baseBeer = [[UIStoryboard storyboardWithName:@"Main"
                                                                     bundle:nil] instantiateViewControllerWithIdentifier:kBKSBKSBaseBeerViewController];
    baseBeer.delegate = self;
    [self addViewControllerAsChild:[[UINavigationController alloc] initWithRootViewController:baseBeer]];
}

- (void)showOnboardingFlow {
    self.onboardingManager = [[BKSOnboardingManager alloc] init];
    self.onboardingManager.delegate = self;
    UIViewController *vc = [self.onboardingManager createInitialOnboardingViewController];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addViewControllerAsChild:nc];
}

- (void)addViewControllerAsChild:(UIViewController *)vc {
    [self hideChildViewController:self.selectedViewController];
    self.selectedViewController = vc;
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)hideChildViewController:(UIViewController *)vc {
    if (!vc) return;
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)didFinishOnboarding {
    [self loadInitialSection];
    self.onboardingManager = nil;
}

- (void)logOut {
    [self showOnboardingFlow];
}

#pragma mark - BKSBaseBeerViewControllerDelegate

- (void)baseBeerViewControllerDidPressLogoutButton:(BKSBaseBeerViewController *)vc {
    [self showOnboardingFlow];
}

@end
