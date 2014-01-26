//
//  Comment.m
//  boxfan
//
//  Created by Chris Tibbs on 1/24/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _commentID = [[dictionary objectForKey:@"id"] integerValue];
        _date = [dictionary objectForKey:@"created_at"];
        _content = [dictionary objectForKey:@"body"];
        _author = [[User alloc] initWithListOfUsersDictionary:[dictionary objectForKey:@"user"]];
    }
    return self;
}

@end
