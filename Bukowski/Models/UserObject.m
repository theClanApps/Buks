//
//  UserObject.m
//  Bukowski
//
//  Created by Ezra on 12/19/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

@dynamic name, MugClubStartDate, mugClubEndDate, userImage, dateOfLastBeerDrank;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"_User";
}

@end
