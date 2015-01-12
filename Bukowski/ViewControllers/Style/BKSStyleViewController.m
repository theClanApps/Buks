//
//  BKSStyleViewController.m
//  Bukowski
//
//  Created by Nicholas Servidio on 12/20/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSStyleViewController.h"
#import "BeerStyle.h"
#import "BeerObject.h"
#import "CollectionCell.h"
#import "UserBeerObject.h"

@interface BKSStyleViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *styleCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *aboutStyleTextView;
@property (strong, nonatomic) NSArray *beersOfStyleRemaining;
@property (weak, nonatomic) IBOutlet UISwitch *toggleAllOrRemainingSwitch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BKSStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.styleNameLabel.text = self.style.styleName;

    [self setupFlowLayout];

    self.aboutStyleTextView.text = self.style.styleDescription;
    
    self.beersOfStyleRemaining = [self.beersOfStyle filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(drank = false)"]];
}

- (void)setupFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(112, 182)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.styleCollectionView.collectionViewLayout = flowLayout;
    self.styleCollectionView.backgroundColor = [UIColor clearColor];
    [self.styleCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    
    BeerObject *beer;
    
    if (self.toggleAllOrRemainingSwitch.isOn) {
        beer = ((UserBeerObject *)[self.beersOfStyleRemaining objectAtIndex:indexPath.row]).beer;
    } else {
        beer = ((UserBeerObject *)[self.beersOfStyle objectAtIndex:indexPath.row]).beer;
    }
    
    [self configureCell:cell forBeer:beer];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (self.toggleAllOrRemainingSwitch.isOn) {
        return self.beersOfStyleRemaining.count;
    } else {
        return self.beersOfStyle.count;
    }
}

- (void)configureCell:(CollectionCell *)cell forBeer:(BeerObject *)beer {
    if (beer.bottleImage) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            PFFile *theImage = beer.bottleImage;
            NSData *imageData = [theImage getData];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.beerImage.image = image;
                        cell.beerNameLabel.text =  beer.nickname;
                    });
                }
            }
        });
    }
}

- (IBAction)toggledSwitch:(id)sender {
    [self.collectionView reloadData];
}

@end
