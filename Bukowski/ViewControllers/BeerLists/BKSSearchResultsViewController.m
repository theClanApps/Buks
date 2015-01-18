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
#import "Beer.h"
#import "Brewery.h"

@interface BKSSearchResultsViewController ()

@property (strong, nonatomic) Beer *beerSelected;

@end

@implementation BKSSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    Beer *beer = (Beer *)[self.beersFilteredCollection filteredBeersAtIndex:indexPath.row];
    
    cell.textLabel.text = beer.beerName;
    cell.detailTextLabel.text = beer.brewery.breweryName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.beerSelected = [self.beersFilteredCollection filteredBeersAtIndex:indexPath.row];
    [self.delegate beerSearchResultsViewControllerDidSelectBeer:self beerSelected:self.beerSelected];
}

@end
