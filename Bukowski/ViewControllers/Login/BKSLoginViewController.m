//
//  BKSLoginViewController.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import "BKSLoginViewController.h"
#import "BKSAccountManager.h"
#import <Parse/Parse.h>
#import "PFFacebookUtils.h"

static NSString * const kBKSSegueToWelcomeViewControllerIdentifier = @"kBKSSegueToWelcomeViewControllerIdentifier";
static NSString * const kSegueToBeerViewController = @"kSegueToBeerViewController";

@interface BKSLoginViewController ()

@end

@implementation BKSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        if ([[BKSAccountManager sharedAccountManager] userStartedMugClub]) {
            [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
        } else {
            [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
        }
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    [[BKSAccountManager sharedAccountManager] loginWithWithSuccess:^(id successObject) {
        if ([[BKSAccountManager sharedAccountManager] userStartedMugClub]) {
            [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
        } else {
            [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
        }
    } failure:^(NSError *error) {
        [self showLoginFailureAlertView];
    }];
}

- (void)showLoginFailureAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                    message:@"There was an error loggin in."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Dismiss", nil];
    [alert show];
}

@end
