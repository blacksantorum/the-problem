//
//  BoxingScheduleVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxingScheduleVC.h"
#import "ScheduleFormattedDate.h"
#import "Fight.h"
#import "Boxer.h"
#import "UpcomingFightVC.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface BoxingScheduleVC ()

@property (nonatomic,strong) NSArray *fightDates;
@property (nonatomic,strong) NSArray *fights;
@property (nonatomic,strong) NSDictionary *picksJSONdictionary;
@property (nonatomic,strong) NSArray *usersPicks;

-(NSArray *)fightsForDate:(NSDate *)date;


@end

@implementation BoxingScheduleVC

-(Pick *)usersPickForFight:(Fight *)fight
{
    Pick *pick = nil;
    for (Pick *p in self.usersPicks) {
        if ([fight.fightID.description isEqualToString:p.fight.fightID.description]) {
            pick = p;
        }
    }
    return pick;
}

-(User *)loggedInUser
{
    BoxFanRevealController *bfrc= (BoxFanRevealController *)self.revealController;
    return bfrc.loggedInUser;
}

-(void)refresh
{
    [super refresh];
    NSLog(@"%@",self.loggedInUser);
    
    if (self.loggedInUser) {
    
        NSURLRequest *pickRequest = [NSURLRequest requestWithURL:[URLS urlForPicksOfUser:self.loggedInUser]];
        
        [NSURLConnection sendAsynchronousRequest:pickRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                NSLog(@"Connection error: %@", connectionError);
            } else {
                NSError *error = nil;
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error) {
                    NSLog(@"JSON parsing error: %@", error);
                } else {
                    self.picksJSONdictionary = (NSDictionary *)object;
                    NSLog(@"%@",self.picksJSONdictionary);
                    [self configurePicksDataSource];
                    [self.tableView reloadData];
                }
            }
        }];
    }
    
}


-(NSArray *)fightDates
{
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    for (Fight *f in self.fights) {
        [dateArray addObject:f.date];
    }
    NSSet *dateSet = [NSSet setWithArray:dateArray];
    NSArray *dates = [dateSet allObjects];
    _fightDates = [dates sortedArrayUsingSelector:@selector(compare:)];
    
    return _fightDates;
}

-(NSArray *)fightsForDate:(NSDate *)date
{
    NSMutableArray *fightsForDate = [[NSMutableArray alloc] init];
    
    for (Fight *f in self.fights) {
        if ([f.date isEqualToDate:date]) {
            [fightsForDate addObject:f];
        }
    }
    
    return fightsForDate;
}


-(NSURL *)urlForRequest
{
    return [URLS urlForUpcomingFights];
}

-(void)configureDataSource
{
    NSMutableArray *fightArray = [[NSMutableArray alloc] init];
    for (NSDictionary *fightDictionary in self.JSONarray) {
        Fight *f = [[Fight alloc] initWithDictionary:fightDictionary[@"fight"]];
        NSMutableArray *boxers = [[NSMutableArray alloc] init];
        for (NSDictionary *boxerDictionary in [fightDictionary valueForKeyPath:@"fight.boxers"]){
            
            Boxer *b = [[Boxer alloc] initWithDictionary:boxerDictionary[@"boxer"]];
            [boxers addObject:b];
        }
        f.boxers = boxers;
        [fightArray addObject:f];
    }
    self.fights = fightArray;
    
}

-(void)configurePicksDataSource
{
    NSMutableArray *picksArray = [[NSMutableArray alloc] init];
    for (NSDictionary *pickDictionary in [self.picksJSONdictionary valueForKey:@"user.picks"]) {
        Pick *p = [[Pick alloc] initWithScheduleViewDictionary:pickDictionary];
        [picksArray addObject:p];
    }
    self.usersPicks = picksArray;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"upcomingFightDetail"]) {
        UpcomingFightVC *controller = (UpcomingFightVC *)segue.destinationViewController;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fightDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *date = [self.fightDates objectAtIndex:section];
    NSArray *fightsForDate = [self fightsForDate:date];
    return fightsForDate.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *date = [self.fightDates objectAtIndex:section];
    return [ScheduleFormattedDate sectionHeaderFormattedStringFromDate:date];
}

-(NSAttributedString *)attributedTitleForScheduleViewForFight:(Fight *)fight
{
    NSAttributedString *title;
    Pick *pick = [self usersPickForFight:fight];
    if (!pick) {
        title = [[NSAttributedString alloc] initWithString:fight.titleForScheduleView];
    } else {
        Boxer *a = [fight.boxers objectAtIndex:0];
        NSMutableAttributedString *aName = [[NSMutableAttributedString alloc] initWithString:a.lastName];
        Boxer *b = [fight.boxers objectAtIndex:1];
        NSMutableAttributedString *bName = [[NSMutableAttributedString alloc] initWithString:b.lastName];
        
        // make winner string bold, append them together in title
        
        
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Upcoming Fight Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *date = [self.fightDates objectAtIndex:indexPath.section];
    NSArray *fightArrayAtDate = [self fightsForDate:date];
    Fight *fight = fightArrayAtDate[indexPath.row];
    cell.textLabel.text = fight.titleForScheduleView;
    
    return cell;
}

@end
