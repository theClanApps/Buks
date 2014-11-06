//
//  ParseStarterProjectViewController.m
//  ParseStarterProject
//
//  Copyright 2014 Parse, Inc. All rights reserved.
//

#import "BKSBeerViewController.h"
#import <Parse/Parse.h>
#import "NonPersistedBeer.h"
#import "BKSAccountManager.h"

@interface BKSBeerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *beerImageView;
@property (strong, nonatomic) NSArray *beerArray;
@end

@implementation BKSBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBeers];
}

- (void)loadBeers
{
    [[BKSAccountManager sharedAccountManager] loadBeersWithSuccess:^(NSArray *beers, NSError *error) {
        if (!error) {
            self.beerArray = beers;
            [self showOneBeerImage:(NonPersistedBeer *)beers[0]];
        } else {
            NSLog(@"Error: %@",error);
        }
    }];
}

- (void)showOneBeerImage:(NonPersistedBeer *)beer
{
    PFFile *theImage = beer.nonPersistedBeerImage;
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.beerImageView.image = image;
}

@end
