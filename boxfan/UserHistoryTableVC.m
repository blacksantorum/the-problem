//
//  UserHistoryTableVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/28/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UserHistoryTableVC.h"
#import "UserActivity.h"
#import "UserActivityCell.h"
#import "TTTTimeIntervalFormatter.h"

@interface UserHistoryTableVC ()

@property (nonatomic,strong) NSArray *userActivities;

@end

@implementation UserHistoryTableVC

- (NSURL *)urlForRequest
{
    return [URLS urlForPicksOfUser:self.displayedUser];
}

-(void)configureDataSource
{
    NSDictionary *JSONdictionary = (NSDictionary *)self.JSONarray;
    
    NSArray *decisionsArrayJSON = [JSONdictionary valueForKeyPath:@"user.decisions"];
    
    NSMutableArray *userActivitiesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *decisionDictionary in decisionsArrayJSON) {
        UserActivity *u = [[UserActivity alloc] initForUserHistoryWithDecisionDictionary:[decisionDictionary valueForKey:@"decision"]];
        u.user = self.displayedUser;
        [userActivitiesArray addObject:u];
    }
    
    NSArray *picksArrayJSON = [JSONdictionary valueForKeyPath:@"user.picks"];
    
    for (NSDictionary *pickDictionary in picksArrayJSON) {
        UserActivity *u = [[UserActivity alloc] initForUserHistoryWithPickDictionary:[pickDictionary valueForKey:@"pick"]];
        [userActivitiesArray addObject:u];
    }
    
    self.userActivities = [userActivitiesArray sortedArrayUsingComparator: ^(id a, id b) {
        NSDate *d1 = [(UserActivity *)a modifiedDate];
        NSDate *d2 = [(UserActivity *)b modifiedDate];
        return [d2 compare:d1];
    }];
    
    NSLog (@"%@",self.userActivities);
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userActivities count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"User Activity Cell";
    
    [self.tableView registerClass:[UserActivityCell class] forCellReuseIdentifier:CellIdentifier];
    
    UserActivityCell *cell = (UserActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserActivityCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (UserActivityCell *)currentObject;
                break;
            }
        }
    }
    
    UserActivity *activity = self.userActivities[indexPath.row];
    
    cell.activityTypeLabel.text = [self typeStringForActivity:activity];
    cell.activityDescriptionLabel.text = [self descriptionStringForActivity:activity];
    cell.activityTimeLabel.text = [self timeStringForActivity:activity];
    
    return cell;

}

- (NSString *)typeStringForActivity:(UserActivity *)activity
{
    return activity.activityType == PICK ? @"Prediction:" : @"Decision:";
}

- (NSString *)descriptionStringForActivity:(UserActivity *)activity
{
    NSString *middleString;
    if (activity.activityType == DECISION) {
        middleString = @"beat";
    } else {
        if (activity.byStoppage) {
            middleString = @"KO";
        } else {
            middleString = @"def";
        }
    }
    return [NSString stringWithFormat:@"%@ %@ %@",[self boxerNameDisplay:activity.winner],middleString,[self boxerNameDisplay:activity.loser]];
}

- (NSString *)timeStringForActivity:(UserActivity *)activity
{
    NSLog (@"%@",activity.modifiedDate);
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    return [formatter stringForTimeIntervalFromDate:[NSDate date] toDate:activity.modifiedDate];
}

- (NSString *)boxerNameDisplay:(Boxer *)boxer
{
    return [NSString stringWithFormat:@"%@. %@",[boxer.firstName substringToIndex:1] ,boxer.lastName];
}

@end
