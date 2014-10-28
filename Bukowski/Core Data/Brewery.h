//
//  Brewery.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beer;

@interface Brewery : NSManagedObject

@property (nonatomic, retain) NSNumber * breweryID;
@property (nonatomic, retain) NSString * breweryName;
@property (nonatomic, retain) NSString * breweryDescription;
@property (nonatomic, retain) NSSet *beersOfBrewery;
@end

@interface Brewery (CoreDataGeneratedAccessors)

- (void)addBeersOfBreweryObject:(Beer *)value;
- (void)removeBeersOfBreweryObject:(Beer *)value;
- (void)addBeersOfBrewery:(NSSet *)values;
- (void)removeBeersOfBrewery:(NSSet *)values;

@end
