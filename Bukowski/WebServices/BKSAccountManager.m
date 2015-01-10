//
//  BKSAccountManager.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import "BKSAccountManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserBeerObject.h"

static NSString * const kBKSMugClubStartDate = @"kBKSMugClubStartDate";

@interface BKSAccountManager ()
@property (strong, nonatomic) NSArray *faceBookPermissions;

@end

@implementation BKSAccountManager

+ (id)sharedAccountManager
{
    static BKSAccountManager *_sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountManager = [[BKSAccountManager alloc] init];
    });
    return _sharedAccountManager;
}

- (NSArray *)faceBookPermissions
{
    if (_faceBookPermissions == nil) {
        _faceBookPermissions = @[@"public_profile"];
    }
    return _faceBookPermissions;
}

- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure
{
    [PFFacebookUtils logInWithPermissions:self.faceBookPermissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"User cancelled FB Login");
            } else {
                NSLog(@"Error: %@",error);
                if (failure) {
                    failure(error);
                }
            }
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                [self configureParseUserObject:user];
            } else {
                // DO NOTHING
            }
            if (success) {
                success(user);
            }
        }
    }];
}

- (void)configureParseUserObject:(PFUser *)user
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            user[@"name"] = [userData objectForKey:@"name"];
            user[@"profilePictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",[userData objectForKey:@"id"]];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Added name to user object");
                } else {
                    NSLog(@"Error saving name to user object: %@",error);
                }
            }];
        }
    }];
}

- (void)startMugClubWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure
{
    if (![self savedStartDateInUserDefaults]) {
        [self createUsersBeersInCloudWithCompletion:^(NSError *error, NSString *result) {
            PFUser *currentUser = [PFUser currentUser];
            NSDate * currentDate = [NSDate date];
            currentUser[@"MugClubStartDate"] = currentDate;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self storeStartDateInUserDefaults:currentDate];
                    if (success) {
                        success([NSNumber numberWithBool:succeeded]);
                    }
                } else {
                    if (failure) {
                        failure(error);
                    }
                }
            }];
        }];
    }
}

- (void)logout {
    [PFUser logOut];
}

- (BOOL)userStartedMugClub {
    return ([[PFUser currentUser] objectForKey:@"MugClubStartDate"]!=nil);
}

- (void)rateBeer:(UserBeerObject *)userBeer
        withRating:(NSNumber*)rating
      WithCompletion:(void(^)(NSError *error, UserBeerObject *userBeer))completion {
    userBeer.userRating = rating;
    
    [userBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (completion) {
                completion(nil, userBeer);
            }
        } else {
            if (completion) {
                completion(error, nil);
            }
        }
    }];
}

#pragma mark - helpers

- (void)storeStartDateInUserDefaults:(NSDate *)date
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kBKSMugClubStartDate] == nil) {
        [userDefaults setObject:date
                         forKey:kBKSMugClubStartDate];
    }
    [userDefaults synchronize];
}

- (BOOL)savedStartDateInUserDefaults
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kBKSMugClubStartDate] != nil);
}

- (void)loadBeersWithSuccess:(void(^)(NSArray *beers, NSError *error))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserBeerObject"];
    [query whereKey:@"drinkingUser" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (block) {
                block(objects, nil);
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)createUsersBeersInCloudWithCompletion:(void(^)(NSError *error, NSString *result))completion {
    [PFCloud callFunctionInBackground:@"createUserBeerInCloud"
                       withParameters:@{
                                        @"user" : [PFUser currentUser].username,
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        if (completion) {
                                            completion(nil, result);
                                        }
                                    } else {
                                        if (completion) {
                                            completion(error, nil);
                                        }
                                    }
                                }];
}

@end
