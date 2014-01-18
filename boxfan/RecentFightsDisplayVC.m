//
//  RecentFightsDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/18/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "RecentFightsDisplayVC.h"
#import "DecisionControl.h"

@interface RecentFightsDisplayVC ()

@property (strong,nonatomic) Boxer *winner;
@property (strong,nonatomic) Boxer *loser;

@property (weak, nonatomic) IBOutlet UILabel *locationRoundsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UILabel *winnerPickPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *loserPickPercentageLabel;

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loserLabel;


@property (weak, nonatomic) IBOutlet UIView *decisionView;

@end

@implementation RecentFightsDisplayVC

-(Boxer *)winner
{
    Boxer *winner;
    for (Boxer *b in self.fight.boxers) {
        if ([b.boxerID.description isEqualToString:self.fight.winnerID.description]) {
            winner = b;
        }
    }
    return winner;
}

-(Boxer *)loser
{
    Boxer *loser;
    for (Boxer *b in self.fight.boxers) {
        if (![b.boxerID.description isEqualToString:self.fight.winnerID.description]) {
            loser = b;
        }
    }
    return loser;
}

-(void)configureDataSource
{
    NSMutableArray *boxers = [[NSMutableArray alloc] init];
    for (NSDictionary *boxerDict in [self.JSONdictionary valueForKeyPath:@"fight.boxers"]) {
        Boxer *b = [[Boxer alloc] initWithRecentFightVewDictionary:boxerDict[@"boxer"]];
        [boxers addObject:b];
    }
    self.fight.boxers = boxers;
    
    NSDictionary *decisionDictionary = [self.JSONdictionary valueForKeyPath:@"fight.decision"];
    
    if (decisionDictionary) {
        Decision *userDecision = [[Decision alloc] initWithRecentFightDisplayDictionary:decisionDictionary];
        userDecision.user = self.loggedInUser;
        userDecision.fight = self.fight;
        
        for (Boxer *b in self.fight.boxers) {
            if ([userDecision.winner.boxerID.description isEqualToString:b.boxerID.description]) {
                userDecision.winner = b;
            } else {
                userDecision.loser = b;
            }
        }
        self.decision = userDecision;
    }
    
    [self setUpView];
    
    NSLog(@"%@",self.decision);
    
    [self addDecisionView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)setUpView
{
    self.locationRoundsWeightLabel.text = [NSString stringWithFormat:@"%@: %@ rounds at %@",self.fight.location,self.fight.rounds,self.fight.weight];
    self.resultLabel.text = self.fight.titleForRecentFightsView;
    
    self.winnerPickPercentageLabel.text = self.winner.pickPercentage;
    self.loserPickPercentageLabel.text = self.loser.pickPercentage;
    
    self.winnerLabel.text = self.winner.lastName;
    self.loserLabel.text = self.loser.lastName;
}

-(void)addDecisionView
{
    if (!self.fight.stoppage) {
        DecisionControl *decisionControl = [[DecisionControl alloc] init];
        decisionControl.fight = self.fight;
        decisionControl.winner = self.winner;
        decisionControl.loser = self.loser;
        decisionControl.decision = self.decision;
        self.decisionView = decisionControl.view;
    }
}


@end
