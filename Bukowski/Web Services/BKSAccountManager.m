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
#import "NonPersistedBeer.h"

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
                NSLog(@"User with facebook logged in!");
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
                if (error) {
                    NSLog(@"Error starting mug club: %@", error);
                }
            }
        }];
    }
}

- (void)logout
{
    [PFUser logOut];
}

- (BOOL)userStartedMugClub
{
    NSLog(@"%@",[[PFUser currentUser] objectForKey:@"MugClubStartDate"]);
    return ([[PFUser currentUser] objectForKey:@"MugClubStartDate"]!=nil);
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

- (void)loadInitialBeers
{
    PFQuery *query = [PFQuery queryWithClassName:@"NonPersistedBeer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                return;
            } else {
                [self uploadBeers];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)loadBeersWithSuccess:(void(^)(NSArray *beers, NSError *error))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"NonPersistedBeer"];
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


- (void)uploadBeers
{
    [self uploadBostonLager];
    [self uploadDogfish];
    [self uploadGuiness];
    [self uploadNumber9];
    [self uploadMillerLite];
}

- (void)uploadBostonLager
{
    NonPersistedBeer *nonPersistedBeer = [[NonPersistedBeer alloc] init];
    
    nonPersistedBeer.nonPersistedBeerName = @"Boston Lager";
    nonPersistedBeer.nonPersistedBeerStyleName = @"Samuel Adams";
    nonPersistedBeer.nonPersistedBeerBreweryName = @"Lager";
    nonPersistedBeer.nonPersistedBeerDescription = @"Full-flavored with a balance of malty sweetness contrasted by hop spiciness and a smooth finish";
    nonPersistedBeer.nonPersistedBeerPrice = @6;
    nonPersistedBeer.nonPersistedBeerSize = @12;
    nonPersistedBeer.nonPersistedBeerABV = @4.9;
    nonPersistedBeer.nonPersistedBeerNickName = @"Boston Lager";
    
    UIImage *image = [UIImage imageNamed:@"funnyImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"funnyImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            nonPersistedBeer.nonPersistedBeerImage = imageFile;
            [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beer in background");
                    
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

- (void)uploadDogfish
{
    NonPersistedBeer *nonPersistedBeer = [[NonPersistedBeer alloc] init];
    
    nonPersistedBeer.nonPersistedBeerName = @"90 Minute IPA";
    nonPersistedBeer.nonPersistedBeerStyleName = @"Dogfish Head";
    nonPersistedBeer.nonPersistedBeerBreweryName = @"Imperial IPA";
    nonPersistedBeer.nonPersistedBeerDescription = @"An imperial IPA best savored from a snifter, 90 Minute has a great malt backbone that stands up to the extreme hopping rate.";
    nonPersistedBeer.nonPersistedBeerABV = @9;
    nonPersistedBeer.nonPersistedBeerPrice = @9;
    nonPersistedBeer.nonPersistedBeerSize = @12;
    nonPersistedBeer.nonPersistedBeerNickName = @"Dogfish 90";
    
    UIImage *image = [UIImage imageNamed:@"funnyImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"funnyImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            nonPersistedBeer.nonPersistedBeerImage = imageFile;
            [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beer in background");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

- (void)uploadGuiness
{
    NonPersistedBeer *nonPersistedBeer = [[NonPersistedBeer alloc] init];
    
    nonPersistedBeer.nonPersistedBeerName = @"Draught";
    nonPersistedBeer.nonPersistedBeerStyleName = @"Guiness";
    nonPersistedBeer.nonPersistedBeerBreweryName = @"Stout";
    nonPersistedBeer.nonPersistedBeerDescription = @"Super generic Irish stout.";
    nonPersistedBeer.nonPersistedBeerABV = @4.2;
    nonPersistedBeer.nonPersistedBeerPrice = @7;
    nonPersistedBeer.nonPersistedBeerSize = @12;
    nonPersistedBeer.nonPersistedBeerNickName = @"Guiness Draught";
    
    UIImage *image = [UIImage imageNamed:@"funnyImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"funnyImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            nonPersistedBeer.nonPersistedBeerImage = imageFile;
            [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beer in background");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

- (void)uploadNumber9
{
    NonPersistedBeer *nonPersistedBeer = [[NonPersistedBeer alloc] init];
    
    nonPersistedBeer.nonPersistedBeerName = @"#9";
    nonPersistedBeer.nonPersistedBeerStyleName = @"Magic Hat";
    nonPersistedBeer.nonPersistedBeerBreweryName = @"Fruit";
    nonPersistedBeer.nonPersistedBeerDescription = @"A sort of dry, crisp, refreshing, not-quite pale ale. #9 is really impossible to describe because there's never been anything else quite like it";
    nonPersistedBeer.nonPersistedBeerABV = @5.1;
    nonPersistedBeer.nonPersistedBeerPrice = @6.5;
    nonPersistedBeer.nonPersistedBeerSize = @12;
    nonPersistedBeer.nonPersistedBeerNickName = @"Magic Hat #9";
    
    UIImage *image = [UIImage imageNamed:@"funnyImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"funnyImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            nonPersistedBeer.nonPersistedBeerImage = imageFile;
            [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beer in background");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

- (void)uploadMillerLite
{
    NonPersistedBeer *nonPersistedBeer = [[NonPersistedBeer alloc] init];
    
    nonPersistedBeer.nonPersistedBeerName = @"Miller Lite";
    nonPersistedBeer.nonPersistedBeerStyleName = @"Miller";
    nonPersistedBeer.nonPersistedBeerBreweryName = @"Light Lager";
    nonPersistedBeer.nonPersistedBeerDescription = @"The worst of the worst.";
    nonPersistedBeer.nonPersistedBeerABV = @4.17;
    nonPersistedBeer.nonPersistedBeerPrice = @5;
    nonPersistedBeer.nonPersistedBeerSize = @12;
    nonPersistedBeer.nonPersistedBeerNickName = @"Miller Lite";
    
    UIImage *image = [UIImage imageNamed:@"funnyImage"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"funnyImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            nonPersistedBeer.nonPersistedBeerImage = imageFile;
            [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beer in background");
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

@end
