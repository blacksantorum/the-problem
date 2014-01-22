//
//  PickInfoCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "PickInfoCell.h"
#import "BarChartView.h"

@interface PickInfoCell ()

@property (weak, nonatomic) IBOutlet BarChartView *communityPicksBarChart;

@end

@implementation PickInfoCell

-(NSString *)pickCellButtonRepresentationForPick:(Pick *)pick
{
    return [NSString stringWithFormat:@"%@ %@",pick.winner.lastName,pick.byStoppage ? @"by KO" : @"by decision"];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PickInfoCell" owner:self options:nil];
            self = [nibArray objectAtIndex:0];
            if (self.pick) {
                self.makePickButton.titleLabel.text = [self pickCellButtonRepresentationForPick:self.pick];
            }
            
            NSString *titleA = [NSString stringWithFormat:@"%@ %@%%",self.boxerA.boxerFullName,self.boxersToPickPercentages[self.boxerA.boxerFullName]];
            NSString *titleB = [NSString stringWithFormat:@"%@ %@%%",self.boxerB.boxerFullName,self.boxersToPickPercentages[self.boxerB.boxerFullName]];
            
            NSArray *array = [self.communityPicksBarChart createChartDataWithTitles:[NSArray arrayWithObjects:titleA, titleB, nil]
                                                          values:[NSArray arrayWithObjects:self.boxersToPickPercentages[self.boxerA.boxerFullName], self.boxersToPickPercentages[self.boxerB.boxerFullName], nil]
                                                          colors:[NSArray arrayWithObjects:@"17A9E3", @"E32F17", nil]
                                                     labelColors:[NSArray arrayWithObjects:@"000000", @"000000",nil]];
            
            [self.communityPicksBarChart setDataWithArray:array
                                                 showAxis:DisplayOnlyXAxis
                                                withColor:[UIColor whiteColor]
                                  shouldPlotVerticalLines:NO];
            
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)makePickButtonPressed:(id)sender {
}
@end
