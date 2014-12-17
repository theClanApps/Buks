//
//  BKSAccountManager.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import <Foundation/Foundation.h>
@class UserBeerObject;

typedef void (^BKSSuccessBlock) (id successObject);
typedef void (^BKSErrorBlock) (NSError *error);

@interface BKSAccountManager : NSObject
+ (id)sharedAccountManager;

- (void)logout;
- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure;
- (void)startMugClubWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure;
- (BOOL)userStartedMugClub;
- (void)loadBeersWithSuccess:(void(^)(NSArray *beers, NSError *error))block;
- (void)rateBeer:(UserBeerObject *)userBeer
        withRating:(float)rating
      WithCompletion:(void(^)(NSError *error, UserBeerObject *userBeer))completion;
@end
