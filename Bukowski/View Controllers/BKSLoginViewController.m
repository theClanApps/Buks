//
//  BKSLoginViewController.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import "BKSLoginViewController.h"
#import "BKSAccountManager.h"
#import "BKSWelcomeViewController.h"
#import <Parse/Parse.h>
#import "PFFacebookUtils.h"

static NSString * const kBKSSegueToWelcomeViewControllerIdentifier = @"kBKSSegueToWelcomeViewControllerIdentifier";

@interface BKSLoginViewController ()

@end

@implementation BKSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BKSAccountManager sharedAccountManager] loadInitialBeers];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    [[BKSAccountManager sharedAccountManager] loginWithWithSuccess:^(id successObject) {
        [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kBKSSegueToWelcomeViewControllerIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[BKSWelcomeViewController class]]) {
            BKSWelcomeViewController *welcomeVC = (BKSWelcomeViewController *)segue.destinationViewController;
            welcomeVC.userName = [PFUser currentUser][@"name"];
            welcomeVC.profilePicture = [NSURL URLWithString:[PFUser currentUser][@"profilePictureURL"]];
            welcomeVC.navigationItem.hidesBackButton = YES;
        }
    }
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[BKSAccountManager sharedAccountManager] logout];
}

@end
