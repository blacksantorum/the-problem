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
        _byStoppage = [dictionary objectForKey:@"byStoppage"];
    }
    return self;
}

@end
