//
//  Pick.h
//  boxfan
//
//  Created by Chris Tibbs on 12/16/13.
//  Copyright (c) 2013 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Fight.h"

@interface Pick : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Fight *fight;

// 1 if a-side, 2 if b-side.. no draws, that's bitch shit
@property (nonatomic,strong) NSNumber *winner;

// YES or NO
@property (nonatomic,strong) NSNumber *byStoppage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
