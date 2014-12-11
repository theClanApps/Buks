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
NSString * const kBKSUserToggleSetting = @"UserToggleSetting";

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
}

- (void)setup {
    [self loadBeers];
    [self setToggleValue];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)setToggleValue {
    NSUserDefaults *userToggleSetting = [NSUserDefaults standardUserDefaults];
    
    //Check if default has been set.
    //If so, retrieve stored value & apply to switch
    //If not, set switch to ON
    id obj = [userToggleSetting objectForKey:kBKSUserToggleSetting];
    
    if (obj != nil) {
        [self.toggleAllOrRemainingSwitch setOn:[[userToggleSetting objectForKey:kBKSUserToggleSetting] boolValue]];
    } else {
        [self.toggleAllOrRemainingSwitch setOn:YES];
    }
}

- (void)sortAllBeersIntoCategories:(NSArray *)allBeers {
    NSMutableArray *beerObjects = [[NSMutableArray alloc] init];
    for (UserBeerObject *userBeerObject in self.allBeers) {
        [beerObjects addObject:userBeerObject.beer];
    }

    [PFObject fetchAllInBackground:[beerObjects mutableCopy] block:^(NSArray *objects, NSError *error) {
                self.beersUnderEight = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.price < %@)", @"7"]];
                self.beersUnderFivePercent = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.abv < %@)", @"5"]];
                self.allBeersRemaining = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
                self.beersUnderEightRemaining = [self.beersUnderEight filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
                self.beersUnderFivePercentRemaining = [self.beersUnderFivePercent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"drank = false"]];
                [self reloadAllCollectionViews];

    }];
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
        if (self.toggleAllOrRemainingSwitch.isOn) {
            numberOfBeersInSection = self.allBeersRemaining.count;
        } else {
            numberOfBeersInSection = self.allBeers.count;
        }
    } else
        if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
            if (self.toggleAllOrRemainingSwitch.isOn) {
                numberOfBeersInSection = self.beersUnderEightRemaining.count;
            } else {
                numberOfBeersInSection = self.beersUnderEight.count;
            }
        } else
            if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
                if (self.toggleAllOrRemainingSwitch.isOn) {
                    numberOfBeersInSection = self.beersUnderFivePercentRemaining.count;
                } else {
                    numberOfBeersInSection = self.beersUnderFivePercent.count;
                }
            }

    return numberOfBeersInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    BeerObject *beer;
    
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((UserBeerObject *)[self.allBeersRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.allBeers objectAtIndex:indexPath.row]).beer;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((UserBeerObject *)[self.beersUnderEightRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.beersUnderEight objectAtIndex:indexPath.row]).beer;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((UserBeerObject *)[self.beersUnderFivePercentRemaining objectAtIndex:indexPath.row]).beer;
        } else {
            beer = ((UserBeerObject *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]).beer;
        }
    }
    
    cell.beerNameLabel.text =  beer.nickname;

    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        PFFile *theImage = beer.bottleImage;
        NSData *imageData = [theImage getData];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.beerImage.image = image;
                });
            }
        }
    });

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((UserBeerObject *)[self.allBeersRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((UserBeerObject *)[self.allBeers objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((UserBeerObject *)[self.beersUnderEightRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((UserBeerObject *)[self.beersUnderEight objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((UserBeerObject *)[self.beersUnderFivePercentRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((UserBeerObject *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]);
        }
    }
    [self performSegueWithIdentifier:@"beerDetailSegue" sender:nil];
}

- (IBAction)toggledSwitch:(UISwitch *)sender {
    //Save toggle setting for that user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:self.toggleAllOrRemainingSwitch.on] forKey:kBKSUserToggleSetting];
    [defaults synchronize];
    [self reloadAllCollectionViews];
}

- (void)reloadAllCollectionViews {
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            BKSBeerCollectionTableViewCell *cell = (BKSBeerCollectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [cell.collectionView reloadData];
        }
    }
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
        detailVC.beer = [self generateRandomBeer];
    }
}

- (UserBeerObject *)generateRandomBeer {
    UserBeerObject *randomBeer = nil;
    int i = 0;
    if (self.toggleAllOrRemainingSwitch.isOn) {
        i = (arc4random() % (self.allBeersRemaining.count));
        NSLog(@"%i / %lu",i,(unsigned long)self.allBeersRemaining.count);
        randomBeer = self.allBeersRemaining[i];
    } else {
        i = (arc4random() % (self.allBeers.count));
        NSLog(@"%i / %lu",i,(unsigned long)self.allBeers.count);
        randomBeer = self.allBeers[i];
    }
    return randomBeer;
}

- (IBAction)didTapLogoutButton:(id)sender {
    [[BKSAccountManager sharedAccountManager] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
