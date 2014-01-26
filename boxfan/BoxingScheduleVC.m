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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Boxing Schedule Cell";
    
    [self.tableView registerClass:[UpcomingFightCell class] forCellReuseIdentifier:CellIdentifier];
    
    UpcomingFightCell *cell = (UpcomingFightCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UpcomingFightCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (UpcomingFightCell *)currentObject;
                break;
            }
        }
    }
    
    NSDate *date = [self.fightDates objectAtIndex:indexPath.section];
    NSArray *fightArrayAtDate = [self fightsForDate:date];
    Fight *fight = fightArrayAtDate[indexPath.row];
    
    Boxer *boxerA = [fight.boxers firstObject];
    Boxer *boxerB = [fight.boxers lastObject];
    cell.boxerALabel.text = [self boxerNameDisplay:boxerA];
    [cell.boxerACountryFlag setImage:[UIImage imageNamed:boxerA.country]];
    cell.boxerBLabel.text = [self boxerNameDisplay:boxerB];
    [cell.boxerBCountryFlag setImage:[UIImage imageNamed:boxerB.country]];
    
    return cell;
}

@end
