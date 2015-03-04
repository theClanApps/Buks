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
@property (strong, nonatomic) NSDate *dateOfLastBeerDrank;
@property (strong, nonatomic) NSNumber *ranOutOfTime;
@property (strong, nonatomic) NSNumber *finishedMugClub;

@property (strong, nonatomic) PFFile *userImage;

+ (NSString *)parseClassName;

@end
