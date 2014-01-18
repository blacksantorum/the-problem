//
//  DecisionControl.h
//  boxfan
//
//  Created by Chris Tibbs on 1/17/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fight.h"
#import "Decision.h"

@protocol MakeDecisionDelegate <NSObject>

-(void)makeDecision:(Fight *)fight;


@end

@interface DecisionControl : UIView

@property (strong,nonatomic) Fight *fight;
@property (strong,nonatomic) Decision *decision;

@property (strong,nonatomic) Boxer *winner;
@property (strong,nonatomic) Boxer *loser;

@property (nonatomic,strong) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *winningBoxerDecisionPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *losingBoxerDecisionPercentageLabel;

@property (weak, nonatomic) IBOutlet UIButton *decisionButton;

- (IBAction)decisionButtonPressed:(id)sender;

@property (nonatomic,assign)id delegate;

@end
