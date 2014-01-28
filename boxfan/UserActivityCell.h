//
//  UserActivityCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/28/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;

@end
