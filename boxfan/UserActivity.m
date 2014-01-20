//
//  UserActivity.m
//  boxfan
//
//  Created by Chris Tibbs on 1/20/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "UserActivity.h"

@implementation UserActivity

-(instancetype)initForFeedViewWithPickDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _activityType = PICK;
        _modifiedDate = [dictionary valueForKey:@"updated_at"];
        _user = [[User alloc] initWithListOfUsersDictionary:[dictionary valueForKey:@"user"]];
        Fight *fight = [[Fight alloc] init];
        fight.fightID = [dictionary valueForKeyPath:@"fight.id"];
        _fight = fight;
        
        NSString *winnerID = [dictionary valueForKey:@"winner_id"];
        
        NSString *koObj = [dictionary valueForKeyPath:@"ko"];
        NSString *ko = koObj.description;
        if ([ko isEqualToString:@"1"]) {
            _byStoppage = YES;
        } else if ([ko isEqualToString:@"0"]) {
            _byStoppage = NO;
        }
        
        for (NSDictionary *boxerDict in [dictionary valueForKeyPath:@"fight.boxers"]) {
            Boxer *boxer = [[Boxer alloc] initWithDictionary:boxerDict];
            if ([boxer.boxerID.description isEqualToString:winnerID.description]) {
                _winner = boxer;
            } else {
                _loser = boxer;
            }
        }
    }
    return self;
}

-(instancetype)initForFeedViewWithDecisionDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _activityType = DECISION;
        _byStoppage = nil;
        _modifiedDate = [dictionary valueForKey:@"updated_at"];
        _user = [[User alloc] initWithListOfUsersDictionary:[dictionary valueForKey:@"user"]];
        Fight *fight = [[Fight alloc] init];
        fight.fightID = [dictionary valueForKeyPath:@"fight.id"];
        _fight = fight;
        
        NSString *winnerID = [dictionary valueForKey:@"winner_id"];
        
        for (NSDictionary *boxerDict in [dictionary valueForKeyPath:@"fight.boxers"]) {
            Boxer *boxer = [[Boxer alloc] initWithDictionary:boxerDict];
            if ([boxer.boxerID.description isEqualToString:winnerID.description]) {
                _winner = boxer;
            } else {
                _loser = boxer;
            }
        }
    }
    return self;
}

@end
