//
//  PickInfoCell.h
//  boxfan
//
//  Created by Chris Tibbs on 1/21/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Boxer.h"
#import "Pick.h"

@interface PickInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *makePickButton;
@property (nonatomic,strong) Pick *pick;
@property (nonatomic,strong) Boxer *boxerA;
@property (nonatomic,strong) Boxer *boxerB;
@property (strong,nonatomic) NSDictionary *boxersToPickPercentages;


- (IBAction)makePickButtonPressed:(id)sender;

@end
