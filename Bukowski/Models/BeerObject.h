//
//  BeerObject.h
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <Parse/Parse.h>
@class BeerStyleObject;

@interface BeerObject : PFObject <PFSubclassing>

@property (strong, nonatomic) NSNumber *beerAbv;
@property (strong, nonatomic) NSString *beerDescription;
@property (strong, nonatomic) NSString *beerName;
@property (strong, nonatomic) NSString *beerNickname;
@property (strong, nonatomic) NSNumber *beerPrice;
@property (strong, nonatomic) NSNumber *beerSize;
@property (strong, nonatomic) NSString *brewery;
@property (strong, nonatomic) PFFile *bottleImage;
@property (strong, nonatomic) PFFile *glassImage;
@property (strong, nonatomic) BeerStyleObject *style;

+ (NSString *)parseClassName;

@end
