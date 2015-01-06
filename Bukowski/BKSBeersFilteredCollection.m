//
//  BKSBeersFilteredCollection.m
//  Bukowski
//
//  Created by Nicholas Servidio on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSBeersFilteredCollection.h"
#import "UserBeerObject.h"

@interface BKSBeersFilteredCollection ()

@property (nonatomic, copy) NSArray *unfilteredBeers;
@property (nonatomic, strong) NSArray *filteredBeers;

@end

@implementation BKSBeersFilteredCollection

- (void)setUnfilteredBeers:(NSArray *)unfilteredBeers {
    _unfilteredBeers = [unfilteredBeers copy];
    [self refreshFilteredConnections];
}

- (void)setFilterString:(NSString *)filterString {
    _filterString = [filterString copy];
    [self refreshFilteredConnections];
}

- (void)refreshFilteredConnections {
    if ([self.filterString isEqual:@""]) {
        self.filteredBeers = [self.unfilteredBeers copy];
    } else {
        self.filteredBeers = [self.unfilteredBeers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            UserBeerObject *beer = (UserBeerObject *)evaluatedObject;

            if ([beer.beer.beerName rangeOfString:self.filterString options:NSCaseInsensitiveSearch].location == NSNotFound) {
                if ([beer.beer.nickname rangeOfString:self.filterString options:NSCaseInsensitiveSearch].location == NSNotFound) {
                    if ([beer.beer.brewery rangeOfString:self.filterString options:NSCaseInsensitiveSearch].location == NSNotFound) {
                        return NO;
                    }
                }
            }

            return YES;
        }]];
    }
}

- (instancetype)initWithUnfilteredBeers:(NSArray *)beers {
    self = [super init];
    if (self) {
        _unfilteredBeers = [beers copy];
        _filterString = @"";

        [self refreshFilteredConnections];
    }
    return self;
}

- (NSUInteger)countOfFilteredBeers {
    return self.filteredBeers.count;
}

- (UserBeerObject *)filteredBeersAtIndex:(NSUInteger)index {
    return self.filteredBeers[index];
}

@end
