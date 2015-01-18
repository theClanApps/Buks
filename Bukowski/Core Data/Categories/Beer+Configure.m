//
//  Beer+Configure.m
//  Bukowski
//
//  Created by Nicholas Servidio on 1/12/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "Beer+Configure.h"
#import "BKSDataManager.h"
#import "UserBeerObject.h"

@implementation Beer (Configure)

- (void)configureWithUserBeerObject:(UserBeerObject *)userBeerObject {
    self.beerAbv = userBeerObject.beer.beerAbv;
    self.beerDescription = userBeerObject.beer.beerDescription;
    self.beerID = userBeerObject.objectId;
    self.beerName = userBeerObject.beer.beerName;
    self.beerNickname = userBeerObject.beer.beerNickname;
    self.beerPrice = userBeerObject.beer.beerPrice;
    self.beerSize = userBeerObject.beer.beerPrice;
    self.drank = userBeerObject.drank;

    self.beerStyle = [[BKSDataManager sharedDataManager] beerStyleForUserBeerObject:userBeerObject];
}

@end
