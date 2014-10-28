//
//  Beer.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Brewery, BeerStyle;

@interface Beer : NSManagedObject

@property (nonatomic, retain) NSNumber * beerAbv;
@property (nonatomic, retain) NSNumber * beerID;
@property (nonatomic, retain) NSString * beerName;
@property (nonatomic, retain) Brewery *brewery;
@property (nonatomic, retain) BeerStyle *style;

@end
