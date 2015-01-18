//
//  Brewery.h
//  Bukowski
//
//  Created by Nicholas Servidio on 1/15/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beer;

@interface Brewery : NSManagedObject

@property (nonatomic, retain) NSString * breweryDescription;
@property (nonatomic, retain) NSString * breweryID;
@property (nonatomic, retain) NSString * breweryName;
@property (nonatomic, retain) NSSet *beersOfBrewery;
@end

@interface Brewery (CoreDataGeneratedAccessors)

- (void)addBeersOfBreweryObject:(Beer *)value;
- (void)removeBeersOfBreweryObject:(Beer *)value;
- (void)addBeersOfBrewery:(NSSet *)values;
- (void)removeBeersOfBrewery:(NSSet *)values;

@end
