//
//  URLS.m
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "URLS.h"

@implementation URLS

+(BOOL)prod
{
    return YES;
}

+(NSString *)urlStringForPostingPickForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.113:3000/api/fights/";
    }
    url = [url stringByAppendingString:fight.fightID.description];
    url = [url stringByAppendingString:@"/picks?"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"session_token=%@",[Auth sessionToken]]];
    
    return url;
}

+(NSString *)urlStringForRailsSignIn
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/signin";
    } else {
        url = @"http://192.168.1.113:3000/api/signin";
    }
    return @"http://the-boxing-app.herokuapp.com/api/signin";
}

+(NSString *)urlStringForUsersTwitterWithScreenname:(NSString *)screenname
{
    return  [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", screenname];
}

+(NSURL *)urlForUpcomingFights
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/future";
    } else {
        url = @"http://192.168.1.113:3000/api/fights/future";
    }
    return [NSURL URLWithString:url];
}

+(NSURL *)urlForRecentFights
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/past";
    } else {
        url = @"http://192.168.1.113:3000/api/fights/past";
    }
    return [NSURL URLWithString:url];
}

+(NSURL *)urlForFeed
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/picks";
    } else {
        url = @"http://192.168.1.113:3000/api/picks";
    }
    return [NSURL URLWithString:url];
}

+(NSString *)urlForUsersCurrentPickForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.113:3000/api/fights/";
    }
    NSLog(@"%@",[url stringByAppendingString:[NSString stringWithFormat:@"%@?session_token=%@",fight.fightID.description,[Auth sessionToken]]]);
    return [url stringByAppendingString:[NSString stringWithFormat:@"%@?session_token=%@",fight.fightID.description,[Auth sessionToken]]];
}

@end
