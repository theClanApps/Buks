//
//  BKSProgressViewController.h
//  Bukowski
//
//  Created by Ezra on 12/19/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObject.h"

@interface BKSProgressViewController : UIViewController

@property (strong, nonatomic) UserObject *currentUser;
@property (strong, nonatomic) NSArray *userBeers;

@end
