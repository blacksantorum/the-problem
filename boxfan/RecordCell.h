//
//  RecordCell.h
//  boxfan
//
//  Created by Chris Tibbs on 2/5/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *correctPicksLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectPicksLabel;

@end
