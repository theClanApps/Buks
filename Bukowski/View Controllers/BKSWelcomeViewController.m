//
//  BKSWelcomeViewController.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import "BKSWelcomeViewController.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BKSWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation BKSWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.userNameLabel.text = self.userName;
    [self.profilePictureImageView sd_setImageWithURL:self.profilePicture placeholderImage:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
