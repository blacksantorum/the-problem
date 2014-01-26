//
//  BoxingScheduleVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxingScheduleVC.h"
#import "UpcomingFightViewController.h"
#import "UpcomingFightCell.h"

@interface BoxingScheduleVC ()

@end

@implementation BoxingScheduleVC

- (NSURL *)urlForRequest
{
    return [URLS urlForUpcomingFights];
}

-(NSArray *)appropriatelySortedDateArray:(NSArray *)dateArray
{
    return [dateArray sortedArrayUsingComparator: ^(NSDate *d1, NSDate *d2) {
        return [d1 compare:d2];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"upcomingFightDetail" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"upcomingFightDetail"]) {
        UpcomingFightViewController *controller = (UpcomingFightViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDate *date = [self.fightDates objectAtIndex:indexPath.section];
        NSArray *fightsForDate = [self fightsForDate:date];
        
        Fight *fight = fightsForDate[indexPath.row];
        
        controller.loggedInUser = self.loggedInUser;
        controller.fight = fight;
        controller.title = fight.titleForScheduleView;
    }
}

@end
