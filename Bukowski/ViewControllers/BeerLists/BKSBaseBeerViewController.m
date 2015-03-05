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
#import "BKSProgressViewController.h"
#import "BKSSearchResultsViewController.h"
#import "BKSBeerDetailViewController.h"
#import "BKSStyleViewController.h"
#import "Beer.h"

NSString * const kBKSBeerListsViewController = @"BKSBeerListsViewController";
NSString * const kBKSSearchResultsViewController = @"BKSSearchResultsViewController";
NSString * const kBKSProgressSegue = @"kBKSProgressSegue";
NSString * const kBKSBeerDetailSegue = @"kBKSBeerDetailSegue";
NSString * const kBKSStyleDetailSegue = @"kBKSStyleDetailSegue";

@interface BKSBaseBeerViewController () <BKSBeerListsViewControllerDelegate, BKSSearchResultsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (strong, nonatomic) BKSBeerListsViewController *beerListsVC;
@property (strong, nonatomic) BKSSearchResultsViewController *searchResultsVC;
@property (strong, nonatomic) NSArray *allBeers;
@property (weak, nonatomic) IBOutlet UISearchBar *beerSearchBar;

@end

@implementation BKSBaseBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildViewControllers];
    [self registerForMarkedDrankNotifications];

    [self loadBeers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
    [self setChildViewController:self.beerListsVC];
}

- (void)setupNavigationBar {
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
    UserObject *currentUser = [UserObject currentUser];
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Mug Hub", currentUser.name];
}

- (void)setupChildViewControllers {
    self.beerListsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kBKSBeerListsViewController];
    self.beerListsVC.delegate = self;
    
    self.searchResultsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kBKSSearchResultsViewController];

    self.searchResultsVC.delegate = self;
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
            self.searchResultsVC.allBeers = self.allBeers;
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading beers" message:@"Beers were unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

#pragma mark - BKSBeerListsViewControllerDelegate

- (void)beerListsViewControllerDidPushProgressButton:(BKSBeerListsViewController *)beerListsVC {
    [self performSegueWithIdentifier:kBKSProgressSegue sender:nil];
}

- (void)beerListsViewControllerDidSelectBeer:(BKSBeerListsViewController *)beerListsVC beerSelected:(Beer *)beerSelected {
    self.beerSelected = beerSelected;
    [self performSegueWithIdentifier:kBKSBeerDetailSegue sender:nil];
}

- (void)beerListsViewControllerDidPushRandomButton:(BKSBeerListsViewController *)beerListsVC randomBeer:(Beer *)beer {
    self.beerSelected = beer;
    [self performSegueWithIdentifier:kBKSBeerDetailSegue sender:nil];
}

- (void)beerListsViewControllerDidSelectStyle:(BKSBeerListsViewController *)beerListsVC styleSelected:(BeerStyle *)styleSelected {
    self.styleSelected = styleSelected;
    [self performSegueWithIdentifier:kBKSStyleDetailSegue sender:nil];
}

#pragma mark - BKSSearchResultsViewController

- (void)beerSearchResultsViewControllerDidSelectBeer:(BKSSearchResultsViewController *)beerSearchResultsVC beerSelected:(Beer *)beerSelected {
    [self clearSearch];
    self.beerSelected = beerSelected;
    [self performSegueWithIdentifier:kBKSBeerDetailSegue sender:nil];
}

#pragma mark - Search Bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self setChildViewController:self.searchResultsVC];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self setChildViewController:self.beerListsVC];
    [self clearSearch];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    self.searchResultsVC.beersFilteredCollection.filterString = searchBar.text;
    [self.searchResultsVC.searchResultsTableView reloadData];
}

- (void)clearSearch {
    [self.beerSearchBar setShowsCancelButton:NO animated:YES];
    if (self.beerSearchBar.isFirstResponder) {
        [self.beerSearchBar resignFirstResponder];
    }
    [self.beerSearchBar setText:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    if ([[segue identifier] isEqualToString:kBKSProgressSegue]) {
        BKSProgressViewController *detailVC = (BKSProgressViewController *)segue.destinationViewController;
        //send the user logged in to this VC
        detailVC.currentUser = [UserObject currentUser];
        //send the userBeers to this VC
        detailVC.userBeers = self.allBeers;
    }
    
    if ([[segue identifier] isEqualToString:kBKSBeerDetailSegue]) {
        BKSBeerDetailViewController *detailVC = (BKSBeerDetailViewController *)segue.destinationViewController;
        detailVC.beer = self.beerSelected;
    }
    
    if ([[segue identifier] isEqualToString:kBKSStyleDetailSegue]) {
        BKSStyleViewController *styleVC = (BKSStyleViewController *)segue.destinationViewController;
        styleVC.style = self.styleSelected;
    }
}

- (BOOL)searchVCIsVisible {
    return [self.childViewControllers firstObject] == self.searchResultsVC;
}

#pragma mark - Helpers

- (NSArray *)beerObjectsFromStyle:(BeerStyle *)style {
    NSArray *beers = [self.allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beerStyle == %@)", self.styleSelected]];
    return beers;
}

#pragma mark - Notifications

- (void)registerForMarkedDrankNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadBeers)
                                                 name:kBKSBeersNeedUpdateNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
