//
//  BKSBeersFilteredCollection.h
//  Bukowski
//
//  Created by Nicholas Servidio on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Beer;

@interface BKSBeersFilteredCollection : NSObject

@property (nonatomic, copy) NSString *filterString;

- (instancetype)initWithUnfilteredBeers:(NSArray *)beers;

- (NSUInteger)countOfFilteredBeers;
- (Beer *)filteredBeersAtIndex:(NSUInteger)index;

@end
