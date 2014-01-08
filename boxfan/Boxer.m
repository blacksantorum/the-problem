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

-(NSString *)boxerFullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@",self.firstName,self.lastName,self.country];
}

@end
