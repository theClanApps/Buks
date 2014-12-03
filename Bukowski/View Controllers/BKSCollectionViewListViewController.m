//
//  BKSCollectionViewListViewController.m
//  Bukowski
//
//  Created by Ezra on 11/3/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSCollectionViewListViewController.h"
#import "BKSAccountManager.h"

@interface BKSCollectionViewListViewController ()

@end

@implementation BKSCollectionViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapLogoutButton:(id)sender {
    [[BKSAccountManager sharedAccountManager] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
