//
//  BKSOnboardingManager.m
//  Bukowski
//
//  Created by Nick.Servidio on 3/2/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSOnboardingManager.h"
#import "BKSLoginViewController.h"
#import "BKSStartMugClubViewController.h"
#import "BKSAccountManager.h"

NSString * const kBKSBKSLoginViewController = @"BKSLoginViewController";
NSString * const kBKSBKSStartMugClubViewController = @"BKSStartMugClubViewController";

@interface BKSOnboardingManager ()
@property (strong, nonatomic) UIViewController *initialViewController;

@end

@implementation BKSOnboardingManager

- (UIViewController *)createAuthenticationViewController {
    BKSLoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main"
                                                            bundle:nil] instantiateViewControllerWithIdentifier:kBKSBKSLoginViewController];
    vc.delegate = self;
    return vc;
}

- (UIViewController *)createEmailPhoneOnboardingViewController {
    BKSStartMugClubViewController *vc = [[UIStoryboard storyboardWithName:@"Main"
                                                                   bundle:nil] instantiateViewControllerWithIdentifier:kBKSBKSStartMugClubViewController];
    vc.delegate = self;
    return vc;
}

- (UIViewController *)createNextOnboardingViewController {
    UIViewController *vc = nil;
    
    if (![[self class] isAuthenticationComplete]) {
        vc = [self createAuthenticationViewController];
    } else if (![[self class] isStartMugClubComplete]) {
        vc = [self createEmailPhoneOnboardingViewController];
    }
    
    return vc;
}

- (UIViewController *)createInitialOnboardingViewController {
    UIViewController *vc = [self createNextOnboardingViewController];
    NSAssert(vc != nil, @"Attempting to create the initial onboarding view controller when there isn't one.");
    self.initialViewController = vc;
    return vc;
}

#pragma mark - IsComplete Logic

+ (BOOL)isAuthenticationComplete {
    return [[BKSAccountManager sharedAccountManager] userIsLoggedIn];
}

+ (BOOL)isStartMugClubComplete {
    return [[BKSAccountManager sharedAccountManager] userStartedMugClub];
}

+ (BOOL)isOnboardingComplete {
    return ([self isAuthenticationComplete] &&
            [self isStartMugClubComplete]);
}

#pragma mark - BKSFlowStepDelegate

- (void)didFinishFlowStepWithViewController:(UIViewController *)viewController {
    if ([[self class] isOnboardingComplete]) {
        [self.delegate didFinishOnboarding];
    } else {
        UIViewController *nextViewController = [self createNextOnboardingViewController];
        NSAssert(nextViewController != nil, @"Attempting to show next view controller when there isn't one.");
        [viewController.navigationController pushViewController:nextViewController
                                                       animated:YES];
    }
}

@end
