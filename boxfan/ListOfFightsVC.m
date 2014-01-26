//
//  ListOfFightsVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/26/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "ListOfFightsVC.h"
#import "ScheduleFormattedDate.h"

@interface ListOfFightsVC ()

@end

@implementation ListOfFightsVC

- (NSString *)boxerNameDisplay:(Boxer *)boxer
{
    return [NSString stringWithFormat:@"%@. %@",[boxer.firstName substringToIndex:1] ,boxer.lastName];
}

- (NSArray *)fightDates
{
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    for (Fight *f in self.fights) {
        [dateArray addObject:f.date];
    }
    NSSet *dateSet = [NSSet setWithArray:dateArray];
    NSArray *dates = [dateSet allObjects];
    _fightDates = [dates sortedArrayUsingSelector:@selector(compare:)];
    
    return _fightDates;
}

- (NSArray *)fightsForDate:(NSDate *)date
{
    NSMutableArray *fightsForDate = [[NSMutableArray alloc] init];
    
    for (Fight *f in self.fights) {
        if ([f.date isEqualToDate:date]) {
            [fightsForDate addObject:f];
        }
    }
    return fightsForDate;
}

- (void)configureDataSource
{
    NSMutableArray *fightArray = [[NSMutableArray alloc] init];
    for (NSDictionary *fightDictionary in self.JSONarray) {
        Fight *f = [[Fight alloc] initWithDictionary:fightDictionary[@"fight"]];
        NSMutableArray *boxers = [[NSMutableArray alloc] init];
        for (NSDictionary *boxerDictionary in [fightDictionary valueForKeyPath:@"fight.boxers"]){
            
            Boxer *b = [[Boxer alloc] initWithDictionary:boxerDictionary[@"boxer"]];
            [boxers addObject:b];
        }
        f.boxers = boxers;
        [fightArray addObject:f];
    }
    self.fights = fightArray;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fightDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *date = [self.fightDates objectAtIndex:section];
    NSArray *fightsForDate = [self fightsForDate:date];
    return fightsForDate.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *date = [self.fightDates objectAtIndex:section];
    return [ScheduleFormattedDate sectionHeaderFormattedStringFromDate:date];
}

    

@end
