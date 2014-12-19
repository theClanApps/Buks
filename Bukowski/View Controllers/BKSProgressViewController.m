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
    
    self.dateStartedLabel.text = [dateFormatter stringFromDate:self.currentUser.mugClubStartDate];
    NSInteger daysLeft = [self dateDiffrenceFromDate:[dateFormatter stringFromDate:[NSDate date]] second:[dateFormatter stringFromDate:self.currentUser.mugClubEndDate]];
    self.daysLeftLabel.text = @(daysLeft).stringValue;
    self.endDateLabel.text = [dateFormatter stringFromDate:self.currentUser.mugClubEndDate];
    //% is not working right now
    self.drankNumberAndPercentageLabel.text = [NSString stringWithFormat:@"%lu (%lu%%)", [self getBeersDrank], ([self getBeersDrank] / (self.userBeers.count))];
    self.beersLeftLabel.text = [NSString stringWithFormat:@"%lu", (self.userBeers.count - [self getBeersDrank])];
    self.totalBeersLabel.text = [NSString stringWithFormat:@"%lu", self.userBeers.count];
    
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

-(NSInteger)dateDiffrenceFromDate:(NSString *)date1 second:(NSString *)date2 {
    // Manage Date Formation same for both dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *startDate = [formatter dateFromString:date1];
    NSDate *endDate = [formatter dateFromString:date2];
    
    
    unsigned flags = NSCalendarUnitDay;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
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
