//
//  FindUserVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/15/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FindUserVC.h"
#import "User.h"
#import <PKRevealController/PKRevealController.h>
#import "UserPickViewController.h"

@interface FindUserVC ()

@property (nonatomic,strong) NSArray *users;
@property (nonatomic,strong) NSDictionary *usersDictionary; // {"<twitter handle> <name> : <User>, ....}
@property (nonatomic,strong) NSMutableArray *filteredUsers;

@property BOOL isSearching;

@end

@implementation FindUserVC

-(UITableViewCell *)configureCell:(UITableViewCell *)cell
                          forUser:(User *)user
{
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.handle;
    
    return cell;
}

-(NSURL *)urlForRequest
{
    return [URLS urlForUsers];
}

-(void)filterListForSearchText:(NSString *)searchText
{
    [self.filteredUsers removeAllObjects];
    NSArray *twitterPlusNameArray = [self.usersDictionary allKeys];
    
    for (NSString *title in twitterPlusNameArray) {
        NSRange nameRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [self.filteredUsers addObject:[self.usersDictionary objectForKey:title]];
        }
    }
    NSLog(@"%@ and Is Searching: %s",self.filteredUsers,self.isSearching ? "true" : "false");
    [self.searchDisplayController.searchResultsTableView reloadData];
}

-(void)configureDataSource
{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    for (NSDictionary *userDictionary in self.JSONarray) {
        User *u = [[User alloc] initWithListOfUsersDictionary:userDictionary[@"user"]];
        [userArray addObject:u];
    }
    self.users = userArray;
    
    NSMutableDictionary *usersDictionary = [[NSMutableDictionary alloc] init];
    for (User *u in self.users) {
        NSString *twitterPlusName = [NSString stringWithFormat:@"%@ %@",u.name,u.handle];
        [usersDictionary addEntriesFromDictionary:@{twitterPlusName : u}];
    }
    self.usersDictionary = usersDictionary;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.isSearching = NO;
    self.filteredUsers = [[NSMutableArray alloc] init];
}

#pragma  mark - UISearchDisplayControllerDelegate

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.isSearching = YES;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.isSearching = NO;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]];
    return YES;
}

#pragma  mark - Table View Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredUsers count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"User Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    User *u = [self.filteredUsers objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self configureCell:cell forUser:u];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showFoundUser" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFoundUser"]) {
        if ([self.searchDisplayController isActive]) {
            UserPickViewController *controller = (UserPickViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            User *user = self.filteredUsers[indexPath.row];
            
            controller.displayedUser = user;
            controller.title = user.handle;
        }
    }
    
}

- (IBAction)userClickedShowSettings:(id)sender {
    [[self revealController] showViewController:[[self revealController] leftViewController]];
}
@end
