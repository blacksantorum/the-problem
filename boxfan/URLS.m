//
//  URLS.m
//  boxfan
//
//  Created by Chris Tibbs on 1/10/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "URLS.h"

@implementation URLS

+(NSURL *)authURL
{
   return [NSURL URLWithString:@"http://the-boxing-app.herokuapp.com/auth/twitter"];
}

@end
