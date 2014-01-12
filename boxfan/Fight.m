//
//  Fight.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "Fight.h"
#import "Boxer.h"

@interface Fight() {
    NSDictionary *_dictionary;
}

@end

@implementation Fight

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",self.fightID,self.date,self.weight,self.location,self.rounds,self.winnerID,self.stoppage];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _dictionary = dictionary;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:[dictionary objectForKey:@"date"]];
        
        _fightID = [dictionary objectForKey:@"id"];
        _date = date;
        _weight = [dictionary objectForKey:@"weight"];
        _location = [dictionary objectForKey:@"location"];
        
       // NSArray *boxers = [dictionary objectForKey:@"boxers"];
        
       // _boxers = boxers;
        _rounds = [dictionary objectForKey:@"rounds"];
        _winnerID = [dictionary objectForKey:@"winner_id"];
        _stoppage = [dictionary objectForKey:@"stoppage"];
    }
    return self;
}

-(NSString *)titleForScheduleView
{
    NSString *title = [[NSString alloc] init];
    
    Boxer *aSide = [self.boxers objectAtIndex:0];
    Boxer *bSide = [self.boxers objectAtIndex:1];
    
     // we want "<A-side boxer> - <B-side boxer>"
    title = [NSString stringWithFormat:@"%@ - %@",[aSide lastName],[bSide lastName]];
    
    return title;
}

@end
