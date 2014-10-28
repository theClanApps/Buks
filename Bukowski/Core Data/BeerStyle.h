//
//  Style.h
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/20/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beer;

@interface BeerStyle : NSManagedObject

@property (nonatomic, retain) NSNumber * styleID;
@property (nonatomic, retain) NSString * styleName;
@property (nonatomic, retain) NSString * styleDescription;
@property (nonatomic, retain) NSSet *beersOfStyle;
@end

@interface BeerStyle (CoreDataGeneratedAccessors)

- (void)addBeersOfStyleObject:(Beer *)value;
- (void)removeBeersOfStyleObject:(Beer *)value;
- (void)addBeersOfStyle:(NSSet *)values;
- (void)removeBeersOfStyle:(NSSet *)values;

@end
