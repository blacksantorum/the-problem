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

@end
