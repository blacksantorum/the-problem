//
//  UpcomingFightViewController.m
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightViewController.h"
#import "FightInfoCell.h"
#import "PickInfoCell.h"

@interface UpcomingFightViewController ()

@property (strong,nonatomic) NSDictionary *boxersToPickPercentages;

@end

@implementation UpcomingFightViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)configureDataSource
{
    NSDictionary *pickDictionary = self.JSONdictionary;
    self.pick = [[Pick alloc] initWithFightViewDictionary:pickDictionary];
    
    NSMutableDictionary *boxersToPicksPercentages = [[NSMutableDictionary alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        NSString *boxerName = [NSString stringWithFormat:@"%@ %@",[boxerDict valueForKeyPath:@"boxer.first_name"],[boxerDict valueForKeyPath:@"boxer.last_name"]];
        NSString *pickPercentage = [boxerDict valueForKeyPath:@"boxer.percent_pick"];
        [boxersToPicksPercentages addEntriesFromDictionary:@{boxerName:pickPercentage.description}];
    }
    self.boxersToPickPercentages = boxersToPicksPercentages;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Fight Info";
    }
    else
    {
        return @"Predictions";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Fight Info Cell";
        
        [self.fightInfoTableView registerClass:[FightInfoCell class] forCellReuseIdentifier:CellIdentifier];
        
        FightInfoCell *cell = (FightInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Fight Info Cell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (FightInfoCell *)currentObject;
                    break;
                }
            }
        }
        
        cell.fight = self.fight;
        return cell;
    } else {
        
        static NSString *CellIdentifier = @"Pick Info Cell";
        
        [self.fightInfoTableView registerClass:[PickInfoCell class] forCellReuseIdentifier:CellIdentifier];
        
        PickInfoCell *cell = (PickInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Pick Info Cell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (PickInfoCell *)currentObject;
                    break;
                }
            }
        }
        
        cell.pick = self.pick;
        cell.boxerA = self.boxerA;
        cell.boxerB = self.boxerB;
        cell.boxersToPickPercentages = self.boxersToPickPercentages;
        return cell;
        
    }
}
@end
