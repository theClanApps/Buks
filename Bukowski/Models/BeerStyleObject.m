//
//  BeerStyle.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/16/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BeerStyleObject.h"

@implementation BeerStyleObject
@dynamic styleID, styleName, styleImage, styleDescription;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BeerStyleObject";
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[BeerStyleObject class]]) {
        return NO;
    }

    return [self.styleID isEqualToString:((BeerStyleObject *)object).styleID];
}

@end
