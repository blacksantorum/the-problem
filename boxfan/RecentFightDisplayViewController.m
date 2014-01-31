//
//  RecentFightDisplayViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/22/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "RecentFightDisplayViewController.h"
#import "FightInfoCell.h"
#import "PickInfoCell.h"
#import "DecisionInfoCell.h"
#import "ScheduleFormattedDate.h"

@interface RecentFightDisplayViewController ()

@property NSDictionary *boxersToPickPercentages;
@property NSDictionary *boxersToDecisionPercentages;

@end

@implementation RecentFightDisplayViewController

- (void)changeFOY
{
    [self.manager POST:[URLS urlStringForUpdatingFOYtoFight:self.fight] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    self.loggedInUser.foy = self.fight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.fight.stoppage) {
        return 3;
    } else {
        return 4;
    }
}

#pragma mark - Action Sheet stuff

-(void)changeDecision
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Who do you think won %@",self.fight.titleForScheduleView]
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:self.fight.boxerA.boxerFullName,self.fight.boxerB.boxerFullName,nil];
    
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        NSString *postURLString = [URLS urlStringForPostingDecisionForFight:self.fight];
        
        Boxer *decidedBoxer;
        for (Boxer *b in self.fight.boxers) {
            if ([b.boxerFullName isEqualToString:buttonTitle]) {
                decidedBoxer = b;
            }
        }
        
        [self postUserActivityDictionary:[self postDictionaryForDeciding:decidedBoxer] toURLString:postURLString];
    }
}

-(NSDictionary *)postDictionaryForDeciding:(Boxer *)boxer
{
    return @{@"decision":@{@"winner_id": boxer.boxerID}};
}

-(void)postUserActivityDictionary:(NSDictionary *)dictionary toURLString:(NSString *)url
{
    DecisionInfoCell *cell = (DecisionInfoCell *)[self.fightInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    cell.makeDecisionButton.titleLabel.text = @"Updating...";
    cell.makeDecisionButton.enabled = NO;
    [self.manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self refresh];
        cell.makeDecisionButton.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
