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
    self = [super init];
    if (self) {
        _decisionID = [dictionary objectForKey:@"id"];
        Boxer *b = [[Boxer alloc] init];
        b.boxerID = [dictionary objectForKey:@"winner_id"];
        
        _winner = b;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"I thought %@ beat %@",self.winner.lastName, self.loser.lastName];
}

@end
