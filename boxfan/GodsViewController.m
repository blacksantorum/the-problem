//
//  GodsViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/15/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "GodsViewController.h"
#import "User.h"
#import "UserPickViewController.h"

@interface GodsViewController ()

@property (nonatomic,strong) NSArray *gods;

@end

@implementation GodsViewController

-(NSURL *)urlForRequest
{
    return [URLS urlForGods];
}

-(void)configureDataSource
{
    NSMutableArray *gods = [[NSMutableArray alloc] init];
    for (NSDictionary *userDictionary in self.JSONarray) {
        User *g = [[User alloc] initWithListOfUsersDictionary:userDictionary[@"user"]];
        [gods addObject:g];
    }
    self.gods = gods;
    NSLog(@"%@",self.gods);
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.gods count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Gods Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = indexPath.row;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    User *user = [self.gods objectAtIndex:row];
    cell.textLabel.text = user.titleForGodsView;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showUserFromGods"]) {
        UserPickViewController *controller = (UserPickViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        User *user = self.gods[indexPath.row];
        
        controller.displayedUser = user;
        controller.title = user.handle;
    }
}

@end
