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
@dynamic nonPersistedBeerID,nonPersistedBeerName,nonPersistedBeerAbv, nonPersistedBeerStyle;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"NonPersistedBeer";
}

+ (NonPersistedBeer *)beerWithDatabaseBeer:(Beer *)beer
{
    NonPersistedBeer *nonPersistedBeer = [NonPersistedBeer object];
    nonPersistedBeer.nonPersistedBeerName = beer.beerName;
    nonPersistedBeer.nonPersistedBeerID = beer.beerID;
    nonPersistedBeer.nonPersistedBeerAbv = beer.beerAbv;

    return nonPersistedBeer;
}

@end

