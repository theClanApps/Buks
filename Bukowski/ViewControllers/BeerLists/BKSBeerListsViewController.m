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
#import "CollectionCell.h"
#import "BKSBeerDetailViewController.h"
#import "BeerStyleObject.h"
#import "BKSStyleViewController.h"
#import "BKSProgressViewController.h"
#import "BKSDataManager.h"
#import "Beer.h"
#import "BeerStyle.h"
#import "UIImageView+WebCache.h"
#import "ProgressSummaryInProgressView.h"
#import "ProgressSummaryDoneView.h"

typedef NS_ENUM(NSInteger, BKSBeerCategorySection) {
    BKSBeerCategorySectionAllBeers,
    BKSBeerCategorySectionBeersUnderEight,
    BKSBeerCategorySectionBeersUnderFivePercent,
    BKSBeerCategorySectionStyles,
};

NSString * const kBKSAllBeers = @"All Beers";
NSString * const kBKSBeersUnderEight = @"Don't Break the Bank";
NSString * const kBKSBeersUnderFivePercent = @"Staying Soberish";
NSString * const kBKSBeerStyles = @"Styles";
NSString * const kBKSUserToggleSetting = @"UserToggleSetting";

NSInteger const kBKSNumberOfSections = 4;

@interface BKSBeerListsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *beersUnderEight;
@property (strong, nonatomic) NSArray *beersUnderFivePercent;
@property (strong, nonatomic) NSArray *allBeersRemaining;
@property (strong, nonatomic) NSArray *beersUnderEightRemaining;
@property (strong, nonatomic) NSArray *beersUnderFivePercentRemaining;
@property (strong, nonatomic) NSArray *styles;
@property (strong, nonatomic) NSArray *stylesRemaining;

@property (strong, nonatomic) Beer *beerSelected;
@property (strong, nonatomic) BeerStyle *styleSelected;
@property (strong, nonatomic) UserObject *userLoggedIn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *toggleAllOrRemainingSwitch;
@property (weak, nonatomic) IBOutlet UIView *progressChildView;

@end

@implementation BKSBeerListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setToggleValue];
    [self reloadAllCollectionViews];
    [self setChildProgressViewController];
}

- (void)setChildProgressViewController {
    
#warning - need to check if subviews exist & remove them
    
    if (self.userLoggedIn.finishedMugClub) {
        ProgressSummaryDoneView *progressSummaryDoneView = [ProgressSummaryDoneView progressSummaryDoneView];
        [self.progressChildView addSubview:progressSummaryDoneView];
        progressSummaryDoneView.timeIsUpTextLabel.text = @"You drank all the beers! Way to go! Enjoy discounted huge beers at Buks for life!";
    } else if (self.userLoggedIn.ranOutOfTime) {
        ProgressSummaryDoneView *progressSummaryDoneView = [ProgressSummaryDoneView progressSummaryDoneView];
        [self.progressChildView addSubview:progressSummaryDoneView];
        progressSummaryDoneView.timeIsUpTextLabel.text = @"You didn't finish all the beers in the allotted time. Enjoy thinking about the money you've pissed away here!";
    } else {
        ProgressSummaryInProgressView *progressSummaryInProgressView = [ProgressSummaryInProgressView progressSummaryInProgressView];
        [self.progressChildView addSubview:progressSummaryInProgressView];

#warning autolayout still messed up
        //[self.progressChildView sizeToFit];
        //[progressSummaryInProgressView layoutIfNeeded];
        //[progressSummaryInProgressView setNeedsLayout];
        //[self.progressChildView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //self.progressChildView.frame = self.progressChildView.bounds;
    }
}

- (void)setAllBeers:(NSArray *)allBeers {
    _allBeers = allBeers;
    [self sortAllBeersIntoCategories:_allBeers];
}

- (void)setup {
    [self loadUser];

    [self addGestureRecogniser:self.progressChildView];
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

-(void)addGestureRecogniser:(UIView *)touchView{
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(progressViewTapped)];
    [touchView addGestureRecognizer:singleTap];
}

- (void)progressViewTapped {
    [self.delegate beerListsViewControllerDidPushProgressButton:self];
}

- (IBAction)progressButtonPushed:(id)sender {
    [self.delegate beerListsViewControllerDidPushProgressButton:self];
}

- (IBAction)randomButtonPushed:(id)sender {
    [self.delegate beerListsViewControllerDidPushRandomButton:self randomBeer:[self generateRandomBeer]];
}

- (void)sortAllBeersIntoCategories:(NSArray *)allBeers {
    self.beersUnderEight = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beerPrice < %@)", @7]];
    self.beersUnderFivePercent = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beerAbv < %@)", @5]];
    self.allBeersRemaining = [allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = %@)", @NO]];
    self.beersUnderEightRemaining = [self.beersUnderEight filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = %@)", @NO]];
    self.beersUnderFivePercentRemaining = [self.beersUnderFivePercent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"drank = %@", @NO]];

    self.styles = [[BKSDataManager sharedDataManager] allStyles];
    self.stylesRemaining = [self stylesContainedInBeers:self.allBeersRemaining];

    [self reloadAllCollectionViews];
}

- (void)loadUser {
    self.userLoggedIn = [UserObject currentUser];
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
        case BKSBeerCategorySectionStyles: return kBKSBeerStyles; break;
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
    } else if (indexPath.section == BKSBeerCategorySectionStyles) {
        cell.collectionView.tag = BKSBeerCategorySectionStyles;
    }
    [cell.collectionView reloadData];
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
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            numberOfBeersInSection = self.beersUnderEightRemaining.count;
        } else {
            numberOfBeersInSection = self.beersUnderEight.count;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            numberOfBeersInSection = self.beersUnderFivePercentRemaining.count;
        } else {
            numberOfBeersInSection = self.beersUnderFivePercent.count;
        }
    } else if (collectionView.tag == BKSBeerCategorySectionStyles) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            numberOfBeersInSection = self.stylesRemaining.count;
        } else {
            numberOfBeersInSection = self.styles.count;
        }
    }

    return numberOfBeersInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    Beer *beer;
    BeerStyle *style;
    
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((Beer *)[self.allBeersRemaining objectAtIndex:indexPath.row]);
        } else {
            beer = ((Beer *)[self.allBeers objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((Beer *)[self.beersUnderEightRemaining objectAtIndex:indexPath.row]);
        } else {
            beer = ((Beer *)[self.beersUnderEight objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            beer = ((Beer *)[self.beersUnderFivePercentRemaining objectAtIndex:indexPath.row]);
        } else {
            beer = ((Beer *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionStyles) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            style = ((BeerStyle *)[self.stylesRemaining objectAtIndex:indexPath.row]);
        } else {
            style = ((BeerStyle *)[self.styles objectAtIndex:indexPath.row]);
        }
    }

    if (collectionView.tag == BKSBeerCategorySectionStyles) {
        [self configureCell:cell forBeerStyle:style];
    } else {
        [self configureCell:cell forBeer:beer];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == BKSBeerCategorySectionAllBeers) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((Beer *)[self.allBeersRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((Beer *)[self.allBeers objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderEight) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((Beer *)[self.beersUnderEightRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((Beer *)[self.beersUnderEight objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionBeersUnderFivePercent) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((Beer *)[self.beersUnderFivePercentRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((Beer *)[self.beersUnderFivePercent objectAtIndex:indexPath.row]);
        }
    } else if (collectionView.tag == BKSBeerCategorySectionStyles) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.styleSelected = ((BeerStyle *)[self.stylesRemaining objectAtIndex:indexPath.row]);
        } else {
            self.styleSelected = ((BeerStyle *)[self.styles objectAtIndex:indexPath.row]);
        }
    }

    if (collectionView.tag == BKSBeerCategorySectionStyles) {
        [self.delegate beerListsViewControllerDidSelectStyle:self styleSelected:self.styleSelected];
    } else {
        [self.delegate beerListsViewControllerDidSelectBeer:self beerSelected:self.beerSelected];
    }
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

- (Beer *)generateRandomBeer {
    Beer *randomBeer = nil;
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
    [self.delegate beerListsViewControllerDidPressLogout:self];
}

#pragma mark - Helpers

- (void)configureCell:(CollectionCell *)cell forBeerStyle:(BeerStyle *)style {
    [cell.beerImage sd_setImageWithURL:[NSURL URLWithString:style.styleName]];
    cell.beerNameLabel.text =  style.styleName;
}

- (void)configureCell:(CollectionCell *)cell forBeer:(Beer *)beer {
    [cell.beerImage sd_setImageWithURL:[NSURL URLWithString:beer.beerID] placeholderImage:[UIImage imageNamed:@"beer"]];
    cell.beerNameLabel.text =  beer.beerNickname;
}

- (NSArray *)stylesContainedInBeers:(NSArray *)beers {
    NSMutableArray *styleArray = [[NSMutableArray alloc] init];
    for (Beer *beer in beers) {
        if (![styleArray containsObject:beer.beerStyle]) {
            [styleArray addObject:beer.beerStyle];
        }
    }

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"styleName" ascending:YES];
    return [[styleArray copy] sortedArrayUsingDescriptors:@[sort]];
}

@end
