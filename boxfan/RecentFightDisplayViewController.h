//
//  RecentFightDisplayViewController.h
//  boxfan
//
//  Created by Chris Tibbs on 1/22/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FightDisplayVC.h"
#import "Decision.h"
#import "FightInfoCell.h"

@interface RecentFightDisplayViewController : FightDisplayVC <ChangeFOYDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) Decision *decision;

@end
