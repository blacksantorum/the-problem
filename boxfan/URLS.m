//
//  URLS.m
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "URLS.h"

@implementation URLS

+(NSString *)appendSessionToken:(NSString *)urlString
{
    return [urlString stringByAppendingString:[NSString stringWithFormat:@"?session_token=%@",[Auth sessionToken]]];
}

+(NSString *)appendSessionTokenForGods:(NSString *)urlString
{
    return [urlString stringByAppendingString:[NSString stringWithFormat:@"&session_token=%@",[Auth sessionToken]]];
}

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
        url = @"http://192.168.1.140:3000/api/fights/";
    }
    url = [url stringByAppendingString:fight.fightID.description];
    url = [url stringByAppendingString:@"/picks"];
    
    return [URLS appendSessionToken:url];
}

+(NSString *)urlStringForPostingDecisionForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/";
    }
    url = [url stringByAppendingString:fight.fightID.description];
    url = [url stringByAppendingString:@"/decisions"];
    
    return [URLS appendSessionToken:url];
}

+ (NSString *)urlStringForJabbingComment:(Comment *)comment
{
    NSString *url;
    if ([URLS prod]) {
        url = [NSString stringWithFormat:@"http://the-boxing-app.herokuapp.com/api/comments/%@/like",[NSString stringWithFormat:@"%ld",(long)comment.commentID]];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.1.140:3000/api/comments/%@/like",[NSString stringWithFormat:@"%ld",(long)comment.commentID]];
    }
    return [URLS appendSessionToken:url];
}

+ (NSString *)urlStringForUnjabbingComment:(Comment *)comment
{
    NSString *url;
    if ([URLS prod]) {
        url = [NSString stringWithFormat:@"http://the-boxing-app.herokuapp.com/api/comments/%@/unlike",[NSString stringWithFormat:@"%ld",(long)comment.commentID]];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.1.140:3000/api/comments/%@/unlike",[NSString stringWithFormat:@"%ld",(long)comment.commentID]];
    }
    return [URLS appendSessionToken:url];
}

+ (NSString *)urlStringForPostingCommentForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/";
    }
    url = [url stringByAppendingString:fight.fightID.description];
    url = [url stringByAppendingString:@"/comments"];
    
    return [URLS appendSessionToken:url];
}

+ (NSString *)urlStringForUpdatingProfileForUser:(User *)user
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/users/";
    } else {
        url = @"http://192.168.1.140:3000/api/users/";
    }
    url = [url stringByAppendingString:user.userID.description];
    
    return [URLS appendSessionToken:url];
}

+(NSString *)urlStringForRailsSignIn
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/signin";
    } else {
        url = @"http://192.168.1.140:3000/api/signin";
    }
 
    return url;
}

+ (NSString *)urlStringForUsersTwitterWithScreenname:(NSString *)screenname
{
    return  [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", screenname];
}

+ (NSString *)urlStringForUpdatingFOYtoFight:(Fight *)fight
{
    NSString *url;
    if ([URLS prod]) {
        url = [NSString stringWithFormat:@"http://the-boxing-app.herokuapp.com/api/fights/%@/foy",fight.fightID.description];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.1.140:3000/api/fights/%@/foy",fight.fightID.description];
    }
    return [URLS appendSessionToken:url];
}

+ (NSURL *)urlForUpcomingFights
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/future";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/future";
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSURL *)urlForRecentFights
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/past";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/past";
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSURL *)urlForFeed
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/feed";
    } else {
        url = @"http://192.168.1.140:3000/api/feed";
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSString *)urlForUsersCurrentPickForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/";
    }
    return [url stringByAppendingString:[NSString stringWithFormat:@"%@?session_token=%@",fight.fightID.description,[Auth sessionToken]]];
}

+ (NSString *)urlForUsersCurrentDecisionForFight:(Fight *)fight
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    } else {
        url = @"http://192.168.1.140:3000/api/fights/";
    }
    return [url stringByAppendingString:[NSString stringWithFormat:@"%@?session_token=%@",fight.fightID.description,[Auth sessionToken]]];
}

+ (NSURL *)urlForUsers
{
    NSString *url = [[NSString alloc] init];
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/users";
    } else {
        url = @"http://192.168.1.140:3000/api/users";
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSURL *)urlForPicksOfUser:(User *)user
{
    NSString *url = [[NSString alloc] init];
    
    if ([URLS prod]) {
        url = [@"http://the-boxing-app.herokuapp.com/api/users/" stringByAppendingString:user.userID.description];
    } else {
        url = [@"http://192.168.1.140:3000/api/users/" stringByAppendingString:user.userID.description];
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSURL *)urlForGods
{
    NSString *url = [[NSString alloc] init];
    
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/users?top=10";
    } else {
        url = @"http://192.168.1.140:3000/api/users?top=10";
    }
    return [NSURL URLWithString:[URLS appendSessionTokenForGods:url]];
}

+ (NSURL *)baseURL
{
    NSString *url;
    if ([URLS prod]) {
        url = @"http://the-boxing-app.herokuapp.com/api/";
    } else {
        url = @"http://192.168.1.140:3000/api/";
    }
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlForCommentsForFight:(Fight *)fight
{
    NSString *url;
    if ([URLS prod]) {
        url  = [NSString stringWithFormat:@"http://the-boxing-app.herokuapp.com/api/fights/%@/comments",fight.fightID.description];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.1.140:3000/api/fights/%@/comments",fight.fightID.description];
    }
    return [NSURL URLWithString:[URLS appendSessionToken:url]];
}

+ (NSURL *)urlForTwitterAuth;
{
    return [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
}

+ (NSURL *)urlForTBATwitterAuth;
{
    return [NSURL URLWithString:@"http://www.theboxingapp.com/auth/twitter"];
}

@end
