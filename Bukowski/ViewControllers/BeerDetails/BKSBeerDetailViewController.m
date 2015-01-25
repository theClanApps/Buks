//
//  BKSBeerDetailViewController.m
//  Bukowski
//
//  Created by Ezra on 11/5/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSBeerDetailViewController.h"
#import "BKSAccountManager.h"
#import "BKSStyleViewController.h"
#import "UIImageView+WebCache.h"
#import "Beer.h"
#import "BeerStyle.h"
#import "BKSDataManager.h"

@interface BKSBeerDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *breweryLabel;
@property (weak, nonatomic) IBOutlet UIButton *beerStyleButton;
@property (weak, nonatomic) IBOutlet UILabel *abvLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImage;
@property (weak, nonatomic) IBOutlet UITextView *beerDescriptionTextView;
@property (weak, nonatomic) IBOutlet BKSRateView *rateView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rateBarButton;

@property (nonatomic) BOOL isRating;

@end

@implementation BKSBeerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self registerForMarkedDrankNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setup];
}

- (void)setup {
    self.beer = [[BKSDataManager sharedDataManager] currentBeer:self.beer];
    [self configureForBeer];
    [self setupRateView];
}

- (void)configureForBeer {
    Beer * beer = self.beer;
    self.beerNameLabel.text = beer.beerName.uppercaseString;
    [self.beerStyleButton setTitle:beer.beerStyle.styleName.uppercaseString forState:UIControlStateNormal];
    self.beerDescriptionTextView.text = beer.beerDescription;
    self.abvLabel.text = [NSString stringWithFormat:@"%@ %%",beer.beerAbv];
    self.priceLabel.text = [NSString stringWithFormat:@"%@", beer.beerPrice];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ oz.",beer.beerSize];
    self.isRating = NO;

    [self.bottleImage sd_setImageWithURL:[NSURL URLWithString:beer.beerID]];
}

- (void)setupRateView {
    if ([self.beer.drank intValue] == 0) {
        self.rateBarButton.enabled = NO;
        self.rateBarButton.title = @"";
        self.rateView.hidden = YES;
    } else {
        self.rateBarButton.enabled = YES;
        self.rateBarButton.title = @"Rate";
        self.rateView.hidden = NO;
    }
    self.rateView.editable = NO;
    self.rateView.rating = self.beer.beerUserRating;
    self.rateView.notSelectedImage = [UIImage imageNamed:@"unshadedstar"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"shadedstar"];
    self.rateView.greyImage = [UIImage imageNamed:@"greystar"];
    self.rateView.numberOfStars = 5;
    self.rateView.delegate = self;
}

- (IBAction)rateBarButtonPressed:(id)sender {
    
    if (!self.isRating) {
        self.isRating = YES;
        self.rateView.editable = YES;
        [self.rateBarButton setTitle:@"Save"];
    } else {
        self.isRating = NO;
        [[BKSAccountManager sharedAccountManager] rateBeer:self.beer withRating:self.rateView.rating WithCompletion:^(NSError *error, Beer *beer) {
            if (!error) {
                // DO NOTHING
            } else {
                NSLog(@"Error checking beer: %@", error);
            }
        }];
        
        [self.rateBarButton setTitle:@"Rate"];
        self.rateView.editable = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToStyleFromBeerSegue"]) {
        BKSStyleViewController *styleVC = (BKSStyleViewController *)segue.destinationViewController;
        styleVC.style = self.beer.beerStyle;
    }
}

#pragma mark - Notifications

- (void)registerForMarkedDrankNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setup)
                                                 name:kBKSBeersNeedUpdateNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
