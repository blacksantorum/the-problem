//
//  Fight.h
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fight : NSObject

@property (nonatomic,strong) NSString *fightID;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSString *location;

// [ A-side boxer, B-side boxer]
@property (nonatomic, strong) NSArray  *boxers;

@property (nonatomic, strong) NSString *rounds;

@property (nonatomic,strong) NSNumber *winnerID;

@property BOOL stoppage;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)titleForScheduleView;
-(NSString *)titleForRecentFightsView;

@end
