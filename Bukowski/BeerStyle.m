//
//  BeerStyle.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/16/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BeerStyle.h"

@implementation BeerStyle
@dynamic styleID, styleName, styleImage;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BeerStyle";
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[BeerStyle class]]) {
        return NO;
    }

    return [self.styleID isEqualToString:((BeerStyle *)object).styleID];
}

@end
