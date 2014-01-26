//
//  MostJabbedCommentsDisplayVC.m
//  boxfan
//
//  Created by Chris Tibbs on 1/25/14.
//  Copyright (c) 2014 Chris Tibbs. All rights reserved.
//

#import "MostJabbedCommentsDisplayVC.h"

@interface MostJabbedCommentsDisplayVC ()

@end

@implementation MostJabbedCommentsDisplayVC

- (NSArray *)sortCommentsArray:(NSArray *)array
{
    return [array sortedArrayUsingComparator: ^(id a, id b) {
        NSInteger j1 = [(Comment *)a jabs];
        NSInteger j2 = [(Comment *)b jabs];
        return j1 > j2;
    }];
}

@end
