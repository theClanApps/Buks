//
//  BeerStyle+Configure.m
//  Bukowski
//
//  Created by Nicholas Servidio on 1/15/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BeerStyle+Configure.h"
#import "BeerStyleObject.h"

@implementation BeerStyle (Configure)

- (void)configureWithBeerStyleObject:(BeerStyleObject *)beerStyleObject {
    self.styleDescription = beerStyleObject.styleDescription;
    self.styleID = beerStyleObject.styleID;
    self.styleName = beerStyleObject.styleName;
}

@end
