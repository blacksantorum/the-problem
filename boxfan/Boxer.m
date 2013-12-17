//
//  Boxer.m
//  boxfan
//
//  Created by Chris Tibbs on 12/15/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import "Boxer.h"

@implementation Boxer

-(instancetype)initWithFirst:(NSString *)first
                        Last:(NSString *)last
                     Country:(NSString *)country
{
    self = [super init];
    if (self) {
        _firstName = first;
        _lastName = last;
        _country = country;
    }
    return self;
}

-(NSString *)boxerFullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}

@end
