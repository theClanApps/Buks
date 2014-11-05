//
//  BeerObject.h
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BeerObject : NSObject

@property (strong, nonatomic) NSString *beerName;
@property (strong, nonatomic) UIImage *bottleImage;
@property (strong, nonatomic) NSString *brewery;
@property (strong, nonatomic) NSString *beerStyle;
@property (strong, nonatomic) NSString *beerDescription;
@property (strong, nonatomic) NSString *abv;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) UIImage *glassImage;
@property (strong, nonatomic) NSString *nickname;


+(NSArray *)listOfBeers;

@end
