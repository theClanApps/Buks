//
//  UserBeerObject.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/18/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "UserBeerObject.h"
#import <Parse/PFObject+Subclass.h>

@implementation UserBeerObject
@dynamic drinkingUser, beer, drank, dateDrank, checkingEmployee, checkingEmployeeComments;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"UserBeerObject";
}

@end
