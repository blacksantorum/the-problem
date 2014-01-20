//
//  FeedVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FeedVC.h"
#import "Pick.h"
#import "UserPickViewController.h"
#import "UserActivity.h"

@interface FeedVC ()

@property (nonatomic,strong) NSArray *feedItems; // of UserActivity

@end

@implementation FeedVC

-(NSURL *)urlForRequest
{
    return [URLS urlForFeed];
}

-(void)configureDataSource
{
    NSMutableArray *feedItems = [[NSMutableArray alloc] init];
    NSDictionary *feedDictionary = (NSDictionary *)self.JSONarray;
    for (NSDictionary *pickDictionary in [feedDictionary valueForKey:@"picks"]) {
        UserActivity *pick = [[UserActivity alloc] initForFeedViewWithPickDictionary:pickDictionary];
        [feedItems addObject:pick];
    }
    for (NSDictionary *decisionDictionary in [feedDictionary valueForKey:@"decisions"]) {
        UserActivity *decision = [[UserActivity alloc] initForFeedViewWithDecisionDictionary:decisionDictionary];
        [feedItems addObject:decision];
    }
    self.feedItems = [feedItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(UserActivity *)a modifiedDate];
        NSDate *second = [(UserActivity *)b modifiedDate];
        return [second compare:first];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Feed Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UserActivity *activity = [self.feedItems objectAtIndex:row];
    cell.textLabel.text = [self titleForFeedViewForActivity:activity];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showUserFromFeed"]) {
        UserPickViewController *controller = (UserPickViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        UserActivity *activity = self.feedItems[indexPath.row];
        
        controller.displayedUser = activity.user;
        controller.title = activity.user.handle;
    }
}

-(NSString *)titleForFeedViewForActivity:(UserActivity *)activity
{
    if (activity.activityType == PICK) {
        return [NSString stringWithFormat:@"%@ picked %@ over %@ by %@",activity.user.handle,activity.winner.lastName,activity.loser.lastName,activity.byStoppage ? @"KO" : @"decision"];
    } else {
        return [NSString stringWithFormat:@"%@ thought %@ beat %@",activity.user.handle,activity.winner.lastName,activity.loser.lastName];
    }
}

@end
