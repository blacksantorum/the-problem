//
//  ListOfFightsCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/26/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfFightsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *boxerALabel;
@property (weak, nonatomic) IBOutlet UIImageView *boxerACountryFlag;
@property (weak, nonatomic) IBOutlet UILabel *boxerBLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boxerBCountryFlag;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@end
