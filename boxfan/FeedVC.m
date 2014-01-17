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

@interface FeedVC ()

@property (nonatomic,strong) NSArray *picks; // recent picks

@end

@implementation FeedVC

-(NSURL *)urlForRequest
{
    return [URLS urlForFeed];
}

-(void)configureDataSource
{
    NSMutableArray *pickArray = [[NSMutableArray alloc] init];
    for (NSDictionary *pickDictionary in self.JSONarray) {
        Pick *pick = [[Pick alloc] initWithFeedViewDictionary:pickDictionary];
        [pickArray addObject:pick];
    }
    self.picks = pickArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.picks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Feed Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Pick *pick = [self.picks objectAtIndex:row];
    cell.textLabel.text = pick.feedRepresentation;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showUserFromFeed"]) {
        UserPickViewController *controller = (UserPickViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        Pick *pick = self.picks[indexPath.row];
        
        controller.displayedUser = pick.user;
        controller.title = pick.user.handle;
    }
}

@end
