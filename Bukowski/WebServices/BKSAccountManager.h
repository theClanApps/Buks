//
//  BKSAccountManager.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import <Foundation/Foundation.h>
@class Beer;

typedef void (^BKSSuccessBlock) (id successObject);
typedef void (^BKSErrorBlock) (NSError *error);

extern NSString * const kBKSBeersNeedUpdateNotification;

@interface BKSAccountManager : NSObject
+ (id)sharedAccountManager;

- (void)logout;
- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure;
- (void)startMugClubWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure;
- (void)loadBeersWithSuccess:(void(^)(NSArray *beers, NSError *error))block;
- (void)rateBeer:(Beer *)beer
        withRating:(NSNumber*)rating
      WithCompletion:(void(^)(NSError *error, Beer *userBeer))completion;
- (void)updateBeersThatHaveBeenDrunkWithCompletion:(void(^)(NSError *error, BOOL beersNeedUpdate))completion;
- (void)startCheckingForBeerUpdates;
- (void)stopCheckingForBeerUpdates;

- (BOOL)userStartedMugClub;
- (BOOL)userIsLoggedIn;

- (void)postBeersMarkDrankNotification;

@end
