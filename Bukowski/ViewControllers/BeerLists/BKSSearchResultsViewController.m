//
//  BKSSearchResultsViewController.m
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSSearchResultsViewController.h"
#import "UserBeerObject.h"
#import "BKSBeersFilteredCollection.h"

@interface BKSSearchResultsViewController ()

@property (strong, nonatomic) UserBeerObject *beerSelected;

@end

@implementation BKSSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beersFilteredCollection = [[BKSBeersFilteredCollection alloc] initWithUnfilteredBeers:self.allBeers];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.beersFilteredCollection countOfFilteredBeers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    UserBeerObject *userBeer = (UserBeerObject *)[self.beersFilteredCollection filteredBeersAtIndex:indexPath.row];
    
    cell.textLabel.text = userBeer.beer.beerName;
    cell.detailTextLabel.text = userBeer.beer.brewery;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.beerSelected = [self.beersFilteredCollection filteredBeersAtIndex:indexPath.row];
    [self.delegate beerSearchResultsViewControllerDidSelectBeer:self beerSelected:self.beerSelected];
}

@end
