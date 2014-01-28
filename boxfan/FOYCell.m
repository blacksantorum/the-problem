//
//  FOYCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FOYCell.h"

@implementation FOYCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FOYCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

@end
