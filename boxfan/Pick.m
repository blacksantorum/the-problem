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
        NSMutableArray *boxerArray = [[NSMutableArray alloc] init];
        for (NSDictionary *boxerDict in [dictionary valueForKeyPath:@"fight.boxers"]) {
            Boxer *b = [[Boxer alloc] initWithDictionary:boxerDict[@"boxer"]];
            [boxerArray addObject:b];
        }
        
        NSString *winnerID = [dictionary valueForKeyPath:@"fight.pick.winner_id"];
        Boxer *b = [boxerArray firstObject];
        
        if ([b.boxerID.description  isEqualToString:winnerID.description]) {
            _winner = b;
            _loser = [boxerArray lastObject];
        } else {
            _winner = [boxerArray lastObject];
            _loser = b;
        }
        
        NSString *koObj = [dictionary valueForKeyPath:@"fight.pick.ko"];
        NSString *ko = koObj.description;
        if ([ko isEqualToString:@"1"]) {
            _byStoppage = YES;
        } else if ([ko isEqualToString:@"0"]) {
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

-(NSString *)description
{
    return [self feedRepresentation];
}

@end
