//
//  BKSBeerDetailViewController.m
//  Bukowski
//
//  Created by Ezra on 11/5/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSBeerDetailViewController.h"
#import "UserBeerObject.h"
#import "BeerObject.h"
#import "BKSAccountManager.h"
#import "BeerStyle.h"
#import "BKSStyleViewController.h"

@interface BKSBeerDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *breweryLabel;
@property (weak, nonatomic) IBOutlet UIButton *beerStyleButton;
@property (weak, nonatomic) IBOutlet UILabel *abvLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImage;
@property (weak, nonatomic) IBOutlet UITextView *beerDescriptionTextView;
@property (nonatomic) BOOL isRating;

@end

@implementation BKSBeerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BeerObject *beer = self.beer.beer;
    self.beerNameLabel.text = beer.beerName.uppercaseString;
    self.breweryLabel.text = beer.brewery.uppercaseString;
    [self.beerStyleButton setTitle:beer.style.styleName.uppercaseString forState:UIControlStateNormal];
    self.beerDescriptionTextView.text = beer.beerDescription;
    self.abvLabel.text = [NSString stringWithFormat:@"%@ %%",beer.abv];
    self.priceLabel.text = beer.price;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ oz.",beer.size];
    self.isRating = NO;
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        PFFile *theImage = beer.bottleImage;
        NSData *imageData = [theImage getData];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.bottleImage.image = image;
                });
            }
        }
    });
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupRateView];
}

- (void)setupRateView {
    if ([self.beer.drank intValue] == 0) {
        self.rateBarButton.enabled = NO;
        self.rateBarButton.title = @"";
        self.rateView.hidden = YES;
    } else {
        self.rateBarButton.enabled = YES;
        self.rateBarButton.title = @"Rate";
    }
    self.rateView.editable = NO;
    self.rateView.rating = self.beer.userRating;
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
        [[BKSAccountManager sharedAccountManager] rateBeer:self.beer withRating:self.rateView.rating WithCompletion:^(NSError *error, UserBeerObject *userBeer) {
            if (!error) {
                //NSLog(@"Success!");
            } else {
                NSLog(@"Error checking beer: %@", error);
            }
        }];
        
        [self.rateBarButton setTitle:@"Rate"];
        self.rateView.editable = NO;
    }
}

- (NSArray *)beerObjectsFromStyle:(BeerStyle *)style {
    NSArray *beers = [self.allBeers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(beer.style == %@)", style]];
    return beers;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToStyleFromBeerSegue"]) {
        BKSStyleViewController *detailVC = (BKSStyleViewController *)segue.destinationViewController;
        detailVC.beersOfStyle = [self beerObjectsFromStyle:self.beer.beer.style];
        detailVC.style = self.beer.beer.style;
    }

}

@end
