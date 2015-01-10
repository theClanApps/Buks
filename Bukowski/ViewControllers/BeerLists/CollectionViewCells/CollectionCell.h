//
//  CollectionCell.h
//  CollectionViewTut
//
//  Created by Ezra on 10/26/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *beerImage;
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;


@end
