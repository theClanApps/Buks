//
//  BKSBeerDetailViewController.m
//  Bukowski
//
//  Created by Ezra on 11/5/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSBeerDetailViewController.h"

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
    
    self.beerNameLabel.text = self.beer.beerName.uppercaseString;
    self.breweryLabel.text = self.beer.brewery.uppercaseString;
    self.beerStyleLabel.text = self.beer.beerStyle.uppercaseString;
    self.beerDescriptionTextView.text = self.beer.beerDescription;
    self.abvLabel.text = [NSString stringWithFormat:@"%@ %%",self.beer.abv];
    self.priceLabel.text = self.beer.price;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ oz.",self.beer.size];
    
    PFFile *theImage = self.beer.bottleImage;
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    self.bottleImage.image = image;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

@end
