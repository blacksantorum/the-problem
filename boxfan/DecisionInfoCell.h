//
//  DecisionInfoCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/22/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MSSimpleGauge/MSSimpleGauge.h>

@protocol ChangeDecisionDelegate <NSObject>

-(void)changeDecision;

@end

@interface DecisionInfoCell : UITableViewCell

@property (strong,nonatomic) MSSimpleGauge *gauge;

@property (weak, nonatomic) IBOutlet UIButton *makeDecisionButton;
@property (weak, nonatomic) IBOutlet UILabel *currrentDecisionLabel;

@property CGFloat boxerAPercentage;
@property CGFloat boxerBPercentage;

- (IBAction)makeDecisionButtonPressed:(id)sender;

@property (nonatomic,assign)id delegate;

@end
