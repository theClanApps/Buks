//
//  BKSDataManager.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Beer;
@class BeerStyle;
@class UserBeerObject;

@interface BKSDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedDataManager;

// Stock methods
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// Custom methods
- (void)persistUserBeerObjects:(NSArray *)userBeerObjects;
- (void)persistBeerStyleObjects:(NSArray *)beerStyleObjects;

- (Beer *)currentBeer:(Beer *)beer;
- (BeerStyle *)beerStyleForUserBeerObject:(UserBeerObject *)userBeerObject;
- (NSArray *)allBeers;
- (NSArray *)allStyles;
- (NSArray *)beersOfStyle:(BeerStyle *)style;

- (void)markBeersDrank:(NSArray *)userBeerObjects;

@end
