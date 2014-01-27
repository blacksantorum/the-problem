//
//  Profile.h
//  boxfan
//
//  Created by Chris Tibbs on 1/27/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property (strong,nonatomic) User *profileUser;
@property (strong,nonatomic) NSString *mantra;
@property (strong,nonatomic) NSString *favoriteFight;
@property (strong,nonatomic) NSString *firstFight;
@property (strong,nonatomic) NSString *favoriteBoxer;
@property (strong,nonatomic) Fight *FOY;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
