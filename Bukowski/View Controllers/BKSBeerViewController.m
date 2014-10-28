//
//  ParseStarterProjectViewController.m
//  ParseStarterProject
//
//  Copyright 2014 Parse, Inc. All rights reserved.
//

#import "BKSBeerViewController.h"
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "BKSDataManager.h"
#import "Beer.h"
#import "BeerStyle.h"
#import "NonPersistedBeer.h"
#import "NonPersistedBeerStyle.h"

@interface BKSBeerViewController ()
@property (strong, nonatomic) NSArray *beers;
@property (strong, nonatomic) NSArray *styles;
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *BeerAbvLabel;


@end

@implementation BKSBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    [self createBeers];
    [self createStyles];
    [self loadBeers];
    [self loadStyles];
}

- (void)createBeers
{
    NSManagedObjectContext *managedObjectContext = [[BKSDataManager sharedDataManager] managedObjectContext];
    
    Beer *bud = [NSEntityDescription insertNewObjectForEntityForName:@"Beer"
                                               inManagedObjectContext:managedObjectContext];
    
    bud.beerAbv = [NSNumber numberWithFloat:5.0];
    bud.beerID = @123456789;
    bud.beerName = @"Bud";
    
    Beer *coors = [NSEntityDescription insertNewObjectForEntityForName:@"Beer"
                                               inManagedObjectContext:managedObjectContext];
    
    coors.beerAbv = [NSNumber numberWithFloat:3.7];
    coors.beerID = @555555555;
    coors.beerName = @"Coors";
    
    Beer *cider = [NSEntityDescription insertNewObjectForEntityForName:@"Beer"
                                               inManagedObjectContext:managedObjectContext];
    
    cider.beerAbv = [NSNumber numberWithFloat:4.2];
    cider.beerID = @222222222;
    cider.beerName = @"Magners";
    
    NSError *error = nil;
    [managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Stored the beers in the DB!");
    }
}

- (void)createStyles
{
    NSManagedObjectContext *managedObjectContext = [[BKSDataManager sharedDataManager] managedObjectContext];
    
    BeerStyle *warmLager = [NSEntityDescription insertNewObjectForEntityForName:@"BeerStyle"
                                                         inManagedObjectContext:managedObjectContext];
    
    warmLager.styleName = @"Warm Lager";
    
    NSError *error = nil;
    [managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Stored the styles in the DB!");
    }
}

- (void)loadBeers
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Beer"];
    request.fetchBatchSize = 20;
    request.fetchLimit = 100;

    NSManagedObjectContext *context = [[BKSDataManager sharedDataManager] managedObjectContext];
    NSError *error;
    self.beers = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@",error);
    } else {
        NSLog(@"Loaded the beers from the DB!");
    }
}

- (void)loadStyles
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BeerStyle"];
    request.fetchBatchSize = 20;
    request.fetchLimit = 100;
    
    NSManagedObjectContext *context = [[BKSDataManager sharedDataManager] managedObjectContext];
    NSError *error;
    self.styles = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Error: %@",error);
    } else {
        NSLog(@"Loaded the styles from the DB!");
    }

}

#pragma mark - Actions

- (IBAction)loadRandomBeer:(UIButton *)sender {
    NSInteger random = arc4random() % 3;
    Beer *beer = [self.beers objectAtIndex:random];
    [self configureBeerLabelsWithBeer:beer];
    [self saveBeerToCloud:beer];
}

- (void)configureBeerLabelsWithBeer:(Beer *)beer
{
    self.beerNameLabel.text = beer.beerName;
    self.beerIDLabel.text = [NSString stringWithFormat:@"%@",beer.beerID];
    self.BeerAbvLabel.text = [NSString stringWithFormat:@"%.1f",beer.beerAbv.floatValue];
}

- (void)saveBeerToCloud:(Beer *)beer
{
    NonPersistedBeer *nonPersistedBeer = [NonPersistedBeer beerWithDatabaseBeer:beer];
    BeerStyle *beerStyle = [self.styles firstObject];
    beerStyle.styleName = @"Warm Lager";
    NonPersistedBeerStyle *nonPersistedBeerStyle = [NonPersistedBeerStyle beerStyleWithDatabaseBeerStyle:beerStyle];
    
    nonPersistedBeer.nonPersistedBeerStyle = nonPersistedBeerStyle;
    
    [nonPersistedBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved Beer in background");
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
