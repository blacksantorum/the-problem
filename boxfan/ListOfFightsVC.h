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

// all of the fights that take place on a certain date
- (NSArray *)fightsForDate:(NSDate *)date;

// "F. Mayweather"
- (NSString *)boxerNameDisplay:(Boxer *)boxer;

// override this to change how the fights table view is sorted by date
- (NSArray *)appropriatelySortedDateArray:(NSArray *)dateArray;

@end
