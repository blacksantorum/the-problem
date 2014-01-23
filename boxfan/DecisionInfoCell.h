//
//  DecisionInfoCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/22/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartView.h"

@interface DecisionInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *makeDecisionButton;

@property (weak, nonatomic) IBOutlet BarChartView *communityDecisionBarChart;

- (IBAction)makeDecisionButtonPressed:(id)sender;
@end
