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


#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - Action Sheet stuff

-(void)changePick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Make your pick for %@",self.fight.titleForScheduleView]
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:[NSString stringWithFormat:@"%@ by dec",self.fight.boxerA.lastName],
                                  [NSString stringWithFormat:@"%@ by KO",self.fight.boxerA.lastName],
                                  [NSString stringWithFormat:@"%@ by dec",self.fight.boxerB.lastName],
                                  [NSString stringWithFormat:@"%@ by KO",self.fight.boxerB.lastName],nil];
    
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
    }
}

-(NSDictionary *)postDictionaryForPicking:(Boxer *)boxer byKO:(BOOL)ko
{
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

-(void)postUserActivityDictionary:(NSDictionary *)dictionary toURLString:(NSString *)url
{
    PickInfoCell *cell = (PickInfoCell *)[self.fightInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.makePickButton.titleLabel.text = @"Updating...";
    cell.makePickButton.enabled = NO;
    [self.manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self refresh];
        cell.makePickButton.enabled = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
