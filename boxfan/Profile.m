//
//  Profile.m
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSString *mantra = [dictionary objectForKey:@"mantra"];
        if (![JSONDataNullCheck isNull:mantra]) {
            _mantra = mantra;
        }
        
        NSString *favoriteFight = [dictionary objectForKey:@"favorite_fight"];
        if (![JSONDataNullCheck isNull:favoriteFight]) {
            _favoriteFight = favoriteFight;
        }
        
        NSString *firstFight = [dictionary objectForKey:@"first_fight"];
        if (![JSONDataNullCheck isNull:firstFight]) {
            _firstFight = firstFight;
        }
        
        NSString *favoriteBoxer = [dictionary objectForKey:@"favorite_boxer"];
        if (![JSONDataNullCheck isNull:favoriteBoxer]) {
            _favoriteBoxer = favoriteBoxer;
        }
        
        NSDictionary *FOYdictionary = [dictionary objectForKey:@"foy"];
        if (![JSONDataNullCheck isNull:FOYdictionary]) {
            _FOY = [[Fight alloc] initWithDictionary:FOYdictionary];
        }
    }
    return self;
}

@end
