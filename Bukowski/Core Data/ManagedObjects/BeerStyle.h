//
//  BeerStyle.h
//  Bukowski
//
//  Created by Nicholas Servidio on 1/15/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beer;

@interface BeerStyle : NSManagedObject

@property (nonatomic, retain) NSString * styleDescription;
@property (nonatomic, retain) NSString * styleID;
@property (nonatomic, retain) NSString * styleName;
@property (nonatomic, retain) NSSet *beersOfStyle;
@end

@interface BeerStyle (CoreDataGeneratedAccessors)

- (void)addBeersOfStyleObject:(Beer *)value;
- (void)removeBeersOfStyleObject:(Beer *)value;
- (void)addBeersOfStyle:(NSSet *)values;
- (void)removeBeersOfStyle:(NSSet *)values;

@end
