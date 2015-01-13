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

    self.aboutStyleTextView.text = self.style.styleDescription;
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

    [self configureCell:cell forBeer:(Beer *)self.beersOfStyle[indexPath.row]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.beersOfStyle.count;
}

- (void)configureCell:(CollectionCell *)cell forBeer:(Beer *)beer {
    [cell.beerImage sd_setImageWithURL:[NSURL URLWithString:beer.beerID]];
    cell.beerNameLabel.text =  beer.beerNickname;
}

@end
