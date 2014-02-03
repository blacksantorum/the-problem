//
//  FightInfoCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FightInfoCell.h"
#import "ScheduleFormattedDate.h"

@implementation FightInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FightInfoCell" owner:self options:nil];
            self = [nibArray objectAtIndex:0];
            self.dateLabel.text = [ScheduleFormattedDate sectionHeaderFormattedStringFromDate:self.fight.date];
            self.locationLabel.text = self.fight.location;
            self.roundsWeightLabel.text = [NSString stringWithFormat:@"%@ rounds at %@",self.fight.rounds,self.fight.weight];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)FOYButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showFOYChangeAlertView)]) {
        [self.delegate showFOYChangeAlertView];
    }
}
@end
