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

@end

@implementation BKSStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.styleNameLabel.text = self.style.styleName;

    [self setupFlowLayout];
}

- (void)setupFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(112, 182)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.styleCollectionView.collectionViewLayout = flowLayout;
    //self.styleCollectionView.backgroundColor = [UIColor clearColor];
    [self.styleCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"cvCell"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];

    [self configureCell:cell forBeer:((UserBeerObject *)self.beersOfStyle[indexPath.row]).beer];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.beersOfStyle.count;
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

@end
