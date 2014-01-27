//
//  CommentCell.m
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}


- (IBAction)jabButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jabComment:)]) {
        [self.delegate jabComment:self.comment];
    }
}

@end
