//
//  NewCommentsDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "NewCommentsDisplayVC.h"

@interface NewCommentsDisplayVC ()

@end

@implementation NewCommentsDisplayVC

- (NSArray *)sortCommentsArray:(NSArray *)array
{
    return [array sortedArrayUsingComparator: ^(id a, id b) {
        NSDate *d1 = [(Comment *)a date];
        NSDate *d2 = [(Comment *)b date];
        return [d2 compare:d1];
    }];
}

@end
