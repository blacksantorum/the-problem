//
//  URLS.m
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "URLS.h"

@implementation URLS

+(NSString *)urlStringForPostingPickForFight:(Fight *)fight
{
    // NSString *url = @"http://192.168.1.113:3000/api/fights/";
    NSString *url = @"http://the-boxing-app.herokuapp.com/api/fights/";
    url = [url stringByAppendingString:fight.fightID.description];
    url = [url stringByAppendingString:@"/picks?"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"session_token=%@",[Auth sessionToken]]];
    
    return url;
}

@end
