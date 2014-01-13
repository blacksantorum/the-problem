//
//  Pick.m
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "Pick.h"

@implementation Pick

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _fight = [dictionary objectForKey:@"fight"];
        _winner = [dictionary objectForKey:@"winner"];
        NSString *byStoppage = [dictionary objectForKey:@"byStoppage"];
        if ([byStoppage isEqualToString:@"true"]) {
            _byStoppage = YES;
        } else if ([byStoppage isEqualToString:@"false"]) {
            _byStoppage = NO;
        }
    }
    return self;
}

-(NSString *)feedRepresentation
{
    NSString *byStoppageString = [[NSString alloc] init];
    if (self.byStoppage) {
        byStoppageString = @"by decision";
    } else {
        byStoppageString = @"by KO";
    }
    
    NSString *feedRep = [NSString stringWithFormat:@"%@ picked %@ over %@ %@",self.user.name,self.winner.boxerFullName,self.loser.boxerFullName,byStoppageString];
    
    return feedRep;
}

-(instancetype)initWithIDDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _user = self.user;
        
        Fight *f = [[Fight alloc] init];
        f.fightID = [dictionary objectForKey:@"fight_id"];
        _fight = f;
        
        Boxer *w = [[Boxer alloc] init];
        w.boxerID = [dictionary objectForKey:@"winner_id"];
        _winner = w;
        
        Boxer *l = [[Boxer alloc] init];
        l.boxerID = [dictionary objectForKey:@"loser_id"];
        _loser = l;
        
        NSString *byStoppage = [dictionary objectForKey:@"ko"];
        if ([byStoppage isEqualToString:@"1"]) {
            _byStoppage = YES;
        } else if ([byStoppage isEqualToString:@"0"]) {
            _byStoppage = NO;
        }
    }
    
    return self;
}

@end
