//
//  UserBeerObject.h
//  BukowskiManagerApp
//
//  Created by Ezra on 11/18/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>
#import "BeerObject.h"

@interface UserBeerObject : PFObject <PFSubclassing>

@property (strong, nonatomic) PFUser *drinkingUser;
@property (strong, nonatomic) BeerObject *beer;
@property (strong, nonatomic) NSNumber *userRating;
@property (strong, nonatomic) NSNumber *drank;
@property (strong, nonatomic) NSDate *dateDrank;
@property (strong, nonatomic) PFUser *checkingEmployee;
@property (strong, nonatomic) NSString *checkingEmployeeComments;
@property (strong, nonatomic) NSNumber *pendingUpdatesToUserDevice;

+ (NSString *)parseClassName;

@end
