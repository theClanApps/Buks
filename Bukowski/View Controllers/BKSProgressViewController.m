//
//  BKSProgressViewController.m
//  Bukowski
//
//  Created by Ezra on 12/19/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSProgressViewController.h"
#import "UserBeerObject.h"

@interface BKSProgressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *drankNumberAndPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *beersLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBeersLabel;

@end

@implementation BKSProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLabels];
}

- (void)setupLabels {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"User: %@", self.currentUser);
    
    self.dateStartedLabel.text = [dateFormatter stringFromDate:self.currentUser.MugClubStartDate];
    
    //calculate end date
    NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
    monthComponent.month = 6;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    self.currentUser.mugClubEndDate = [theCalendar dateByAddingComponents:monthComponent toDate:self.currentUser.MugClubStartDate options:0];
    
    NSInteger daysLeft = [self dateDiffrenceFromDate:[NSDate date] second:self.currentUser.mugClubEndDate];
    self.daysLeftLabel.text = @(daysLeft).stringValue;
    self.endDateLabel.text = [dateFormatter stringFromDate:self.currentUser.mugClubEndDate];
    

    //% is not working right now
    //NSInteger beersDrankInt = [self getBeersDrank];
    
    int beersDrank = [self getBeersDrank];
    int totalBeers = self.userBeers.count;
    int percentDrank = 100 * beersDrank / totalBeers;
    self.drankNumberAndPercentageLabel.text = [NSString stringWithFormat:@"%i (%i%%)", beersDrank, percentDrank];
    self.beersLeftLabel.text = [NSString stringWithFormat:@"%lu", (self.userBeers.count - [self getBeersDrank])];
    self.totalBeersLabel.text = [NSString stringWithFormat:@"%d", totalBeers];
    
}

- (NSInteger)getBeersDrank {
    NSInteger i = 0;
    for (UserBeerObject *userBeer in self.userBeers) {
        if ([userBeer.drank intValue] == 1) {
            i++;
        }
    }
    return i;
}

-(NSInteger)dateDiffrenceFromDate:(NSDate *)date1 second:(NSDate *)date2 {

    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                   fromDate:date1
                                                                     toDate:date2
                                                                    options:0];
    
    NSInteger dayDiff = [difference day];
    return dayDiff;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
