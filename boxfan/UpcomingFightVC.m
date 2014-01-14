//
//  UpcomingFightVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/8/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightVC.h"
#import "FighterPickControlsView.h"
#import "PickFightView.h"
#import <AFHTTPRequestOperationManager.h>

@interface UpcomingFightVC ()

@property (weak, nonatomic) IBOutlet UILabel *locationRoundsWeightLabel;
@property (weak, nonatomic) IBOutlet FighterPickControlsView *fighterAPickControl;

@property (weak, nonatomic) IBOutlet FighterPickControlsView *fighterBPickControl;

@end

@implementation UpcomingFightVC

-(void)setTitleForButton:(UIButton *)button
                 forPick:(Pick *)pick
{
    button.titleLabel.textColor = [UIColor greenColor];
    if (pick.byStoppage) {
        button.titleLabel.text = @"KO";
    } else {
        button.titleLabel.text = @"decision";
    }
}

-(NSString *)stringForBool:(BOOL)boolean
{
    if (boolean) {
        return @"true";
    } else {
        return @"false";
    }
}

-(void)configureDataSource
{
    NSDictionary *pickDictionary = self.JSONdictionary;
    self.currentPick = [[Pick alloc] initWithFightViewDictionary:pickDictionary];
    NSLog(@"Current pick: %@",self.currentPick);
    [self setUpView];
}

-(void)setUpView
{
    self.fighterAPickControl.boxer = [self.fight.boxers firstObject];
    self.fighterBPickControl.boxer = [self.fight.boxers lastObject];
    self.locationRoundsWeightLabel.text = [NSString stringWithFormat:@"%@: %@ rounds at %@",self.fight.location,self.fight.rounds,self.fight.weight];
    self.fighterAPickControl.delegate = self;
    self.fighterBPickControl.delegate = self;
    
    if (self.currentPick) {
        if ([self.fighterAPickControl.boxer.boxerID.description isEqualToString:self.currentPick.winner.boxerID.description]) {
            [self setTitleForButton:self.fighterAPickControl.pickFighterButton forPick:self.currentPick];
        } else if ([self.fighterBPickControl.boxer.boxerID.description isEqualToString:self.currentPick.winner.boxerID.description]) {
            [self setTitleForButton:self.fighterBPickControl.pickFighterButton forPick:self.currentPick];
        }
    }
}

-(void)fighterChosen:(Boxer *)boxer
{
    PickFightView *pickFightView = [[PickFightView alloc] initWithFrame:CGRectMake(0, 500, 320, 90)];
    pickFightView.boxer = boxer;
    pickFightView.delegate = self;
    [self.view addSubview:pickFightView];
}

-(void)pickFighter:(Boxer *)boxer withKO:(BOOL)KO
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"BoxerID: %@, Bool: %@",boxer.boxerID,[self stringForBool:KO]);
    NSDictionary *parameters = @{@"pick":@{@"winner_id": boxer.boxerID, @"ko":[self stringForBool:KO] }};
    [manager POST:[URLS urlStringForPostingPickForFight:self.fight] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
