//
//  ListOfFightsVC.h
//  boxfan
//
//  Created by Chris Tibbs on 1/26/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "BoxingAppDVC.h"
#import "Boxer.h"

@interface ListOfFightsVC : BoxingAppDVC

@property (nonatomic,strong) NSArray *fightDates;
@property (nonatomic,strong) NSArray *fights;

- (NSArray *)fightsForDate:(NSDate *)date;
- (NSString *)boxerNameDisplay:(Boxer *)boxer;

@end
