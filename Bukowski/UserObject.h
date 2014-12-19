//
//  UserObject.h
//  Bukowski
//
//  Created by Ezra on 12/19/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserObject : PFUser <PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *mugClubStartDate;
@property (strong, nonatomic) NSDate *mugClubEndDate;

@property (strong, nonatomic) PFFile *userImage;
@property (strong, nonatomic) NSDate *dateOfLastBeerDrank;

+ (NSString *)parseClassName;

@end