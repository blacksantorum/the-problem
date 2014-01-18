//
//  RecentFightsDisplayVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/18/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fight.h"
#import "Decision.h"
#import "FightDisplayVC.h"

@interface RecentFightsDisplayVC : FightDisplayVC

@property (nonatomic,strong) Decision *decision;

@end
