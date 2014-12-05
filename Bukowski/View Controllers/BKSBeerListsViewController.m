//
//  ViewController.m
//  CollectionViewInTableCell
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSBeerListsViewController.h"
#import "BKSBeerCollectionTableViewCell.h"
#import "BKSAccountManager.h"
#import "UserBeerObject.h"
#import "BeerObject.h"
#import "CollectionCell.h"
#import "BKSBeerDetailViewController.h"

typedef NS_ENUM(NSInteger, BKSBeerCategorySection) {
    BKSBeerCategorySectionAllBeers,
    BKSBeerCategorySectionBeersUnderEight,
    BKSBeerCategorySectionBeersUnderFivePercent,
};

NSString * const kBKSAllBeers = @"All Beers";
NSString * const kBKSBeersUnderEight = @"Don't Break the Bank";
NSString * const kBKSBeersUnderFivePercent = @"Staying Soberish";

NSInteger const kBKSNumberOfSections = 3;

@interface BKSBeerListsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *allBeers;
@property (strong, nonatomic) NSArray *beersUnderEight;
@property (strong, nonatomic) NSArray *beersUnderFivePercent;
@property (strong, nonatomic) NSArray *allBeersRemaining;
@property (strong, nonatomic) NSArray *beersUnderEightRemaining;
@property (strong, nonatomic) NSArray *beersUnderFivePercentRemaining;
@property (strong, nonatomic) UserBeerObject *beerSelected;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *toggleAllOrRemainingSwitch;
@end

@implementation BKSBeerListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    [self.toggleAllOrRemainingSwitch addTarget:self
                                        action:@selector(stateChanged:)
                              forControlEvents:UIControlEventValueChanged];
}

- (void)setup {
    [self loadBeers];
    
    self.showOnlyRemainingBeers = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)sortAllBeersIntoCategories:(NSArray *)allBeers {
    for (UserBeerObject *userBeerObject in self.allBeers) {
        [userBeerObject.beer fetchIfNeeded];
    }
    self.beersUnderEight = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.price < %@)", @"7"]];
    self.beersUnderFivePercent = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.abv < %@)", @"5"]];
    self.allBeersRemaining = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
    self.beersUnderEightRemaining = [self.beersUnderEight filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
    self.beersUnderFivePercentRemaining = [self.beersUnderFivePercent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"drank = false"]];
}

- (void)loadBeers {
    [[BKSAccountManager sharedAccountManager] loadBeersWithSuccess:^(NSArray *beers, NSError *error) {
        if (!error) {
            self.allBeers = beers;
            
            [self sortAllBeersIntoCategories:self.allBeers];
            
            [self.tableView reloadData];
            
            [self reloadAllCollectionViews];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading beers" message:@"Beers were unable to load" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
        }
    }];
}

- (void)setupFlowLayoutForCell:(BKSBeerCollectionTableViewCell *)cell {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(112, 182)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    cell.collectionView.collectionViewLayout = flowLayout;
    cell.collectionView.backgroundColor = [UIColor clearColor];
    [cell.collectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kBKSNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case BKSBeerCategorySectionAllBeers: return kBKSAllBeers; break;
        case BKSBeerCategorySectionBeersUnderEight: return kBKSBeersUnderEight; break;
        case BKSBeerCategorySectionBeersUnderFivePercent: return kBKSBeersUnderFivePercent; break;
        default: return nil; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKSBeerCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.section == BKSBeerCategorySectionAllBeers) {
        cell.collectionView.tag = BKSBeerCategorySectionAllBeers;
    } else if (indexPath.section == BKSBeerCategorySectionBeersUnderEight) {
        cell.collectionView.tag = BKSBeerCategorySectionBeersUnderEight;
    } else if (indexPath.section == BKSBeerCategorySectionBeersUnderFivePercent) {
        cell.collectionView.tag = BKSBeerCategorySectionBeersUnderFivePercent;
    }
    [self setupFlowLayoutForCell:cell];
    
    return cell;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfBeersInSection = 0;
    
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.showOnlyRemainingBeers) {
            numberOfBeersInSection = self.allBeersRemaining.count;
        } else {
            numberOfBeersInSection = self.allBeers.count;
        }
    } else
    if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.showOnlyRemainingBeers) {
            numberOfBeersInSection = self.beersUnderEightRemaining.count;
        } else {
            numberOfBeersInSection = self.beersUnderEight.count;
        }
    } else
    if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.showOnlyRemainingBeers) {
            numberOfBeersInSection = self.beersUnderFivePercentRemaining.count;
        } else {
            numberOfBeersInSection = self.beersUnderFivePercent.count;
        }
    }

    NSLog(@"#: %lu", numberOfBeersInSection);
    
    return numberOfBeersInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    BeerObject *beer;
    
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.showOnlyRemainingBeers) {
            beer = ((UserBeerObject *)[self.allBeersRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.allBeers objectAtIndex:indexPath.row]).beer;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.showOnlyRemainingBeers) {
            beer = ((UserBeerObject *)[self.beersUnderEightRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.beersUnderEight objectAtIndex:indexPath.row]).beer;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.showOnlyRemainingBeers) {
            beer = ((UserBeerObject *)[self.beersUnderFivePercentRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]).beer;
        }
    }
    
    [beer fetchIfNeeded];
    cell.beerNameLabel.text =  beer.nickname;
    cell.beerImage.image = [self imageForParseFile:beer.bottleImage];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        self.beerSelected = ((UserBeerObject *)[self.allBeers objectAtIndex:indexPath.row]);
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        self.beerSelected = ((UserBeerObject *)[self.beersUnderEight objectAtIndex:indexPath.row]);
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        self.beerSelected = ((UserBeerObject *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]);
    }
    [self performSegueWithIdentifier:@"beerDetailSegue" sender:nil];
}

- (void)reloadAllCollectionViews {
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            BKSBeerCollectionTableViewCell *cell = (BKSBeerCollectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [cell.collectionView reloadData];
        }
    }
}

- (UIImage*)imageForParseFile:(PFFile *)pffile {
    PFFile *theImage = pffile;
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        self.showOnlyRemainingBeers = YES;
    } else {
        self.showOnlyRemainingBeers = NO;
    }
    
    [self reloadAllCollectionViews];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beerDetailSegue"]) {
        BKSBeerDetailViewController *detailVC = (BKSBeerDetailViewController *)segue.destinationViewController;
        detailVC.beer = self.beerSelected;
    }
    
    if ([[segue identifier] isEqualToString:@"randomBeerSegue"]) {
        BKSBeerDetailViewController *detailVC = (BKSBeerDetailViewController *)segue.destinationViewController;
        int i = 0;
        if (self.showOnlyRemainingBeers) {
            i = (arc4random() % (self.allBeersRemaining.count));
            NSLog(@"%i / %lu",i,(unsigned long)self.allBeersRemaining.count);
            detailVC.beer = self.allBeersRemaining[i];
        } else {
            i = (arc4random() % (self.allBeers.count));
            NSLog(@"%i / %lu",i,(unsigned long)self.allBeers.count);
            detailVC.beer = self.allBeers[i];
        }
    }
}

- (IBAction)didTapLogoutButton:(id)sender {
    [[BKSAccountManager sharedAccountManager] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
