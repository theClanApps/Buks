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
#import "BKSDataManager.h"
#import "Beer.h"
#import "BeerStyleObject.h"
#import "UserBeerObject.h"
#import <SDWebImage/SDWebImageManager.h>

static NSString * const kBKSMugClubStartDate = @"kBKSMugClubStartDate";

@interface BKSAccountManager ()
@property (strong, nonatomic) NSArray *faceBookPermissions;
@property (nonatomic) NSInteger beerImageSaveTally;

@end

@implementation BKSAccountManager

+ (id)sharedAccountManager {
    static BKSAccountManager *_sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountManager = [[BKSAccountManager alloc] init];
    });
    return _sharedAccountManager;
}

- (NSArray *)faceBookPermissions {
    if (_faceBookPermissions == nil) {
        _faceBookPermissions = @[@"public_profile"];
    }
    return _faceBookPermissions;
}

- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure {
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

- (void)configureParseUserObject:(PFUser *)user {
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

- (void)startMugClubWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure {
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

- (void)rateBeer:(Beer *)beer
        withRating:(NSNumber*)rating
      WithCompletion:(void(^)(NSError *error, Beer *userBeer))completion {

    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([UserBeerObject class])];
    [query getObjectInBackgroundWithId:beer.beerID block:^(PFObject *userBeerObject, NSError *error) {
        ((UserBeerObject *)userBeerObject).userRating = rating;
        [userBeerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                if (completion) {
                    beer.beerUserRating = rating;
                    completion(nil, beer);
                }
            } else {
                if (completion) {
                    completion(error, nil);
                }
            }
        }];
    }];
}

#pragma mark - helpers

- (void)storeStartDateInUserDefaults:(NSDate *)date {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kBKSMugClubStartDate] == nil) {
        [userDefaults setObject:date
                         forKey:kBKSMugClubStartDate];
    }
    [userDefaults synchronize];
}

- (BOOL)savedStartDateInUserDefaults {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:kBKSMugClubStartDate] != nil);
}

- (void)loadBeersWithSuccess:(void(^)(NSArray *beers, NSError *error))block {
    NSArray *beers = [[BKSDataManager sharedDataManager] allBeers];
    if (!beers.count > 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"UserBeerObject"];
        [query whereKey:@"drinkingUser" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *userBeerObjects, NSError *error) {
            if (!error) {
                [PFObject fetchAllInBackground:[self beerObjectsFromUserBeerObjects:userBeerObjects] block:^(NSArray *beerObjects, NSError *error) {
                    if (!error) {
                        [PFObject fetchAllInBackground:[self stylesContainedInBeers:beerObjects] block:^(NSArray *styles, NSError *error) {
                            if (!error) {
                                [self saveAllImagesForStyles:styles withCompletion:^{
                                    [self saveAllImagesForBeers:userBeerObjects withCompletion:^{
                                        [[BKSDataManager sharedDataManager] persistBeerStyleObjects:styles];
                                        [[BKSDataManager sharedDataManager] persistUserBeerObjects:userBeerObjects];
                                        if (block) {
                                            block([[BKSDataManager sharedDataManager] allBeers], nil);
                                        }
                                    }];
                                }];
                            } else {
                                NSLog(@"Error: %@", error);
                            }
                        }];
                    } else {
                        NSLog(@"Error: %@", error);
                    }
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    } else {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(beers, nil);
                }
            });
        }
    }
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

- (NSArray *)beerObjectsFromUserBeerObjects:(NSArray *)userBeerObjects {
    NSMutableArray *beerObjects = [[NSMutableArray alloc] init];
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        [beerObjects addObject:userBeerObject.beer];
    }
    return [beerObjects copy];
}

- (NSArray *)stylesContainedInBeers:(NSArray *)beers {
    NSMutableArray *styleArray = [[NSMutableArray alloc] init];
    for (BeerObject *beer in beers) {
        [styleArray addObject:beer.style];
    }
    return [styleArray copy];
}

- (void)saveAllImagesForStyles:(NSArray *)styles withCompletion:(void(^)())completion {
    self.beerImageSaveTally = 0;
    for (BeerStyleObject *beerStyleObject in styles) {
        [beerStyleObject.styleImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", beerStyleObject.styleName]]];
            self.beerImageSaveTally++;
            if (self.beerImageSaveTally == styles.count) {
                if (completion) {
                    completion();
                }
            }
        }];
    }
}

- (void)saveAllImagesForBeers:(NSArray *)beers withCompletion:(void(^)())completion {
    self.beerImageSaveTally = 0;
    for (UserBeerObject *userBeerObject in beers) {
        [userBeerObject.beer.bottleImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", userBeerObject.objectId]]];
            self.beerImageSaveTally++;
            if (self.beerImageSaveTally == beers.count) {
                if (completion) {
                    completion();
                }
            }
        }];
    }
}


@end