//
//  RecentFightsDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/18/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "RecentFightsDisplayVC.h"
#import "DecisionControl.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface RecentFightsDisplayVC ()

@property (strong,nonatomic) Boxer *winner;
@property (strong,nonatomic) Boxer *loser;

@property (weak, nonatomic) IBOutlet UILabel *locationRoundsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UILabel *winnerPickPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *loserPickPercentageLabel;

@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *loserLabel;


@property (weak, nonatomic) IBOutlet DecisionControl *decisionView;

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
    
    if (![decisionDictionary isKindOfClass:[NSNull class]]) {
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
    
    if (self.fight.stoppage) {
        [self removeDecisionView];
    } else {
        self.decisionView.fight = self.fight;
        self.decisionView.decision = self.decision;
        NSLog(@"%@",self.winner.decisionPercentage);
        self.decisionView.winningBoxerDecisionPercentageLabel.text = self.winner.decisionPercentage;
        NSLog(@"%@",self.loser.decisionPercentage);
        self.decisionView.losingBoxerDecisionPercentageLabel.text = self.loser.decisionPercentage;
        
        if (self.decision) {
            self.decisionView.decisionButton.titleLabel.text = [NSString stringWithFormat:@"You thought %@ won",self.decision.winner.lastName];
        }
    }
    
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
    self.decisionView.delegate = self;
}

-(void)removeDecisionView
{
    [self.decisionView removeFromSuperview];
}

/////////////////

-(void)makeDecision:(Fight *)fight
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Who won?"] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:self.winner.boxerFullName, self.loser.boxerFullName,nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:self.winner.boxerFullName]) {
        [self pickFighterForDecision:self.winner];
    }
    if ([buttonTitle isEqualToString:self.loser.boxerFullName]) {
        [self pickFighterForDecision:self.loser];
    }
}

-(void)pickFighterForDecision:(Boxer *)boxer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"decision":@{@"winner_id": boxer.boxerID}};
    [manager POST:[URLS urlStringForPostingDecisionForFight:self.fight] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
