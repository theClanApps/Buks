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
//#import "BeerObject.h"

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

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BKSBeerListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self loadBeers];
}

- (void)sortAllBeersIntoCategories:(NSArray *)allBeers {
    for (UserBeerObject *userBeerObject in self.allBeers) {
        [userBeerObject.beer fetchIfNeeded];
    }
    self.beersUnderEight = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.price < %@)", @"7"]];
}

- (void)loadBeers {
    [[BKSAccountManager sharedAccountManager] loadBeersWithSuccess:^(NSArray *beers, NSError *error) {
        if (!error) {
            self.allBeers = beers;
            
            [self sortAllBeersIntoCategories:self.allBeers];
            
            [self.tableView reloadData];
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
    [self setupFlowLayoutForCell:cell];
    
    return cell;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    return cell;
}

@end
