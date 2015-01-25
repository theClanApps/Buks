//
//  BKSDataManager.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import "BKSDataManager.h"
#import <CoreData/CoreData.h>
#import "BeerStyle.h"
#import "BeerObject.h"

#include "Beer+Configure.h"
#include "BeerStyle+Configure.h"

#import "UserBeerObject.h"
#import "BeerObject.h"
#import "BeerStyleObject.h"

#import "UIImageView+WebCache.h"

@implementation BKSDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedDataManager
{
    static BKSDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[BKSDataManager alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Custom Methods

- (void)persistUserBeerObjects:(NSArray *)userBeerObjects {
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        Beer *beer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Beer class])
                                      inManagedObjectContext:self.managedObjectContext];
        [beer configureWithUserBeerObject:userBeerObject];
    }
    [self saveContext];
}

- (void)persistBeerStyleObjects:(NSArray *)beerStyleObjects {
    NSArray *filteredStyles = [self uniqueBeerStyleObjectsFromBeerStyleObjects:beerStyleObjects];
    for (BeerStyleObject *beerStyleObject in filteredStyles) {
        BeerStyle *beerStyle = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BeerStyle class])
                                                             inManagedObjectContext:self.managedObjectContext];
        [beerStyle configureWithBeerStyleObject:beerStyleObject];
    }
    [self saveContext];
}

- (NSArray *)allBeers {
    NSFetchRequest *styleFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Beer class])];

    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:styleFetchRequest
                                                                error:&error];
    return (error) ? nil : results;
}

- (NSArray *)allStyles {
    NSFetchRequest *styleFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BeerStyle class])];
    styleFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"styleName" ascending:YES]];
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:styleFetchRequest
                                                                error:&error];
    return (error) ? nil : results;
}

#pragma mark - Queries

- (BeerStyle *)beerStyleForUserBeerObject:(UserBeerObject *)userBeerObject {
    NSFetchRequest *styleFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BeerStyle class])];
    styleFetchRequest.predicate = [NSPredicate predicateWithFormat:@"styleID == %@",userBeerObject.beer.style.styleID];

    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:styleFetchRequest
                                                                error:&error];
    return results.firstObject;
}

- (NSArray *)beersOfStyle:(BeerStyle *)style {
    NSFetchRequest *beerFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Beer class])];
    beerFetchRequest.predicate = [NSPredicate predicateWithFormat:@"beerStyle == %@", style];

    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:beerFetchRequest
                                                                error:&error];
    return results;
}

- (Beer *)currentBeer:(Beer *)beer {
    NSFetchRequest *beerFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Beer class])];
    beerFetchRequest.predicate = [NSPredicate predicateWithFormat:@"beerID == %@", beer.beerID];

    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:beerFetchRequest
                                                                error:&error];
    return results.firstObject;
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "io.Nick.Bukowski10_20" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Bukowski10_20.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)markBeersDrank:(NSArray *)userBeerObjects {
    NSArray *fetchedBeers = [self fetchBeers:userBeerObjects];
    for (Beer *beer in fetchedBeers) {
        beer.drank = @YES;
    }
    [self saveContext];
}

#pragma mark - Helpers

- (NSArray *)fetchBeers:(NSArray *)userBeerObjects {
    NSMutableArray *fetchedBeers = [[NSMutableArray alloc] init];
    NSFetchRequest *beerFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Beer class])];
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        beerFetchRequest.predicate = [NSPredicate predicateWithFormat:@"beerID == %@", userBeerObject.objectId];
        NSError *error;
        NSArray *results = [self.managedObjectContext executeFetchRequest:beerFetchRequest
                                                                    error:&error];
        if (results.count == 1 && !error) {
            [fetchedBeers addObject:results.firstObject];
        }
    }

    return (userBeerObjects.count == fetchedBeers.count) ? fetchedBeers : nil;
}

- (NSArray *)uniqueBeerStyleObjectsFromBeerStyleObjects:(NSArray *)beerStyleObjects {
    NSMutableArray *styleArray = [[NSMutableArray alloc] init];
    for (BeerStyleObject *style in beerStyleObjects) {
        if (![styleArray containsObject:style]) {
            [styleArray addObject:style];
        }
    }
    return [styleArray copy];
}

@end
