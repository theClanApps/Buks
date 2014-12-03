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
    
    PFFile *theImage = beer.bottleImage;
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.bottleImage.image = image;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

@end
