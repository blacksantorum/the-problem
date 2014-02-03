//
//  NoCommentsCell.m
//  boxfan
//
//  Created by Chris Tibbs on 2/3/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "NoCommentsCell.h"

@implementation NoCommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"NoCommentsCell" owner:self options:nil];
            self = [nibArray objectAtIndex:0];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
