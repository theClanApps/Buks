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
@property (strong, nonatomic) UIImage *beerImage;

+(NSArray *)listOfBeers;

@end
