//
//  BeerStyle.h
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/16/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>

@interface BeerStyle : PFObject <PFSubclassing>
@property (strong, nonatomic) NSString *styleID;
@property (strong, nonatomic) NSString *styleName;
@property (strong, nonatomic) NSString *styleDescription;
@property (strong, nonatomic) PFFile *styleImage;

@end
