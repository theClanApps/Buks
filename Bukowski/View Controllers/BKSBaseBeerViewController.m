//
//  BKSBaseBeerViewController.m
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSBaseBeerViewController.h"
#import "BKSBeerListsViewController.h"
#import "BKSAccountManager.h"

NSString * const kBKSBeerListsViewController = @"BKSBeerListsViewController";

@interface BKSBaseBeerViewController ()
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (strong, nonatomic) BKSBeerListsViewController *beerListsVC;
@property (strong, nonatomic) NSArray *allBeers;

@end

@implementation BKSBaseBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beerListsVC = [[BKSBeerListsViewController alloc] init];
    
    self.beerListsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kBKSBeerListsViewController];
    
    [self loadBeers];
    // Do any additional setup after loading the view.
}

- (void)setChildViewController:(UIViewController *)child {
    [self removeCurrentChildViewsController];
    [self addChildViewController:child];
    child.view.frame = self.childView.bounds;
    [self.childView addSubview:child.view];
    [child didMoveToParentViewController:self];
}

- (void)removeCurrentChildViewsController {
    UIViewController *child = [self.childViewControllers firstObject];
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

- (BOOL)groupedVCIsVisible {
    return [self.childViewControllers firstObject] == self.beerListsVC;
}

- (void)loadBeers {
    [[BKSAccountManager sharedAccountManager] loadBeersWithSuccess:^(NSArray *beers, NSError *error) {
        if (!error) {
            self.allBeers = beers;
            self.beerListsVC.allBeers = self.allBeers;
            [self setChildViewController:self.beerListsVC];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading beers" message:@"Beers were unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

//- (BOOL)searchVCIsVisible {
//    return [self.childViewControllers firstObject] == self.searchVC;
//}

@end
