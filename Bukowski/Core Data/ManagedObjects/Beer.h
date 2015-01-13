//
//  Beer.h
//  Bukowski
//
//  Created by Nicholas Servidio on 1/17/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeerStyle, Brewery;

@interface Beer : NSManagedObject

@property (nonatomic, retain) NSNumber * beerAbv;
@property (nonatomic, retain) NSString * beerDescription;
@property (nonatomic, retain) NSString * beerID;
@property (nonatomic, retain) NSString * beerName;
@property (nonatomic, retain) NSString * beerNickname;
@property (nonatomic, retain) NSNumber * beerPrice;
@property (nonatomic, retain) NSNumber * beerSize;
@property (nonatomic, retain) NSNumber * beerUserRating;
@property (nonatomic, retain) NSNumber * drank;
@property (nonatomic, retain) BeerStyle *beerStyle;
@property (nonatomic, retain) Brewery *brewery;

@end
