//
//  BKSStartMugClubViewController.m
//  Bukowski
//
//  Created by Nicholas Servidio on 11/3/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSStartMugClubViewController.h"
#import "BKSAccountManager.h"

static NSString * const kSegueToBeerViewController = @"kSegueToBeerViewController";

@interface BKSStartMugClubViewController () <UIAlertViewDelegate>
@end

@implementation BKSStartMugClubViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[BKSAccountManager sharedAccountManager] userStartedMugClub]) {
        [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
    }
}

- (IBAction)startMugClubButtonPressed:(id)sender {
    [[BKSAccountManager sharedAccountManager] startMugClubWithSuccess:^(id successObject) {
        [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
    } failure:^(NSError *error) {
        [self showFailedToJoinMugClubError];
    }];
}

- (void)showFailedToJoinMugClubError {
    UIAlertView *failedToJoinMugClubAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                           message:@"Sorry, you could not start the mug club at this time."
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
    [failedToJoinMugClubAlertView show];
}

@end
