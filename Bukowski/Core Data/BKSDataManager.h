//
//  BKSDataManager.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BKSDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedDataManager;

// Stock methods
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
