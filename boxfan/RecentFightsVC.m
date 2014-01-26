//
//  RecentFightsVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/15/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "RecentFightsVC.h"
#import "Boxer.h"
#import "ScheduleFormattedDate.h"
#import "RecentFightDisplayViewController.h"

@interface RecentFightsVC ()

@end

@implementation RecentFightsVC

-(NSArray *)appropriatelySortedDateArray:(NSArray *)dateArray
{
    return [dateArray sortedArrayUsingComparator: ^(NSDate *d1, NSDate *d2) {
        return [d2 compare:d1];
    }];
}

-(NSURL *)urlForRequest
{
    return [URLS urlForRecentFights];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRecentFight" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRecentFight"]) {
        RecentFightDisplayViewController *controller = (RecentFightDisplayViewController *)segue.destinationViewController;
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
