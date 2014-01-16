//
//  URLS.h
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fight.h"

@interface URLS : NSObject

+(NSString *)urlStringForPostingPickForFight:(Fight *)fight;
+(NSString *)urlStringForRailsSignIn;
+(NSString *)urlStringForUsersTwitterWithScreenname:(NSString *)screenname;
+(NSString *)urlForUsersCurrentPickForFight:(Fight *)Fight;

+(NSURL *)urlForFeed;
+(NSURL *)urlForUpcomingFights;
+(NSURL *)urlForRecentFights;
+(NSURL *)urlForUsers;

+(BOOL)prod;

@end
