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

@interface BKSBeerDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *breweryLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abvLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImage;
@property (weak, nonatomic) IBOutlet UITextView *beerDescriptionTextView;


@end

@implementation BKSBeerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BeerObject *beer = self.beer.beer;
    self.beerNameLabel.text = beer.beerName.uppercaseString;
    self.breweryLabel.text = beer.brewery.uppercaseString;
    self.beerStyleLabel.text = beer.beerStyle.uppercaseString;
    self.beerDescriptionTextView.text = beer.beerDescription;
    self.abvLabel.text = [NSString stringWithFormat:@"%@ %%",beer.abv];
    self.priceLabel.text = beer.price;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ oz.",beer.size];
    [self.rateButton setTitle:@"Rate" forState:UIControlStateNormal];
    
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
//    if ([self.beer.drank isEqualToNumber:0]) {
//        NSLog(@"Beer is not drank");
//        self.rateButton.enabled = NO;
//        self.rateView.editable = NO;
//    } else {
//        NSLog(@"Beer is drank");
//        NSLog(@"%@",self.beer.drank);
//        self.rateButton.enabled = YES;
//        self.rateView.editable = YES;
//    }
    
    self.rateView.rating = self.beer.userRating;
    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"unshadedstar"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"shadedstar"];
    self.rateView.greyImage = [UIImage imageNamed:@"greystar"];
    self.rateView.editable = YES;
    self.rateView.numberOfStars = 5;
    self.rateView.delegate = self;
}

- (void)rateView:(BKSRateView *)rateView ratingDidChange:(float)rating {
    
}

- (IBAction)rateButtonPressed:(id)sender {
    if ([self.rateButton.currentTitle isEqualToString:@"Rate"]) {
        [self.rateButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    if ([self.rateButton.currentTitle isEqualToString:@"Save"]) {
        [self.rateButton setTitle:@"Rate" forState:UIControlStateNormal];

    }
}


@end
