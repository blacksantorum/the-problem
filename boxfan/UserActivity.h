//
//  UserActivity.h
//  boxfan
//
//  Created by Chris Tibbs on 1/20/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Fight.h"
#import "Boxer.h"

typedef enum ActivityType : NSInteger {
    PICK,
    DECISION
} ActivityType;

@interface UserActivity : NSObject

@property NSInteger activityType;
@property (nonatomic, strong)  NSDate *modifiedDate;
@property (nonatomic, strong) NSString *pickID;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Fight *fight;
@property (nonatomic,strong) Boxer *winner;
@property (nonatomic,strong) Boxer *loser;
@property  BOOL byStoppage;

-(instancetype)initForFeedViewWithPickDictionary:(NSDictionary *)dictionary;
-(instancetype)initForFeedViewWithDecisionDictionary:(NSDictionary *)dictionary;

@end
