//
//  Beer+Configure.h
//  Bukowski
//
//  Created by Nicholas Servidio on 1/12/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "Beer.h"
@class UserBeerObject;

@interface Beer (Configure)

- (void)configureWithUserBeerObject:(UserBeerObject *)userBeerObject;

@end
