//
//  UserActivityCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/28/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UserActivityCell.h"

@implementation UserActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"UserActivityCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
