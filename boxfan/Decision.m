//
//  Decision.m
//  boxfan
//
//  Created by Chris Tibbs on 1/18/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "Decision.h"

@implementation Decision

-(instancetype)initWithRecentFightDisplayDictionary:(NSDictionary *)dictionary
{
    if (![JSONDataNullCheck isNull:dictionary]) {
        self = [super init];
        if (self) {
            _decisionID = [dictionary objectForKey:@"id"];
            NSMutableArray *boxerArray = [[NSMutableArray alloc] init];
            for (NSDictionary *boxerDict in [dictionary valueForKeyPath:@"fight.boxers"]) {
                Boxer *b = [[Boxer alloc] initWithRecentFightVewDictionary:boxerDict];
                [boxerArray addObject:b];
            }
            NSString *winnerID = [dictionary objectForKey:@"winner_id"];
            for (Boxer *b in boxerArray) {
                if ([b.boxerID.description isEqualToString:winnerID.description]) {
                    _winner = b;
                } else {
                    _loser = b;
                }
            }
        }
    }
    NSLog(@"Decision: %@",self);
    return self;
}

-(instancetype)initWithDisplayedUserView:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _decisionID = [dictionary valueForKeyPath:@"decision.id"];
        Fight *fight = [[Fight alloc] init];
        fight.fightID = [dictionary valueForKeyPath:@"decision.fight_id"];
        _fight = fight;
        
        NSString *winnerID = [dictionary valueForKeyPath:@"decision.winner_id"];
        
        for (NSDictionary *boxerDict in [dictionary valueForKeyPath:@"decision.fight.boxers"]) {
            Boxer *b = [[Boxer alloc] initWithDictionary:[boxerDict valueForKey:@"boxer"]];
            if ([b.boxerID.description isEqualToString:winnerID.description]) {
                _winner = b;
            } else {
                _loser = b;
            }
        }
        
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"I thought %@ beat %@",self.winner.lastName, self.loser.lastName];
}

-(NSString *)usersDisplayViewRepresentation
{
    return [NSString stringWithFormat:@"Thought %@ beat %@",self.winner.lastName,self.loser.lastName];
}

@end
