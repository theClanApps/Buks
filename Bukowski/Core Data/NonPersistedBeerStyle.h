//
//  PFBeerStyle.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Parse/Parse.h>
#import "BeerStyle.h"

@interface NonPersistedBeerStyle : PFObject<PFSubclassing>
@property (nonatomic, retain) NSNumber * nonPersistedStyleID;
@property (nonatomic, retain) NSString * nonPersistedStyleName;
@property (nonatomic, retain) NSString * nonPersistedStyleDescription;
@property (nonatomic, retain) NSSet *nonPersistedBeersOfStyle;

+ (NSString *)parseClassName;
+ (NonPersistedBeerStyle *)beerStyleWithDatabaseBeerStyle:(BeerStyle *)beerStyle;

@end
