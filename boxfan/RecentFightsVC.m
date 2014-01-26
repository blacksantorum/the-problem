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
#import "RecentFightsDisplayVC.h"

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

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Fight Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self.fightDates objectAtIndex:indexPath.section];
    NSArray *fightArrayAtDate = [self fightsForDate:date];
    Fight *fight = fightArrayAtDate[indexPath.row];
    cell.textLabel.text = fight.titleForRecentFightsView;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRecentFight"]) {
        RecentFightsDisplayVC *controller = (RecentFightsDisplayVC *)segue.destinationViewController;
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
