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
#import <MSSimpleGauge/MSSimpleGauge.h>

@protocol ChangePickDelegate <NSObject>

-(void)changePick;

@end

@interface PickInfoCell : UITableViewCell  {
}

@property (strong,nonatomic) MSSimpleGauge *gauge;

@property (weak, nonatomic) IBOutlet UIButton *makePickButton;
@property (weak, nonatomic) IBOutlet UILabel *yourPickLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPickDescriptionLabel;

@property CGFloat boxerBPercentage;

@property (nonatomic,strong) Pick *pick;
@property (nonatomic,strong) Fight *fight;

- (IBAction)makePickButtonPressed:(id)sender;

@property (nonatomic,assign)id delegate;

@end
