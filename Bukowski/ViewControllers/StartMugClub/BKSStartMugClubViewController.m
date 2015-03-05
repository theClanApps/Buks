//
//  BKSStartMugClubViewController.m
//  Bukowski
//
//  Created by Nicholas Servidio on 11/3/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSStartMugClubViewController.h"
#import "BKSAccountManager.h"
#import "BKSLoginViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const kSegueToBeerViewController = @"kSegueToBeerViewController";

@interface BKSStartMugClubViewController () <UIAlertViewDelegate>
@end

@implementation BKSStartMugClubViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (IBAction)startMugClubButtonPressed:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[BKSAccountManager sharedAccountManager] startMugClubWithSuccess:^(id successObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate didFinishFlowStepWithViewController:self];
            [SVProgressHUD dismiss];
        });
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
