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
    [self.fightInfoTableView reloadData];
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
        
        if (self.pick) {
            cell.makePickButton.titleLabel.text = [self pickCellButtonRepresentationForPick:self.pick];
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
        
    }
}

-(void)changePick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Make your pick for %@",self.fight.titleForScheduleView]
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:[NSString stringWithFormat:@"%@ by dec",self.boxerA.lastName],
                                                                    [NSString stringWithFormat:@"%@ by KO",self.boxerA.lastName],
                                                                    [NSString stringWithFormat:@"%@ by dec",self.boxerB.lastName],
                                  [NSString stringWithFormat:@"%@ by KO",self.boxerB.lastName],nil];
    
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        NSString *postURLString = [URLS urlStringForPostingPickForFight:self.fight];
        NSArray *stringArray = [buttonTitle componentsSeparatedByString:@" "];
        
        Boxer *pickedBoxer;
        for (Boxer *b in self.fight.boxers) {
            if ([b.lastName isEqualToString:stringArray[0]]) {
                pickedBoxer = b;
            }
        }
        
        BOOL ko;
        if ([[stringArray lastObject] isEqualToString:@"KO"]) {
            ko = YES;
        } else {
            ko = NO;
        }
        
        [self postUserActivityDictionary:[self postDictionaryForPicking:pickedBoxer byKO:ko] toURLString:postURLString];
        [self refresh];
        // [self.fightInfoTableView reloadData];
    }
}

-(NSDictionary *)postDictionaryForPicking:(Boxer *)boxer byKO:(BOOL)ko
{
    /*
    // set new current pick
    Pick *currentPick = [[Pick alloc] init];
    currentPick.user = self.loggedInUser;
    currentPick.fight = self.fight;
    for (Boxer *b in self.fight.boxers) {
        if ([b.boxerID.description isEqualToString:boxer.boxerID.description]) {
            currentPick.winner = b;
        } else {
            currentPick.loser = b;
        }
    }
    currentPick.byStoppage = ko;
    self.pick = currentPick;
    */
    
    return @{@"pick":@{@"winner_id": boxer.boxerID, @"ko":[self stringForBool:ko]}};
}

-(NSString *)stringForBool:(BOOL)boolean
{
    if (boolean) {
        return @"true";
    } else {
        return @"false";
    }
}

-(NSString *)pickCellButtonRepresentationForPick:(Pick *)pick
{
    return [NSString stringWithFormat:@"%@ %@",pick.winner.lastName,pick.byStoppage ? @"by KO" : @"by decision"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showComments"]) {
        TBACommentsMultipleVC *controller = (TBACommentsMultipleVC *)segue.destinationViewController;
        controller.fight = self.fight;
    }
}
@end
