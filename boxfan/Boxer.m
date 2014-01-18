//
//  Boxer.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "Boxer.h"

@implementation Boxer

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _firstName = [dictionary objectForKey:@"first_name"];
        _lastName = [dictionary objectForKey:@"last_name"];
        _country = [dictionary objectForKey:@"country"];
        _boxerID = [dictionary objectForKey:@"id"];
    }
    
    return self;
}

-(instancetype)initWithRecentFightVewDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _firstName = [dictionary objectForKey:@"first_name"];
        _lastName = [dictionary objectForKey:@"last_name"];
        _country = [dictionary objectForKey:@"country"];
        _boxerID = [dictionary objectForKey:@"id"];
        
        NSString *pickPercent = [dictionary objectForKey:@"percent_pick"];
        _pickPercentage = [pickPercent.description stringByAppendingString:@"%"];
        
        NSString *decisionPercent = [dictionary objectForKey:@"percent_decision"];
        _decisionPercentage = [decisionPercent.description stringByAppendingString:@"%"];
        
    }
    
    return self;
}

-(NSString *)boxerFullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@,%@,%@",self.boxerID,self.firstName,self.lastName,self.country];
}

@end
