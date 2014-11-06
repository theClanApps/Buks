//
//  PFBeer.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import "NonPersistedBeer.h"

@interface NonPersistedBeer ()
@end

@implementation NonPersistedBeer
@dynamic nonPersistedBeerName,nonPersistedBeerABV,nonPersistedBeerBreweryName, nonPersistedBeerDescription,nonPersistedBeerNickName,nonPersistedBeerPrice,nonPersistedBeerSize,nonPersistedBeerStyleName,nonPersistedBeerImage, userHasDrunk;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"NonPersistedBeer";
}

@end

