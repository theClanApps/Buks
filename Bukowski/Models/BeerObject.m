//
//  BeerObject.m
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BeerObject.h"

@implementation BeerObject
@dynamic beerName, brewery, beerDescription, beerAbv, beerPrice, beerSize, beerNickname, bottleImage, glassImage, style;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BeerObject";
}

@end
