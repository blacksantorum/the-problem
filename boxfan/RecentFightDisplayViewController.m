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

-(Boxer *)boxerA
{
    Boxer *winner;
    for (Boxer *b in self.fight.boxers) {
        if ([b.boxerID.description isEqualToString:self.fight.winnerID.description]) {
            winner = b;
        }
    }
    return winner;
}

-(Boxer *)boxerB
{
    Boxer *loser;
    for (Boxer *b in self.fight.boxers) {
        if (![b.boxerID.description isEqualToString:self.fight.winnerID.description]) {
            loser = b;
        }
    }
    return loser;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.fight.stoppage) {
        return 2;
    } else {
        return 3;
    }
}

-(void)configureDataSource
{
    NSDictionary *pickDictionary = self.JSONdictionary;
    self.pick = [[Pick alloc] initWithFightViewDictionary:pickDictionary];
    
    NSDictionary *decisionDictionary = [self.JSONdictionary valueForKeyPath:@"fight.decision"];
    
    
    self.decision = [[Decision alloc] initWithRecentFightDisplayDictionary:decisionDictionary];
    
    NSMutableDictionary *boxersToPicksPercentages = [[NSMutableDictionary alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        NSString *boxerName = [NSString stringWithFormat:@"%@ %@",[boxerDict valueForKeyPath:@"boxer.first_name"],[boxerDict valueForKeyPath:@"boxer.last_name"]];
        NSString *pickPercentage = [boxerDict valueForKeyPath:@"boxer.percent_pick"];
        [boxersToPicksPercentages addEntriesFromDictionary:@{boxerName:pickPercentage.description}];
    }
    self.boxersToPickPercentages = boxersToPicksPercentages;
    
    NSMutableDictionary *boxersToDecisionPercentages = [[NSMutableDictionary alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        NSString *boxerName = [NSString stringWithFormat:@"%@ %@",[boxerDict valueForKeyPath:@"boxer.first_name"],[boxerDict valueForKeyPath:@"boxer.last_name"]];
        NSString *decisionPercentage = [boxerDict valueForKeyPath:@"boxer.percent_decision"];
        [boxersToDecisionPercentages addEntriesFromDictionary:@{boxerName:decisionPercentage.description}];
    }
    self.boxersToDecisionPercentages = boxersToDecisionPercentages;
    
    
    [self.fightInfoTableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Fight Info";
    }
    else if (section == 1)
    {
        return @"Predictions";
    }
    else
    {
        return @"Decisions";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 66.0;
    } else {
        return 250.0;
    }
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
        
        cell.dateLabel.text = [ScheduleFormattedDate sectionHeaderFormattedStringFromDate:self.fight.date];
        cell.locationLabel.text = self.fight.location;
        cell.roundsWeightLabel.text = [NSString stringWithFormat:@"%@ rounds at %@",self.fight.rounds,self.fight.weight];
        cell.fight = self.fight;
        return cell;
        
    } else if (indexPath.section == 1) {
        
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
        
        if (self.pick) {
            cell.makePickButton.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[self pickCellButtonRepresentationForPick:self.pick],[self scoreChangeForFight:self.fight Pick:self.pick]];
            cell.makePickButton.enabled = NO;
        } else {
            [cell.makePickButton removeFromSuperview];
        }
        
        NSString *titleA = [NSString stringWithFormat:@"%@ %@%%",self.boxerA.boxerFullName,self.boxersToPickPercentages[self.boxerA.boxerFullName]];
        NSString *titleB = [NSString stringWithFormat:@"%@ %@%%",self.boxerB.boxerFullName,self.boxersToPickPercentages[self.boxerB.boxerFullName]];
        
        NSString *pickPercentageA = self.boxersToPickPercentages[self.boxerA.boxerFullName];
        if ([pickPercentageA isEqualToString:@"0"]) {
            pickPercentageA = @"0.1";
        }
        NSString *pickPercentageB = self.boxersToPickPercentages[self.boxerB.boxerFullName];
        if ([pickPercentageB isEqualToString:@"0"]) {
            pickPercentageB = @"0.1";
        }
        
        NSArray *array = [cell.communityPicksBarChart createChartDataWithTitles:[NSArray arrayWithObjects:titleA, titleB, nil]
                                                                         values:[NSArray arrayWithObjects:pickPercentageA, pickPercentageB, nil]
                                                                         colors:[NSArray arrayWithObjects:@"17A9E3", @"E32F17", nil]
                                                                    labelColors:[NSArray arrayWithObjects:@"000000", @"000000",nil]];
        
        [cell.communityPicksBarChart setDataWithArray:array
                                             showAxis:DisplayOnlyXAxis
                                            withColor:[UIColor whiteColor]
                              shouldPlotVerticalLines:NO];
        cell.pick = self.pick;
        cell.boxerA = self.boxerA;
        cell.boxerB = self.boxerB;
        cell.boxersToPickPercentages = self.boxersToPickPercentages;
        cell.delegate = self;
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"Decision Info Cell";
        
        [self.fightInfoTableView registerClass:[DecisionInfoCell class] forCellReuseIdentifier:CellIdentifier];
        
        DecisionInfoCell *cell = (DecisionInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Decision Info Cell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (DecisionInfoCell *)currentObject;
                    break;
                }
            }
        }
        
        NSLog (@"%@",self.decision);
        if (self.decision) {
            cell.makeDecisionButton.titleLabel.text = [self decisionCellButtonRepresentationForDecision:self.decision];
        }
        
        NSString *titleA = [NSString stringWithFormat:@"%@ %@%%",self.boxerA.boxerFullName,self.boxersToDecisionPercentages[self.boxerA.boxerFullName]];
        NSString *titleB = [NSString stringWithFormat:@"%@ %@%%",self.boxerB.boxerFullName,self.boxersToDecisionPercentages[self.boxerB.boxerFullName]];
        
        NSString *decisionPercentageA = self.boxersToDecisionPercentages[self.boxerA.boxerFullName];
        if ([decisionPercentageA isEqualToString:@"0"]) {
            decisionPercentageA = @"0.1";
        }
        NSString *decisionPercentageB = self.boxersToPickPercentages[self.boxerB.boxerFullName];
        if ([decisionPercentageB isEqualToString:@"0"]) {
            decisionPercentageB = @"0.1";
        }
        
        NSArray *array = [cell.communityDecisionBarChart createChartDataWithTitles:[NSArray arrayWithObjects:titleA, titleB, nil]
                                                                         values:[NSArray arrayWithObjects:decisionPercentageA, decisionPercentageB, nil]
                                                                         colors:[NSArray arrayWithObjects:@"17A9E3", @"E32F17", nil]
                                                                    labelColors:[NSArray arrayWithObjects:@"000000", @"000000",nil]];
        
        [cell.communityDecisionBarChart setDataWithArray:array
                                             showAxis:DisplayOnlyXAxis
                                            withColor:[UIColor whiteColor]
                              shouldPlotVerticalLines:NO];
        // cell.delegate = self;
        return cell;
        
    }

}

-(NSString *)pickCellButtonRepresentationForPick:(Pick *)pick
{
    return [NSString stringWithFormat:@"%@ %@",pick.winner.lastName,pick.byStoppage ? @"by KO" : @"by decision"];
}

-(NSString *)decisionCellButtonRepresentationForDecision:(Decision *)decision
{
    return [NSString stringWithFormat:@"%@ won",decision.winner.lastName];
}

-(NSString *)scoreChangeForFight:(Fight *)fight Pick:(Pick *)pick
{
    if ([pick.winner.boxerID.description isEqualToString:fight.winnerID.description]) {
        if (pick.byStoppage == fight.stoppage) {
            return @"+2";
        } else {
            return @"+1";
        }
    } else {
        return @"";
    }
}

@end
