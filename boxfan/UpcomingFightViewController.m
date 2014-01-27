//
//  UpcomingFightViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightViewController.h"
#import "FightInfoCell.h"
#import "ScheduleFormattedDate.h"
#import "TBACommentsMultipleVC.h"

@interface UpcomingFightViewController ()

@property (strong,nonatomic) NSDictionary *boxersToPickPercentages;

@end

@implementation UpcomingFightViewController


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
