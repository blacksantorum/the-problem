//
//  SidebarViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "SidebarViewController.h"
#import "BoxFanRevealController.h"
#import <PKRevealController.h>
#import "UpcomingFightNavController.h"
#import "UserPickViewController.h"
#import "RecentFightNavController.h"
#import "FindUserNavController.h"
#import "MyProfileNavController.h"
#import "Interstitial.h"

@interface SidebarViewController ()

@property (strong,nonatomic) UIStoryboard *storyboard;

@end

@implementation SidebarViewController

-(UIStoryboard *)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSInteger row = indexPath.row;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (row == 0) {
        cell.textLabel.text = @"";
    }
    if (row == 1) {
        cell.textLabel.text = @"Find User";
    }
    if (row == 2) {
        cell.textLabel.text = @"Upcoming Fights";
    }
    if (row == 3) {
        cell.textLabel.text = @"Recent Fights";
    }
    if (row == 4) {
        cell.textLabel.text = @"Log out";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 1) {
        if (![[[self revealController] frontViewController] isKindOfClass:[FindUserNavController class]]) {
            UINavigationController *findUserNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"FindUserNav"];
            [[self revealController] setFrontViewController:findUserNavController];
            [[self revealController] showViewController:findUserNavController];
        } else {
            [[self revealController] showViewController:[[self revealController] frontViewController]];
        }
    }
    
    if (row == 2) {
        if (![[[self revealController] frontViewController] isKindOfClass:[UpcomingFightNavController class]]) {
            UINavigationController *scheduleNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleNav"];
            [[self revealController] setFrontViewController:scheduleNavController];
            [[self revealController] showViewController:scheduleNavController];
        } else {
            [[self revealController] showViewController:[[self revealController] frontViewController]];
        }
    }
    
    if (row == 3) {
        if (![[[self revealController] frontViewController] isKindOfClass:[RecentFightNavController class]]) {
            UINavigationController *recentNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentNav"];
            [[self revealController] setFrontViewController:recentNavController];
            [[self revealController] showViewController:recentNavController];
        } else {
            [[self revealController] showViewController:[[self revealController] frontViewController]];
        }
    }

    if (row == 4) {
        [PFUser logOut];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"User"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        BoxFanRevealController *brfc = (BoxFanRevealController *)[self revealController];
        brfc.loggedInUser = nil;
        
        Interstitial *inter = [[Interstitial alloc] initWithNibName:@"Interstitial" bundle:nil];
        inter.delegate = self;
        [self presentViewController:inter animated:YES completion:nil];
    }
}

-(void)passUser:(User *)user
{
    self.loggedInUser = user;
}

@end
