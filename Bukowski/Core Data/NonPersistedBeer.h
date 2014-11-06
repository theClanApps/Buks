//
//  PFBeer.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Parse/Parse.h>

@interface NonPersistedBeer : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString *nonPersistedBeerName;
@property (strong, nonatomic) NSString *nonPersistedBeerBreweryName;
@property (strong, nonatomic) NSString *nonPersistedBeerStyleName;
@property (strong, nonatomic) NSString *nonPersistedBeerDescription;
@property (strong, nonatomic) NSNumber *nonPersistedBeerABV;
@property (strong, nonatomic) NSNumber *nonPersistedBeerPrice;
@property (strong, nonatomic) NSNumber *nonPersistedBeerSize;
@property (strong, nonatomic) NSString *nonPersistedBeerNickName;
@property (strong, nonatomic) PFFile *nonPersistedBeerImage;
@property (nonatomic) BOOL userHasDrunk;

+ (NSString *)parseClassName;

@end
