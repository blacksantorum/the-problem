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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.fight.stoppage) {
        return 2;
    } else {
        return 3;
    }
}



@end
