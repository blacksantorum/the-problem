//
//  FightInfoCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fight.h"

@protocol ChangeFOYDelegate <NSObject>

- (void)showFOYChangeAlertView;

@end

@interface FightInfoCell : UITableViewCell

@property (strong, nonatomic) Fight *fight;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundsWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *FOYButton;

- (IBAction)FOYButtonPressed:(id)sender;

@property (nonatomic,assign)id delegate;

@end
