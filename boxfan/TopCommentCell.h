//
//  TopCommentCell.h
//  boxfan
//
//  Created by Chris Tibbs on 2/4/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface TopCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalJabsLabel;

@property (strong,nonatomic) Comment *comment;


@end
