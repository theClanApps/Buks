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
@property (weak, nonatomic) IBOutlet UIImageView *mugLogoImageView;

@end

@implementation BKSLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self setAutoLayout];
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        if ([[BKSAccountManager sharedAccountManager] userStartedMugClub]) {
            [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
            [[BKSAccountManager sharedAccountManager] startCheckingForBeerUpdates];
        } else {
            [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
        }
    }
}

- (void)setAutoLayout {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGFloat aspectRatio = screenHeight/screenWidth;
    //NSLog(@"Width: %f, Height: %f", screenWidth, screenHeight);
    NSLog(@"Aspect Ratio: %f", screenHeight/screenWidth);
    
    NSLayoutConstraint *constraint =[NSLayoutConstraint
                                     constraintWithItem:self.mugLogoImageView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.mugLogoImageView
                                     attribute:NSLayoutAttributeWidth
                                     multiplier:aspectRatio
                                     constant:0.0f];
    [self.mugLogoImageView addConstraint:constraint];
    
    NSLog(@"Image Aspect Ratio: %f", self.mugLogoImageView.frame.size.height/self.mugLogoImageView.frame.size.width);
}

- (IBAction)loginButtonPressed:(id)sender {
    [[BKSAccountManager sharedAccountManager] loginWithWithSuccess:^(id successObject) {
        if ([[BKSAccountManager sharedAccountManager] userStartedMugClub]) {
            [self performSegueWithIdentifier:kSegueToBeerViewController sender:self];
            [[BKSAccountManager sharedAccountManager] startCheckingForBeerUpdates];
        } else {
            [self performSegueWithIdentifier:kBKSSegueToWelcomeViewControllerIdentifier sender:self];
        }
    } failure:^(NSError *error) {
        [self showLoginFailureAlertView];
    }];
}

- (void)showLoginFailureAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                    message:@"There was an error loggin in."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Dismiss", nil];
    [alert show];
}

@end
