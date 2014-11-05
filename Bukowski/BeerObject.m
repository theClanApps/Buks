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
    beer1.beerName = @"Boston Lager";
    beer1.brewery = @"Samuel Adams";
    beer1.beerStyle = @"Lager";
    beer1.beerDescription = @"Full-flavored with a balance of malty sweetness contrasted by hop spiciness and a smooth finish";
    beer1.bottleImage = [UIImage imageNamed:@"bostonlager"];
    beer1.abv = @"4.9";
    beer1.price = @"6";
    beer1.size = @"12";
    //beer1.glassImage = @"";
    beer1.nickname = @"Boston Lager";
    
    BeerObject *beer2 = [BeerObject new];
    beer2.beerName = @"90 Minute IPA";
    beer2.brewery = @"Dogfish Head";
    beer2.beerStyle = @"Imperial IPA";
    beer2.beerDescription = @"An imperial IPA best savored from a snifter, 90 Minute has a great malt backbone that stands up to the extreme hopping rate.";
    beer2.bottleImage = [UIImage imageNamed:@"dogfish90.jpg"];
    beer2.abv = @"9";
    beer2.price = @"9";
    beer2.size = @"12";
    //beer2.glassImage = @"";
    beer2.nickname = @"Dogfish 90";
    
    BeerObject *beer3 = [BeerObject new];
    beer3.beerName = @"Draught";
    beer3.brewery = @"Guiness";
    beer3.beerStyle = @"Stout";
    beer3.beerDescription = @"Super generic Irish stout.";
    beer3.bottleImage = [UIImage imageNamed:@"guinessdraught"];
    beer3.abv = @"4.2";
    beer3.price = @"7";
    beer3.size = @"12";
    //beer3.glassImage = @"";
    beer3.nickname = @"Guiness Draught";
    
    BeerObject *beer4 = [BeerObject new];
    beer4.beerName = @"#9";
    beer4.brewery = @"Magic Hat";
    beer4.beerStyle = @"Fruit";
    beer4.beerDescription = @"A sort of dry, crisp, refreshing, not-quite pale ale. #9 is really impossible to describe because there's never been anything else quite like it";
    beer4.bottleImage = [UIImage imageNamed:@"magichat#9.jpg"];
    beer4.abv = @"5.1";
    beer4.price = @"6.5";
    beer4.size = @"12";
    //beer4.glassImage = @"";
    beer4.nickname = @"Magic Hat #9";
    
    BeerObject *beer5 = [BeerObject new];
    beer5.beerName = @"Miller Lite";
    beer5.brewery = @"Miller";
    beer5.beerStyle = @"Light Lager";
    beer5.beerDescription = @"The worst of the worst.";
    beer5.bottleImage = [UIImage imageNamed:@"millerlite"];
    beer5.abv = @"4.17";
    beer5.price = @"5";
    beer5.size = @"12";
    //beer5.glassImage = @"";
    beer5.nickname = @"Miller Lite";
    
    BeerObject *beer6 = [BeerObject new];
    beer6.beerName = @"IPA";
    beer6.brewery = @"Lagunitas";
    beer6.beerStyle = @"IPA";
    beer6.beerDescription = @"Standard, great IPA.";
    beer6.bottleImage = [UIImage imageNamed:@"lagunitasipa.jpg"];
    beer6.abv = @"6.2";
    beer6.price = @"7.5";
    beer6.size = @"12";
    //beer6.glassImage = @"";
    beer6.nickname = @"Lagunitas IPA";
    
    BeerObject *beer7 = [BeerObject new];
    beer7.beerName = @"Traditional Lager";
    beer7.brewery = @"Yuengling";
    beer7.beerStyle = @"Lager";
    beer7.beerDescription = @"The best of the worst standard party lagers on the market.";
    beer7.bottleImage = [UIImage imageNamed:@"yuenglinglager.jpg"];
    beer7.abv = @"4.4";
    beer7.price = @"6.5";
    beer7.size = @"12";
    //beer7.glassImage = @"";
    beer7.nickname = @"Yuengling Lager";
    
    BeerObject *beer8 = [BeerObject new];
    beer8.beerName = @"Blue Moon Belgian White";
    beer8.brewery = @"Coors Brewing Company";
    beer8.beerStyle = @"Witbier";
    beer8.beerDescription = @"Your girlfriend tells you she loves this beer.";
    beer8.bottleImage = [UIImage imageNamed:@"bluemoonwhite.jpg"];
    beer8.abv = @"5.4";
    beer8.price = @"5.5";
    beer8.size = @"12";
    //beer8.glassImage = @"";
    beer8.nickname = @"Blue Moon White";
    
    BeerObject *beer9 = [BeerObject new];
    beer9.beerName = @"Blue (Grand Reserve)";
    beer9.brewery = @"Chimay";
    beer9.beerStyle = @"Strong Ale";
    beer9.beerDescription = @"One of the Chimay beers.";
    beer9.bottleImage = [UIImage imageNamed:@""];
    beer9.abv = @"9";
    beer9.price = @"9.5";
    beer9.size = @"12";
    //beer9.glassImage = @"";
    beer9.nickname = @"Chimay Blue";
    
    BeerObject *beer10 = [BeerObject new];
    beer10.beerName = @"Newcastle Brown Ale";
    beer10.brewery = @"The Caledonian Brewery Company Limited";
    beer10.beerStyle = @"Brown Ale";
    beer10.beerDescription = @"It’s the first brown ale you claimed to like. It’s ok, but a little too sweet for a beer that isn't a double or triple.";
    beer10.bottleImage = [UIImage imageNamed:@"newcastlebrown"];
    beer10.abv = @"4.7";
    beer10.price = @"7";
    beer10.size = @"12";
    //beer10.glassImage = @"";
    beer10.nickname = @"Newcastle Brown";
    
    return @[beer1,beer2,beer3,beer4,beer5,beer6,beer7,beer8,beer9,beer10];
}

@end
