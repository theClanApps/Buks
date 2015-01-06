//
//  BKSSearchResultsViewController.m
//  Bukowski
//
//  Created by Ezra on 1/5/15.
//  Copyright (c) 2015 The Clan. All rights reserved.
//

#import "BKSSearchResultsViewController.h"
#import "UserBeerObject.h"

@interface BKSSearchResultsViewController ()

@end

@implementation BKSSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allBeers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell" forIndexPath:indexPath];
    
    UserBeerObject *userBeer = (UserBeerObject *)[self.allBeers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = userBeer.beer.beerName;
    cell.detailTextLabel.text = userBeer.beer.brewery;
    return cell;
}



@end
