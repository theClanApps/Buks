//
//  PFBeerStyle.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import "NonPersistedBeerStyle.h"

@interface NonPersistedBeerStyle ()
@end

@implementation NonPersistedBeerStyle
@dynamic nonPersistedStyleName,nonPersistedStyleDescription,nonPersistedStyleID,nonPersistedBeersOfStyle;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"NonPersistedBeerStyle";
}

+ (NonPersistedBeerStyle *)beerStyleWithDatabaseBeerStyle:(BeerStyle *)beerStyle
{
    NonPersistedBeerStyle *nonPersistedBeerStyle = [NonPersistedBeerStyle object];
    nonPersistedBeerStyle.nonPersistedStyleID = beerStyle.styleID;
    nonPersistedBeerStyle.nonPersistedStyleName = beerStyle.styleName;
    nonPersistedBeerStyle.nonPersistedStyleDescription = beerStyle.styleDescription;
    
    return nonPersistedBeerStyle;
}

@end
