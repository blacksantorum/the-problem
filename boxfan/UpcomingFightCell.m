//
//  UpcomingFightCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/20/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UpcomingFightCell.h"

@implementation UpcomingFightCell

@synthesize boxerACountryFlag;
@synthesize boxerALabel;
@synthesize boxerBCountryFlag;
@synthesize boxerBLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"UpcomingFightCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

@end
