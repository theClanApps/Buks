//
//  BKSStyleViewController.h
//  Bukowski
//
//  Created by Nicholas Servidio on 12/20/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeerStyle;

@interface BKSStyleViewController : UIViewController
@property (strong, nonatomic) NSArray *beersOfStyle;
@property (strong, nonatomic) BeerStyle *style;

@end
