//
//  BKSStyleViewController.m
//  Bukowski
//
//  Created by Nicholas Servidio on 12/20/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSStyleViewController.h"
#import "BeerStyle.h"
#import "Beer.h"
#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
#import "UserBeerObject.h"
#import "BKSBeerDetailViewController.h"
#import "BKSBeerListsViewController.h"
#import "NoItemsRemainingCell.h"

NSString * const kBKSBeerDetailSegueFromStyle = @"kBKSBeerDetailSegue";

@interface BKSStyleViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *styleCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *aboutStyleTextView;
@property (strong, nonatomic) NSArray *beersOfStyleRemaining;
@property (weak, nonatomic) IBOutlet UISwitch *toggleAllOrRemainingSwitch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) Beer *beerSelected;
@property (nonatomic) BOOL noItemsRemaining;

@end

@implementation BKSStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToggleValue];
}

- (void)setup {
    self.styleNameLabel.text = self.style.styleName;

    [self setupFlowLayout];

    self.aboutStyleTextView.text = self.style.styleDescription;
    
    self.beersOfStyleRemaining = [self.beersOfStyle filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
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


- (void)setupFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.styleCollectionView registerNib:[UINib nibWithNibName:@"NoItemsRemainingCell" bundle:nil] forCellWithReuseIdentifier:@"NoItemsRemainingCell"];
    [self.styleCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
    self.styleCollectionView.collectionViewLayout = flowLayout;
    self.styleCollectionView.backgroundColor = [UIColor clearColor];
}

- (IBAction)toggledSwitch:(id)sender {
    //Save toggle setting for that user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:self.toggleAllOrRemainingSwitch.on] forKey:kBKSUserToggleSetting];
    [defaults synchronize];
    self.noItemsRemaining = nil;
    [self.collectionView reloadData];
}

#pragma mark - CollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    Beer *beer;
    
    if (self.toggleAllOrRemainingSwitch.isOn) {
        if (self.noItemsRemaining) {
            UICollectionViewCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoItemsRemainingCell" forIndexPath:indexPath];
            return emptyCell;
        } else {
            beer = ((Beer *)[self.beersOfStyleRemaining objectAtIndex:indexPath.row]);
        }
    } else {
        beer = ((Beer *)[self.beersOfStyle objectAtIndex:indexPath.row]);
    }
    
    [self configureCell:cell forBeer:beer];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItemsToReturn;
    
    if (self.toggleAllOrRemainingSwitch.isOn) {
        numberOfItemsToReturn = self.beersOfStyleRemaining.count;
    } else {
        numberOfItemsToReturn = self.beersOfStyle.count;
    }
    
    if (!numberOfItemsToReturn) {
        self.noItemsRemaining = YES;
        numberOfItemsToReturn = 1;
    }
    
    return numberOfItemsToReturn;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.noItemsRemaining) {
        return CGSizeMake(self.collectionView.bounds.size.width, 182);
    } else {
        return CGSizeMake(112, 182);
    }
}

- (void)configureCell:(CollectionCell *)cell forBeer:(Beer *)beer {
    [cell.beerImage sd_setImageWithURL:[NSURL URLWithString:beer.beerID]];
    cell.beerNameLabel.text =  beer.beerNickname;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.noItemsRemaining) {
        if (self.toggleAllOrRemainingSwitch.isOn) {
            self.beerSelected = ((Beer *)[self.beersOfStyleRemaining objectAtIndex:indexPath.row]);
        } else {
            self.beerSelected = ((Beer *)[self.beersOfStyle objectAtIndex:indexPath.row]);
        }
        [self performSegueWithIdentifier:kBKSBeerDetailSegueFromStyle sender:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kBKSBeerDetailSegueFromStyle]) {
        BKSBeerDetailViewController *detailVC = (BKSBeerDetailViewController *)segue.destinationViewController;
        detailVC.beer = self.beerSelected;
        detailVC.allBeers = self.allBeers;
    }
}

@end
