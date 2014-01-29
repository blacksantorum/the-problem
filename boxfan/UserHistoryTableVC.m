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
@property (nonatomic,strong) NSArray *searchResults;

@property (nonatomic,strong) NSDictionary *searchResultsDictionary;
@property (nonatomic,strong) NSArray *allDescriptionStrings;

@end

@implementation UserHistoryTableVC

#pragma mark - Search Display Implementation

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    NSArray *descriptionResults = [self.allDescriptionStrings filteredArrayUsingPredicate:resultPredicate];
    NSMutableArray *mutableSearchResults = [[NSMutableArray alloc] init];
    
    for (NSString *activityDescription in descriptionResults) {
        [mutableSearchResults addObject:self.searchResultsDictionary[activityDescription]];
    }
    self.searchResults = mutableSearchResults;
}

- (NSString *)descriptionStringForSearchingForActivity:(UserActivity *)activity
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
    return [NSString stringWithFormat:@"%@ %@ %@",activity.winner.boxerFullName,middleString,activity.loser.boxerFullName];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

# pragma <#arguments#>

- (NSURL *)urlForRequest
{
    return [URLS urlForPicksOfUser:self.displayedUser];
}

-(void)configureDataSource
{
    NSDictionary *JSONdictionary = (NSDictionary *)self.JSONarray;
    
    NSArray *decisionsArrayJSON = [JSONdictionary valueForKeyPath:@"user.decisions"];
    
    NSMutableArray *userActivitiesArray = [[NSMutableArray alloc] init];
    
    // dictionary of form {<winner name> <ms> <loser name> : <activity>" to allow filtered search
    NSMutableDictionary *searchResultsDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *decisionDictionary in decisionsArrayJSON) {
        UserActivity *u = [[UserActivity alloc] initForUserHistoryWithDecisionDictionary:[decisionDictionary valueForKey:@"decision"]];
        u.user = self.displayedUser;
        [userActivitiesArray addObject:u];
        [searchResultsDictionary addEntriesFromDictionary:@{[self descriptionStringForSearchingForActivity:u] : u}];
    }
    
    NSArray *picksArrayJSON = [JSONdictionary valueForKeyPath:@"user.picks"];
    
    for (NSDictionary *pickDictionary in picksArrayJSON) {
        UserActivity *u = [[UserActivity alloc] initForUserHistoryWithPickDictionary:[pickDictionary valueForKey:@"pick"]];
        u.user = self.displayedUser;
        [userActivitiesArray addObject:u];
        [searchResultsDictionary addEntriesFromDictionary:@{[self descriptionStringForSearchingForActivity:u] : u}];
    }
    
    self.searchResultsDictionary = searchResultsDictionary;
    self.allDescriptionStrings = [searchResultsDictionary allKeys];
    
    self.userActivities = [userActivitiesArray sortedArrayUsingComparator: ^(id a, id b) {
        NSDate *d1 = [(UserActivity *)a modifiedDate];
        NSDate *d2 = [(UserActivity *)b modifiedDate];
        return [d2 compare:d1];
    }];
    
    NSLog (@"%@",self.userActivities);
    
    [self.tableView reloadData];
}

#pragma mark - Table View Datasource, Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.userActivities count];
    }
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
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UserActivityCell class] forCellReuseIdentifier:CellIdentifier];
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
    
    UserActivity *activity;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        activity = self.searchResults[indexPath.row];
    } else {
        activity = self.userActivities[indexPath.row];
    }
    
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
