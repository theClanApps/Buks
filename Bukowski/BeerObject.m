//
//  BeerObject.m
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import "BeerObject.h"

@implementation BeerObject

+(NSArray *)listOfBeers
{
    //Beer *beer = [[Beer alloc] init];
    BeerObject *beer1 = [BeerObject new];
    
    beer1.beerImage = [UIImage imageNamed:@"bluemoonwhite.jpg"];
    beer1.beerName = @"BLUE MOON";
    
    BeerObject *beer2 = [BeerObject new];
    
    beer2.beerImage = [UIImage imageNamed:@"bostonlager"];
    beer2.beerName = @"BOSTON LAGERq";
    
    BeerObject *beer3 = [BeerObject new];
    
    beer3.beerImage = [UIImage imageNamed:@"dogfish90.jpg"];
    beer3.beerName = @"DOGFISH 90";
    
    BeerObject *beer4 = [BeerObject new];
    
    beer4.beerImage = [UIImage imageNamed:@"guinessdraught"];
    beer4.beerName = @"GUINESS DRAUGHT";
    
    BeerObject *beer5 = [BeerObject new];
    
    beer5.beerImage = [UIImage imageNamed:@"lagunitasipa.jpg"];
    beer5.beerName = @"LAGUNITAS IPA";
    
    BeerObject *beer6 = [BeerObject new];
    
    beer6.beerImage = [UIImage imageNamed:@"magichat#9.jpg"];
    beer6.beerName = @"MAGIC HAT #9";
    
    BeerObject *beer7 = [BeerObject new];
    
    beer7.beerImage = [UIImage imageNamed:@"millerlite"];
    beer7.beerName = @"MILLER LITE";
    
    BeerObject *beer8 = [BeerObject new];
    
    beer8.beerImage = [UIImage imageNamed:@"newcastlebrown"];
    beer8.beerName = @"NEWCASTLE BROWN";
    
    BeerObject *beer9 = [BeerObject new];
    
    beer9.beerImage = [UIImage imageNamed:@"yuenglinglager.jpg"];
    beer9.beerName = @"YUENGLING LAGER";
    
//    BeerObject *beer10 = [BeerObject new];
//    
//    beer10.beerImage = [UIImage imageNamed:@""];
//    beer10.beerName = @"";
    
    return @[beer1,beer2,beer3,beer4,beer5,beer6,beer7,beer8,beer9];
}

@end
