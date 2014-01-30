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
    NSInteger newJabs = [self.totalJabsLabel.text integerValue];
    
    if (self.comment.isJabbedByLoggedInUser) {
        newJabs--;
    } else {
        newJabs++;
    }
    self.totalJabsLabel.text = [NSString stringWithFormat:@"%ld",(long)newJabs];
    
    if (self.comment.isJabbedByLoggedInUser) {
        [self.jabButton setImage:[UIImage imageNamed:@"notjabbed"] forState:UIControlStateNormal];
    } else {
        [self.jabButton setImage:[UIImage imageNamed:@"jabbed"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(jabComment:)]) {
        [self.delegate jabComment:self.comment];
    }
    self.comment.isJabbedByLoggedInUser = !self.comment.isJabbedByLoggedInUser;
}

- (IBAction)twitterHandleButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showUser:)]) {
        [self.delegate showUser:self.comment.author];
    }
}

@end
