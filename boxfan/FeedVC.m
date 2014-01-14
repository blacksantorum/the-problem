//
//  FeedVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/13/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "FeedVC.h"

@interface FeedVC ()

@end

@implementation FeedVC

-(NSURL *)urlForRequest
{
    return [URLS urlForFeed];
}

@end
