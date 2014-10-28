//
//  PFBeer.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Parse/Parse.h>
#import "Beer.h"
#import "NonPersistedBeerStyle.h"

@interface NonPersistedBeer : PFObject<PFSubclassing>
@property (strong, nonatomic) NSNumber *nonPersistedBeerID;
@property (strong, nonatomic) NSString *nonPersistedBeerName;
@property (strong, nonatomic) NSNumber *nonPersistedBeerAbv;
@property (strong, nonatomic) NonPersistedBeerStyle *nonPersistedBeerStyle;

+ (NSString *)parseClassName;
+ (NonPersistedBeer *)beerWithDatabaseBeer:(Beer *)beer;

@end
