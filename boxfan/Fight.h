//
//  Fight.h
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fight : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *location;

// [ A-side boxer, B-side boxer]
@property (nonatomic, strong) NSArray  *boxers;

@property (nonatomic, strong) NSString *rounds;

// a- side won? winner is 1
// b- side won? winner is 2
// draw? winner is 9
// fight hasn't happened yet? winner is 0
@property (nonatomic,strong) NSNumber *winner;

// 1 = YES or 0 if decision or there's no result yet
@property (nonatomic,strong) NSNumber *wasStoppage;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)titleForScheduleView;

@end
